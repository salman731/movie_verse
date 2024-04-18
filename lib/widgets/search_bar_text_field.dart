import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/controllers/search_screen_controller.dart';
import 'package:Movieverse/widgets/source_search_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchBarTextField extends StatefulWidget {
  @override
  _SearchBarTextFieldState createState() => _SearchBarTextFieldState();
}

class _SearchBarTextFieldState extends State<SearchBarTextField> {
  bool _isExpanded = false;

  SearchScreenController searchScreenController = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: _isExpanded ? 2 : 0,
          child: _isExpanded
              ? AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.transparent.withOpacity(0.1),
              border: Border.all(color: Colors.transparent),
            ),
            child: _isExpanded
                ? TextField(
              onSubmitted: (value){
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: AppColors.lightblack,
                  builder: (context) => SourceSearchBottomSheetWidget(),
                );
              },
              controller: searchScreenController.homeSearchBarEditingController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            )
                : null,
          )
              : Container(),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
      ],
    );
  }
}
