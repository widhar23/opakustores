import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/utils.dart';
import 'package:opakuStore/src/views/HomePage/Customer/chat_view.dart';
import 'package:opakuStore/src/widgets/card_user_info.dart';

class CustomerUserListView extends StatefulWidget {
  @override
  _CustomerUserListViewState createState() => _CustomerUserListViewState();
}

class _CustomerUserListViewState extends State<CustomerUserListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Users')
            .orderBy('create_at')
            .where('type', isEqualTo: 'customer')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            int index = 0;
            return ListView(
              children: snapshot.data.documents
                  .map((DocumentSnapshot document) {
                    index++;
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Chat',
                          color: kColorBlue,
                          icon: Icons.chat,
                          onTap: () {
                            //TODO: CHAT
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          isAdmin: true,
                                          uidCustomer: document.documentID,
                                        )));
                          },
                        ),
                      ],
                      child: UserInfoCard(
                          id: index.toString(),
                          username: document['username'],
                          fullname: document['fullname'],
                          phone: document['phone'],
                          isAdmin: false,
                          createAt: Util.convertDateToFullString(
                              document['create_at'])),
                    );
                  })
                  .toList()
                  .reversed
                  .toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
