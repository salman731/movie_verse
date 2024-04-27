package com.example.movie_verse;

import android.content.Intent;
import android.net.Uri;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivityTemp extends FlutterActivity {

    static  final String intentChannel = "INTENT_CHANNEL";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),intentChannel).setMethodCallHandler(
                (call,result) ->
                {
                    if(call.method.equals("openMxPlayer"))
                    {
                        String packagename = "com.mxtech.videoplayer.ad";
                        Intent intent = new Intent(Intent.ACTION_VIEW);
                        intent.setPackage(packagename);
                        intent.setDataAndType(Uri.parse(call.argument("videoUrl")),(String) call.argument("mime"));
                        String[] headers = {"referer",(String) call.argument("referer")};
                        intent.putExtra("headers",headers);
                        intent.putExtra("title", (String) call.argument("title"));
                        MainActivityTemp.this.startActivity(intent);
                    }
                    if (call.method.equals("getDecrptedText"))
                    {
                        //AesHelper aesHelper = new AesHelper();

                    }
                }
        );
    }

/*
    private static String SteamtapeGetDlLink(String link) {
        try {
            if (link.contains("/e/"))
                link = link.replace("/e/", "/v/");
            Document doc = Jsoup.connect(link).get();
            String htmlSource = doc.html();
            Pattern norobotLinkPattern = Pattern.compile("document\\.getElementById\\('norobotlink'\\)\\.innerHTML = (.+);");
            Matcher norobotLinkMatcher = norobotLinkPattern.matcher(htmlSource);
            if (norobotLinkMatcher.find()) {
                String norobotLinkContent = norobotLinkMatcher.group(1);
                Pattern tokenPattern = Pattern.compile("token=([^&']+)");
                Matcher tokenMatcher = tokenPattern.matcher(norobotLinkContent);
                if (tokenMatcher.find()) {
                    String token = tokenMatcher.group(1);
                    Elements divElements = doc.select("div#ideoooolink[style=display:none;]");
                    if (!divElements.isEmpty()) {
                        String streamtape = ((Element) Objects.<Element>requireNonNull(divElements.first())).text();
                        String fullUrl = "https:/" + streamtape + "&token=" + token;
                        return fullUrl + "&dl=1s";
                    }
                }
            }
        } catch (Exception exception) {
            Log.d("exception",exception.toString());
        }
        return null;
    }*/

}
