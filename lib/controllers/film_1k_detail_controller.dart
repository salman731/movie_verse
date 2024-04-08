

import 'dart:convert';

import 'package:Movieverse/enums/video_hoster_enum.dart';
import 'package:Movieverse/models/film_1k_cover.dart';
import 'package:Movieverse/models/film_1k_detail.dart';
import 'package:Movieverse/utils/html_parsing_utils.dart';
import 'package:Movieverse/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;

class Film1kController extends GetxController
{
  late dom.Document movieDocument;

  Future<Film1kDetail> getMovieDetail(Film1kCover film1kCover) async
  {
    movieDocument = await WebUtils.getDomFromURL(film1kCover.url!);
    dom.NodeList list = movieDocument.querySelectorAll(".entry.pd16.c-pd24 p")[0].nodes;
    String? directedby = "",released ="", runtime ="",geners="",country="",language="",actors="",description="";
    for (int i = 0;i<list.length;i++)
      {
        switch(list[i].text)
        {
          case "Directed by":
            directedby = list[i+1].text!.replaceAll(":", "").trim();
          case "Released":
            released = list[i+1].text!.replaceAll(":", "").trim();
          case "Runtime":
            runtime = list[i+1].text!.replaceAll(":", "").trim();
          case "Genres":
            geners = list[i+1].text!.replaceAll(":", "").trim();
          case "Countries":
            country = list[i+1].text!.replaceAll(":", "").trim();
          case "Actors":
            actors = list[i+1].text!.replaceAll(":", "").trim();
          case "Language":
            language = list[i+1].text!.replaceAll(":", "").trim();
          case "Plot":
            String desc = "";
            for(int j = i+1;j<list.length;j++)
              {
                desc = desc + list[j].text!;
              }
            description = desc!.replaceAll(":", "").trim();

        }
      }
    return Film1kDetail(url: film1kCover.url,title: film1kCover.title,actors: actors,country: country,coverUrl: film1kCover.imageURL,description: description,director: directedby,genre: geners,language: language,released: released,runtime: runtime);
  }

  Future<Map<String,List<String>> >getServerPages({String? episodePageUrl,bool isSeries = false}) async
  {
    String? sourceTest = "";
    Map <String,List<String>> map = Map();
    dom.Element? element = movieDocument.getElementById("torotube_public_functions-js-extra");
    String? json = LocalUtils.getStringBetweenTwoStrings("var torotube_Public = {", "};", element!.text);
    String? jsonFormate = "{ ${json} }";
    Map<String,dynamic> decodedString = jsonDecode(jsonFormate);
    List<String> listofIframes = List<String>.from(decodedString["player"] as List);
    for (String iframe in listofIframes)
      {
        dom.Document document = WebUtils.getDomfromHtml(iframe);
        String src = document.querySelector("iframe")!.attributes["src"]!;
        sourceTest = sourceTest! + src+"\n";
        _addServerPage(src!,VideoHosterEnum.ePlayVid.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.Dood.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.DropLoad.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.FileLions.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.MixDrop.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.StreamTape.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.StreamVid.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.StreamWish.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.UpStream.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.VidMoly.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.Vidoza.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.Voe.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.VTube.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.FileMoon.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.Films5k.name,map,src!);
        _addServerPage(src!,VideoHosterEnum.VidHideVip.name,map,src!);
      }
    // List<dom.Element> list;
    // if(isSeries)
    // {
    //   episodePageDocument = await WebUtils.getDomFromURL(episodePageUrl!);
    //   list = episodePageDocument.getElementsByClassName("server_line");
    // }
    // else
    // {
    //   list = moviePageDocument.getElementsByClassName("server_line");
    // }

  /*  for(int i = 0;i<list.length;i++)
    {
      String? providerLogoImageUrl = list[i].querySelector(".server_version img")!.attributes["src"];
      String? providerPageUrl = list[i].querySelector(".server_version a")!.attributes["href"];
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.ePlayVid.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.Dood.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.DropLoad.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.FileLions.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.MixDrop.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.StreamTape.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.StreamVid.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.StreamWish.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.UpStream.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.VidMoly.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.Vidoza.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.Voe.name,map,providerPageUrl!);
      _addServerPage(providerLogoImageUrl!,VideoHosterEnum.VTube.name,map,providerPageUrl!);
    }*/
    Fluttertoast.showToast(msg: sourceTest!,toastLength: Toast.LENGTH_LONG,backgroundColor:Colors.red);
    return map;
  }


  void _addServerPage(String providerName,String hostProvider,Map<String,List<String>> map,String pageServerUrl)
  {
    if(providerName.toLowerCase()!.contains(hostProvider.toLowerCase()))
    {
      if(map[hostProvider] == null)
      {
        List<String> list = [];
        list.add(pageServerUrl!);
        map[hostProvider] = list;
      }
      else
      {
        map[hostProvider]!.add(pageServerUrl!);
      }
    }
  }
  
}