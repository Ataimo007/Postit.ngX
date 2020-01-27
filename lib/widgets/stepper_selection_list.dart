import 'package:flutter/material.dart';

enum Layout { GRID, LIST, WRAP }

class StepperSelection extends StatefulWidget {
  final List<Future<List<dynamic>> Function({dynamic params})> listSource;
  final List<String Function(dynamic params)> sourceName;
  final dynamic initial;
  final List<String> names;
  final List<Layout> layout;
  final List<Widget Function(dynamic params)> provider;

  StepperSelection(this.listSource, this.sourceName, this.initial, this.names,
      {Key key, this.layout, this.provider})
      : super(key: key);

  @override
  _StepperSelectionState createState() {
    return _StepperSelectionState();
  }
}

class _StepperSelectionState extends State<StepperSelection> {
  final _searchController = TextEditingController();

  dynamic info;
  List<dynamic> infos = [];
  List<dynamic> copy = [];

  int index = 0;
  int page = 0;
  bool loaded = false;

  List<dynamic> result;

  @override
  void initState() {
    super.initState();
    result = List(widget.listSource.length);
    info = widget.initial;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _init();
    return WillPopScope(
        onWillPop: () async {
          if (page == 0) {
            return true;
          }
          --page;
          setState(() {
            loaded = false;
          });
          return false;
        },
        child: _getCategoryModals());
  }

  _init() {
    if (!loaded) _getList(info);
  }

  _getList(param) {
    infos.clear();
    copy.clear();
    widget.listSource[page](params: param).then((list) {
      if (list.isEmpty)
        Navigator.pop(context, result);
      else
        setState(() {
          loaded = true;
          infos = list;
          copy = list;
        });
    });
  }

  _getName(dynamic info) {
    return widget.sourceName[page](info);
  }

  _getCategoryModals() {
    return Scaffold(
        primary: true,
        appBar: AppBar(
          title: Text("Select ${widget.names[page]}"),
        ),
        body: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    if (page != 0)
                      Container(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10),
                          itemCount: page,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  color: Colors.green,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Text(
                                        widget.sourceName[index](result[index]),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (page == 0)
                      SizedBox(
                        height: 10,
                      ),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'What ${widget.names[page]} are you looking for?'),
                      onChanged: (value) {
                        List<dynamic> filtered = this.copy.where((info) {
                          var name = _getName(info);
                          bool result =
                              name.toLowerCase().contains(value.toLowerCase());
                          return result;
                        }).toList();

                        setState(() {
                          infos = filtered;
                        });
                      },
                    ),
                  ],
                ),
              ),
              margin: EdgeInsets.all(0),
            ),
            Expanded(
              child: _itemWidget(),
            )
          ],
        ));
  }

  _itemWidget() {
    if (widget.layout != null && page < widget.layout.length) {
      switch (widget.layout[page]) {
        case Layout.LIST:
          return _listWidget();

        case Layout.GRID:
          return _gridWidget();

        case Layout.WRAP:
          return _wrapWidget();
      }
    } else
      return _listWidget();
  }

  _listWidget() {
    return ListView.builder(
        itemBuilder: (context, index) => _getEntry(index),
        itemCount: infos.length);
  }

  _gridWidget() {
    return GridView.builder(
      itemBuilder: (context, index) => _getGridEntry(index),
      itemCount: infos.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150, crossAxisSpacing: 10, mainAxisSpacing: 10),
    );
  }

  _wrapWidget() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Wrap(
            runSpacing: 30,
            children: <Widget>[
              for (var info in infos) _getWrapCategoryWidget(info)
            ],
          ),
        ),
      ));
    });
  }

  Widget _getEntry(index) {
    return _getCategoryWidget(infos[index]);
  }

  Widget _getGridEntry(index) {
    return _getGridCategoryWidget(infos[index]);
  }

  Widget _getCategoryWidget(dynamic info) {
    return InkWell(
      child: Container(
        color: index++ % 2 == 0 ? Colors.white : Colors.white12,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            _getName(info),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: () {
        _handlePress(info);
      },
    );
  }

  Widget _getGridCategoryWidget(dynamic info) {
    return InkWell(
      child: Column(
        children: <Widget>[
          widget.provider[page](info),
          Text(
            _getName(info),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        _handlePress(info);
      },
    );
  }

  Widget _getWrapCategoryWidget(dynamic info) {
    return InkWell(
      child: Container(
        width: 120,
        child: Column(
          children: <Widget>[
            widget.provider[page](info),
            SizedBox(
              height: 5,
            ),
            Text(
              _getName(info),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _handlePress(info);
      },
    );
  }

  _handlePress(dynamic info) {
    _searchController.clear();
    result[page] = info;
    this.info = info;

    ++page;

    if (page == widget.listSource.length)
      Navigator.pop(context, result);
    else
      setState(() {
        loaded = false;
      });
  }
}
