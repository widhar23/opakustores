package com.example.opaku;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

//import com.google.firebase.quickstart.analytics.webview;

//import android.annotation.SuppressLint;
//import android.os.Build;
//import android.os.Bundle;
//import android.support.v7.app.AppCompatActivity;
//import android.util.Log;
//import android.webkit.WebView;

public class MainActivity extends FlutterActivity {
  @Override
//  private static final String TAG = "MainActivity";

//  private WebView mWebView;

  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    // Initialize WebView and enable JavaScript
//    mWebView = (WebView) findViewById(R.id.webview);
//    mWebView.getSettings().setJavaScriptEnabled(true);
//
//    // Restrict requests in the WebView to a single domain (in this case, our Firebase
//    // Hosting domain) so that no other websites can call into our Java code.
//    String hostingUrl = getHostingUrl();
//    mWebView.setWebViewClient(new SingleDomainWebViewClient(hostingUrl));
//
//    // [START add_javascript_interface]
//    // Only add the JavaScriptInterface on API version JELLY_BEAN_MR1 and above, due to
//    // security concerns, see link below for more information:
//    // https://developer.android.com/reference/android/webkit/WebView.html#addJavascriptInterface(java.lang.Object,%20java.lang.String)
//    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
//      mWebView.addJavascriptInterface(
//              new AnalyticsWebInterface(this), AnalyticsWebInterface.TAG);
//    } else {
//      Log.w(TAG, "Not adding JavaScriptInterface, API Version: " + Build.VERSION.SDK_INT);
//    }
//    // [END add_javascript_interface]
//
//    // Navigate to site
//    mWebView.loadUrl(hostingUrl);
//  }
}
//  private String getHostingUrl() {
//    // Database URl is https://<app-name>.firebaseio.com
//    String databaseUrl = getString(R.string.firebase_database_url);
//
//    // Hosting URL is https://<app-name>.firebaseapp.com
//    return databaseUrl.replace("firebaseio", "firebaseapp");
  }
