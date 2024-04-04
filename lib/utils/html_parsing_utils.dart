
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class HtmlParsingUtils
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

}