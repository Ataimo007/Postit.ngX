import 'package:flutter/material.dart';

import 'app.dart';

class MainSearch extends StatefulWidget {
  static const routeName = 'home/search';

  MainSearch({Key key}) : super(key: key);

  @override
  _MainSearchState createState() {
    return _MainSearchState();
  }
}

class _MainSearchState extends State<MainSearch> {
  final searchController = SearchController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
          child: TextField(
            onChanged: (value) {
              searchController.textSearch(value.toLowerCase());
            },
            autofocus: true,
            autocorrect: true,
            cursorColor: Colors.green,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                suffixIcon: InkWell(
                  child: Icon(Icons.list),
                  onTap: () {},
                ),
                alignLabelWithHint: true,
                hasFloatingPlaceholder: false,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.green)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.green)),
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.green),
                labelText: 'What Are You Looking For?'),
          ),
        ),
      ),
      body: AdList(
        controller: searchController,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, PostAd.routeName),
        tooltip: 'New Ad',
        icon: Icon(Icons.add),
        label: Text("Post Ad"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 48,
        ),
      ),
    );
  }
}
