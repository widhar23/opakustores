import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:opakuStore/src/helpers/chat_const.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/helpers/shared_preferrence.dart';
import 'package:opakuStore/src/widgets/message_bubble.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.isAdmin = false, this.uidCustomer = '', this.type});
  final bool isAdmin;
  final String uidCustomer;
  final String type;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  List<MessageBubble> messageBubbles = [];
  String messageText;
  String uid = '';
  List<Asset> images = [];
  StreamController _controller = new StreamController();

  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin) {
      uid = widget.uidCustomer;
      _controller.sink.add(widget.uidCustomer);
    } else {
      StorageUtil.getUid().then((uid) {
        _controller.sink.add(uid);
        this.uid = uid;
      });
    }
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  //TODO: Image product holder
  Widget imageGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: EdgeInsets.all(ConstScreen.sizeDefault),
          child: Stack(
            children: <Widget>[
              //TODO: image
              AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              //TODO: close
              GestureDetector(
                onTap: () {
                  setState(() {
                    images.removeAt(index);
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: kColorWhite,
                    ),
                    child: Icon(Icons.close,
                        color: kColorBlack,
                        size: ConstScreen.setSizeHeight(30))),
              )
            ],
          ),
        );
      }),
    );
  }

  //TODO Save Image to Firebase Storage
  Future saveImage(List<Asset> asset) async {
    StorageUploadTask uploadTask;
    List<String> linkImage = [];
    for (var value in asset) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
      ByteData byteData = await value.requestOriginal(quality: 70);
      var imageData = byteData.buffer.asUint8List();
      uploadTask = ref.putData(imageData);
      String imageUrl;
      await (await uploadTask.onComplete).ref.getDownloadURL().then((onValue) {
        imageUrl = onValue;
      });
      linkImage.add(imageUrl);
    }
    return linkImage;
  }

  //TODO: load multi image
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "Pick Product Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {}
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: widget.isAdmin
            ? AppBar(
                backgroundColor: kColorWhite,
                iconTheme: IconThemeData.fallback(),
                title: Text(
                  'Chat',
                  style: TextStyle(
                      color: kColorBlack,
                      fontSize: FontSize.setTextSize(32),
                      fontWeight: FontWeight.w500),
                ),
                centerTitle: true,
              )
            : null,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //TODO: Chat space
              StreamBuilder(
                stream: _controller.stream,
                builder: (context, mainSnapshot) {
                  if (mainSnapshot.hasData) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('Chat')
                          .document(mainSnapshot.data)
                          .collection(mainSnapshot.data)
                          .orderBy('timestamp')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData || !mainSnapshot.hasData) {
                          return Container();
                        }
                        final messages = snapshot.data.documents.reversed;
                        messageBubbles = [];
                        for (var message in messages) {
                          final messageText = message.data['text'];
                          final messageSender = message.data['sender'];
                          final List<dynamic> images = message.data['image'];
                          final currentUser = loggedInUser.email;

                          final messageBubble = MessageBubble(
                            context: context,
                            uid: uid,
                            createAt: message.data['timestamp'],
                            documentID: message.documentID,
                            sender: messageSender,
                            text: (messageText != null) ? messageText : '',
                            isAdmin: message.data['is_admin'],
                            isMe: currentUser == messageSender,
                            onlineImagesList:
                                (images != null || images.length != 0)
                                    ? images
                                    : [],
                          );

                          messageBubbles.add(messageBubble);
                        }
                        return Expanded(
                          child: ListView(
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            children: messageBubbles,
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              //TODO: Image holder
              (images.length != 0) ? imageGridView() : Container(),
              //TODO: bottom chat sent
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        loadAssets();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ConstScreen.setSizeWidth(15)),
                        child: Icon(
                          Icons.image,
                          color: kColorBlue,
                          size: ConstScreen.setSizeHeight(50),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    //TODO: sent message
                    FlatButton(
                      onPressed: () async {
                        if (images.length != 0) {
                          List<String> listImages = await saveImage(images);
                          Firestore.instance
                              .collection('Chat')
                              .document(uid)
                              .collection(uid)
                              .add({
                            'roomId': uid,
                            'text': messageText,
                            'is_admin': widget.isAdmin ? true : false,
                            'sender': loggedInUser.email,
                            'image': listImages,
                            'timestamp':
                                DateTime.now().toUtc().millisecondsSinceEpoch
                          });
                        } else {
                          Firestore.instance
                              .collection('Chat')
                              .document(uid)
                              .collection(uid)
                              .add({
                            'roomId': uid,
                            'text': messageText,
                            'is_admin': widget.isAdmin ? true : false,
                            'sender': loggedInUser.email,
                            'image': [],
                            'timestamp':
                                DateTime.now().toUtc().millisecondsSinceEpoch
                          });
                        }
                        messageTextController.clear();
                        setState(() {
                          images.clear();
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle.copyWith(
                            fontSize: FontSize.s36),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
