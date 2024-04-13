import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'carousel_item.dart';

class CarouselWidget extends StatelessWidget {
  List<int> list = [1,2,3,4,5];
   CarouselWidget({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: list
            .sublist(0, 5)
            .map(
              (item) => CarouselItem(
                  avatar: "PosterPath",
                  title: "Title",
                  genre: [],
                  onTapList: () {

                  },
                  onTap: () {

                  }),
            )
            .toList(),
        options: CarouselOptions(
          aspectRatio: 1 / 0.8,
          autoPlay: true,
          viewportFraction: 1,
          autoPlayAnimationDuration: const Duration(seconds: 2),
          enlargeCenterPage: false,
        ));
  }
}
