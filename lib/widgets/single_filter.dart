import 'package:flutter/material.dart';

class SingleFilter extends StatefulWidget {
  final List<Future<List<dynamic>> Function({dynamic params})> listSource;
  final List<String Function(dynamic params)> sourceName;
  final dynamic initial;
  final List<String> names;

  SingleFilter(this.listSource, this.sourceName, this.initial, this.names,
      {Key key})
      : super(key: key);

  @override
  _SingleFilterState createState() {
    return _SingleFilterState();
  }
}

class _SingleFilterState extends State<SingleFilter> {
  final _searchController = TextEditingController();

  List<dynamic> infos = [];
  List<dynamic> copy = [];

  int index = 0;
  int page = 0;
  BuildContext parent;

  List<dynamic> result;

  _SingleFilterState();

  @override
  void initState() {
    super.initState();
    result = List(widget.listSource.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    parent = context;
    return _getCategoryModals();
  }

  _getList(param) {
    infos.clear();
    copy.clear();
    widget.listSource[page](params: param).then((list) {
      setState(() {
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
        appBar: AppBar(
          title: Text("Select ${widget.names[page]}"),
        ),
        body: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 10, right: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'The Title of the Ad'),
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
              ),
              margin: EdgeInsets.all(0),
            ),
            Expanded(
                child: Navigator(
              initialRoute: "",
              onGenerateRoute: (RouteSettings settings) {
                if (page == 0)
                  _getList(widget.initial);
                else
                  _getList(settings.arguments);

                WidgetBuilder builder = (context) => _listWidget(context);
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ))
          ],
        ));
  }

  _listWidget(BuildContext context) {
    return ListView(
      children: _getCategoryWidgets(context),
    );
  }

  List<Widget> _getCategoryWidgets(BuildContext context) {
    var infos =
        this.infos.map((info) => _getCategoryWidget(context, info)).toList();
    infos.add(SizedBox(height: 50));
    return infos;
  }

  Widget _getCategoryWidget(BuildContext context, dynamic info) {
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
        _searchController.clear();
        result[page] = info;
        ++page;
        if (page == widget.listSource.length)
          Navigator.pop(parent, result);
        else
          Navigator.of(context).pushNamed("", arguments: info);
      },
    );
  }
}
