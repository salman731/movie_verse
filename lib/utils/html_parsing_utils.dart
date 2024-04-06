
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class WebUtils
{
   static Future<dom.Document> getDomFromURL (String url) async
   {
     http.Response response = await http.Client().get(Uri.parse(url));
     return parser.parse(response.body);
   }

   static Future<String?> makeGetRequest(String url,
       {Map<String, String>? headers}) async
   {
     http.Response response = await http.Client().get(Uri.parse(url),headers: headers);
     return response.body!;
   }

   static dom.Document getDomfromHtml (String html)
   {
     return parser.parse(html);
   }

   static Future<String?> getOriginalUrl(url) async {
     try {
       final client = HttpClient();
       var uri = Uri.parse(url);
       var request = await client.getUrl(uri);
       request.followRedirects = false;
       var response = await request.close();
       if(response.isRedirect)
              {
                response.drain();
                return response.headers.value(HttpHeaders.locationHeader);
              }
     } catch (e) {
       print(e);
     }
     /*while () {
       response.drain();
       final location = response.headers.value(HttpHeaders.locationHeader);

       if (location != null) {
         uri = uri.resolve(location);
         request = await client.getUrl(uri);
         // Set the body or headers as desired.

         if (location.toString().contains('https://www.xxxxx.com')) {
           return location.toString();
         }
         request.followRedirects = false;
         response = await request.close();
       }
     }*/
   }

}