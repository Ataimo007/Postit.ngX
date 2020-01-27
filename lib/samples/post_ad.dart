import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postit/app.dart';

class PostAd extends StatefulWidget {
  static get routeName => "ad/post";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostAd();
  }
}

enum Type { Business, Personal }
enum Condition { New, Used }

class _PostAd extends State<PostAd> {
  final _formKey = GlobalKey<FormState>();

  List<File> _images = [];

  final _categoryFocus = FocusNode();
  final _categoryController = TextEditingController();

  final _regionFocus = new FocusNode();
  final _regionController = TextEditingController();

  final _brandFocus = new FocusNode();
  final _brandController = TextEditingController();

  final _modelFocus = new FocusNode();
  final _modelController = TextEditingController();

  final _bodyFocus = new FocusNode();
  final _bodyController = TextEditingController();

  final _yearFocus = new FocusNode();
  final _yearController = TextEditingController();

  final _titleController = TextEditingController();

  final Map<String, dynamic> specs = {};
  final Map<String, dynamic> region = {};
  final Map<String, dynamic> adState = {};

  final Map<String, dynamic> ad = {};

  List<TransmissionEntity> transmissions;

  // year picker

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _init();
    return Scaffold(
      body: _getContent(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        color: Colors.green,
        elevation: 10,
        child: FlatButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              UserEntity user =
                  await AccountManagement.getInstance().getUserOrLogin(context);
              ad['user_id'] = user.id;
              ad['seller_name'] = user.getFullName();
              ad['seller_email'] = user.email;
              ad['seller_phone'] = user.phone;

              print("The Ad is $ad");
              PostMessageEntity message =
                  await ApiService.getService().postAd(ad);
              print("The Result is $message");
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              "Post Ad",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  _init() {
    _setTitle();
  }

  @override
  void dispose() {
    _categoryFocus.dispose();
    _regionFocus.dispose();
    _bodyFocus.dispose();
    _modelFocus.dispose();
    _brandFocus.dispose();
    _yearFocus.dispose();

    _brandController.dispose();
    _modelController.dispose();
    _regionController.dispose();
    _categoryController.dispose();
    _bodyController.dispose();
    _yearController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _categoryFocus.addListener(_onCategoryHandler);
    _regionFocus.addListener(_regionHandler);
    _brandFocus.addListener(_brandHandler);
    _modelFocus.addListener(_modelHandler);
    _bodyFocus.addListener(_bodyHandler);
    _yearFocus.addListener(_yearHandler);
  }

  void _onCategoryHandler() {
    if (_categoryFocus.hasFocus) {
      _categoryFocus.unfocus();
      _showCategoryModals(context);
    }
  }

  void _regionHandler() {
    if (_regionFocus.hasFocus) {
      _regionFocus.unfocus();
      _showRegionModals(context);
    }
  }

  void _brandHandler() {
    if (_brandFocus.hasFocus) {
      _brandFocus.unfocus();
      _showBrandModals(context);
    }
  }

  void _modelHandler() {
    if (_modelFocus.hasFocus) {
      _modelFocus.unfocus();
      _showModelModals(context);
    }
  }

  void _bodyHandler() {
    if (_bodyFocus.hasFocus) {
      _bodyFocus.unfocus();
      _showBodyModals(context);
    }
  }

  void _yearHandler() {
    if (_yearFocus.hasFocus) {
      _yearFocus.unfocus();
      _showYearModals(context);
    }
  }

  _getContent() {
    return CustomScrollView(
      slivers: <Widget>[
        _images.isEmpty ? _getAppBarNoImage() : _getAppBarImages(),
        _getForm(),
      ],
    );
  }

  getImages() {
    return _images.map((image) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
            height: 100,
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: 100,
                minWidth: double.infinity,
                maxWidth: double.infinity),
            child: Image.file(image, fit: BoxFit.cover)),
      );
    }).toList();
  }

  _getAppBarImages() {
    return SliverAppBar(
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.green),
      actionsIconTheme: IconThemeData(color: Colors.green),
      expandedHeight: 300,
      textTheme: TextTheme(title: TextStyle(color: Colors.green)),
      title: Text(
        "Post Your Ad",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
            child: Stack(
          children: <Widget>[
            CarouselSlider(
              items: getImages(),
              height: 250,
              aspectRatio: 16 / 4,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          onTap: cameraPicker,
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.image,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          onTap: galleryPicker,
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white70,
                          Colors.white30,
                        ]),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                constraints: BoxConstraints.expand(height: 50),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white70,
                        Colors.white30,
                      ]),
                ),
              ),
              top: 0,
              left: 0,
              right: 0,
            )
          ],
        )),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Future galleryPicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  Future cameraPicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  _getAppBarNoImage() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Please Enter Images of your Ad",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.camera,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    color: Colors.white,
                    onPressed: cameraPicker,
                    shape: CircleBorder(),
                  ),
                  FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.image,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    color: Colors.white,
                    onPressed: galleryPicker,
                    shape: CircleBorder(),
                  )
                ],
              )
            ],
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  _showCategoryModals(context) async {
    final cat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepperSelection(
            [_getCategories, _getSubCategories],
            [
              (info) {
                CategoryEntity cat = info;
                return cat.categoryName;
              },
              (info) {
                SubCategoryEntity sub = info;
                return sub.categoryName;
              }
            ],
            null,
            ["Category", "Sub Category"]),
      ),
    );
    if (cat != null) {
      setState(() {
        specs.clear();
        specs['category'] = cat[0];
        specs['sub_category'] = cat[1];
        _categoryController.text =
            (specs['sub_category'] as SubCategoryEntity).categoryName;
        if (_hasTrans())
          _getTransmission().then((transmission) {
            setState(() {
              this.transmissions = transmission;
            });
          });
      });
    }
  }

  bool _hasTrans() =>
      specs.containsKey('sub_category') &&
      (specs['sub_category'] as SubCategoryEntity).hasTrans;

  bool _hasTransValues() => transmissions != null;

  bool _hasBodyStyle() =>
      specs.containsKey('sub_category') &&
      (specs['sub_category'] as SubCategoryEntity).hasBodyStyle;

  bool _hasBrand() =>
      specs.containsKey('sub_category') &&
      (specs['sub_category'] as SubCategoryEntity).brandCount > 0;

  bool _hasModel() =>
      specs.containsKey('brand') &&
      (specs['brand'] as BrandEntity).modelCount > 0;

  _showRegionModals(context) async {
    final region = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepperSelection(
            [
              _getCountry,
              _getState,
              _getCity,
            ],
            [
              (info) {
                CountryEntity country = info;
                return country.countryName;
              },
              (info) {
                StateEntity state = info;
                return state.stateName;
              },
              (info) {
                CityEntity city = info;
                return city.cityName;
              }
            ],
            null,
            ["Country", "State", "City"]),
      ),
    );
    if (region != null) {
      setState(() {
        this.region.clear();
        this.region['country'] = region[0];
        this.region['state'] = region[1];
        this.region['city'] = region[2];
        if (this.region.containsKey("city") && this.region['city'] != null)
          _regionController.text = (this.region['city'] as CityEntity).cityName;
        else if (this.region.containsKey("state") &&
            this.region['city'] != null)
          _regionController.text =
              (this.region['state'] as StateEntity).stateName;
      });
    }
  }

  _showBrandModals(context) async {
    final brand = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepperSelection(
            [
              _getBrand,
              _getModel,
            ],
            [
              (info) {
                BrandEntity brand = info;
                return brand.brandName;
              },
              (info) {
                ModelEntity model = info;
                return model.modelName;
              }
            ],
            specs['sub_category'] as SubCategoryEntity,
            ["Brand", "Model"]),
      ),
    );
    if (brand != null) {
      specs.removeWhere((key, value) {
        return !(key == 'category') && !(key == 'sub_category');
      });
      setState(() {
        if (brand[0] != null) {
          specs['brand'] = brand[0];
          _brandController.text = (specs['brand'] as BrandEntity).brandName;
        }
        if (brand[1] != null) {
          specs['model'] = brand[1];
          _modelController.text = (specs['model'] as ModelEntity).modelName;
        }
      });
    }
  }

  _showBodyModals(context) async {
    final body = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepperSelection(
            [
              _getBodyStyles,
            ],
            [
              (info) {
                BodyStyleEntity brand = info;
                return brand.bodyStyleName;
              },
            ],
            null,
            ["Body Style"]),
      ),
    );
    if (body != null) {
      setState(() {
        specs.removeWhere((key, value) {
          return !(key == 'category') &&
              !(key == 'sub_category') &&
              !(key == 'brand') &&
              !(key == 'model');
        });
        specs['body_style'] = body[0];
        _bodyController.text =
            (specs['body_style'] as BodyStyleEntity).bodyStyleName;
      });
    }
  }

  _showYearModals(context) async {
    final year = await showDialog<DateTime>(
        context: context,
        builder: (context) {
          return Center(
            child: Card(
              margin: EdgeInsets.only(top: 40, bottom: 30),
              child: Container(
                constraints: BoxConstraints.expand(width: 250),
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(height: 100),
                      color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Select the Year of the Model",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  specs.containsKey('year')
                                      ? (specs['year'] as DateTime)
                                          .year
                                          .toString()
                                      : DateTime.now().year.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: YearPicker(
                        selectedDate: specs.containsKey('year')
                            ? specs['year']
                            : DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                        onChanged: (DateTime value) {
                          Navigator.pop(context, value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });

    if (year != null) {
      setState(() {
        specs['year'] = year;
        _yearController.text = year.year.toString();
      });
    }
  }

  _showModelModals(context) async {
    final model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepperSelection(
            [
              _getModel,
            ],
            [
              (info) {
                ModelEntity model = info;
                return model.modelName;
              }
            ],
            specs['brand'] as BrandEntity,
            ["Model"]),
      ),
    );
    if (model != null) {
      specs.removeWhere((key, value) {
        return !(key == 'category') &&
            !(key == 'sub_category') &&
            !(key == 'brand');
      });
      setState(() {
        specs['model'] = model[0];
        _modelController.text = (specs['model'] as ModelEntity).modelName;
      });
    }
  }

  _setTitle() {
    print("changing title");
    if (specs.containsKey("sub_category") &&
        (specs['sub_category'] as SubCategoryEntity).id == 27 &&
        specs.containsKey('model')) {
      _titleController.text =
          "${specs.containsKey('brand') ? (specs['brand'] as BrandEntity).brandName : ""} "
          "${specs.containsKey('model') ? (specs['model'] as ModelEntity).modelName : ""} "
          "${specs.containsKey('year') ? (specs['year'] as DateTime).year.toString() : ""} ";
    }
  }

  Future<List<CategoryEntity>> _getCategories({dynamic params}) async {
    return await ApiService.getService().getCategories();
  }

  Future<List<TransmissionEntity>> _getTransmission() async {
    return await ApiService.getService().getTransmissions();
  }

  Future<List<BodyStyleEntity>> _getBodyStyles({dynamic params}) async {
    return await ApiService.getService().getBodyStyle();
  }

  Future<List<CountryEntity>> _getCountry({dynamic params}) async {
    return await ApiService.getService().getCountry();
  }

  Future<List<BrandEntity>> _getBrand({dynamic params}) async {
    SubCategoryEntity sub = params;
    return await ApiService.getService().getBrand(sub.id);
  }

  Future<List<ModelEntity>> _getModel({dynamic params}) async {
    BrandEntity brand = params;
    return await ApiService.getService().getModel(brand.id);
  }

  Future<List<StateEntity>> _getState({dynamic params}) async {
    CountryEntity country = params;
    return await ApiService.getService().getStates(country.id);
  }

  Future<List<CityEntity>> _getCity({dynamic params}) async {
    StateEntity state = params;
    return await ApiService.getService().getCities(state.id);
  }

  Future<List<SubCategoryEntity>> _getSubCategories({dynamic params}) async {
    CategoryEntity info = params;
    return await ApiService.getService().getSubCategories(info.id);
  }

  _checkedBox(String title, String name) {
    return FormField<bool>(
        onSaved: (value) {
          ad['is_negotiable'] = value ? '1' : '0';
        },
        initialValue: adState.containsKey(name) ? adState[name] : false,
        builder: (state) {
          return InkWell(
            onTap: () {
              setState(() {
                adState[name] =
                    adState.containsKey(name) ? !adState[name] : true;
              });
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: adState.containsKey(name) ? adState[name] : false,
                      onChanged: (value) {
                        setState(() {
                          adState[name] = value;
                        });
                      }),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          );
        });
  }

  _radioGroup<T>(title, name, List<T> values, String Function(T) getName,
      Function(T) save) {
    if (!adState.containsKey(name)) adState[name] = values[0];
    return [
      FormField<T>(
          validator: (value) {
            if (value == null) return "Please Ensure You Select the $title";
            return null;
          },
          onSaved: (value) {
            save(value);
          },
          initialValue: adState[name],
          builder: (state) {
            return Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    for (T value in values)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              adState[name] = value;
                            });
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Radio<T>(
                                    value: value,
                                    groupValue: adState[name],
                                    onChanged: (value) {
                                      setState(() {
                                        adState[name] = value;
                                      });
                                    }),
                                Text(
                                  getName(value),
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          }),
    ];
  }

  _getForm() {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 8, left: 8, top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (!specs.containsKey("category"))
                              return "Please Ensure You Select the Category";
                            return null;
                          },
                          onSaved: (value) {
                            ad['category_id'] =
                                (specs['category'] as CategoryEntity).id;
                            ad['sub_category_id'] =
                                (specs['sub_category'] as SubCategoryEntity).id;
                          },
                          controller: _categoryController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ad Category',
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              hintText: 'Select Category of Ad'),
                          focusNode: _categoryFocus,
                        ),
                        if (_hasBrand()) ...[
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (_hasBrand() && !specs.containsKey("brand"))
                                return "Please Ensure You Select the Brand";
                              return null;
                            },
                            onSaved: (value) {
                              ad['brand_id'] =
                                  (specs['brand'] as BrandEntity).id;
                            },
                            controller: _brandController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                labelText: 'Brand',
                                hintText: 'What is the Brand of the vehicle'),
                            focusNode: _brandFocus,
                          ),
                        ],
                        if (_hasModel()) ...[
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (_hasModel() && !specs.containsKey("model"))
                                return "Please Ensure You Select the Model";
                              return null;
                            },
                            onSaved: (value) {
                              ad['brand_model_id'] =
                                  (specs['model'] as ModelEntity).id;
                            },
                            controller: _modelController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                labelText: 'Model',
                                hintText: 'What is model of the vehicle'),
                            focusNode: _modelFocus,
                          ),
                        ],
                        if (_hasTrans()) ...[
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (_hasTrans() && !specs.containsKey("year"))
                                return "Please Ensure You Select the Year";
                              return null;
                            },
                            onSaved: (value) {
                              ad['year'] = (specs['year'] as DateTime).year;
                            },
                            controller: _yearController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                labelText: 'Year',
                                hintText: 'What is the Year of the Model'),
                            focusNode: _yearFocus,
                          ),
                          if (_hasBodyStyle()) ...[
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (_hasBodyStyle() &&
                                    !specs.containsKey("body_style"))
                                  return "Please Ensure You Select the Body Style";
                                return null;
                              },
                              onSaved: (value) {
                                ad['body_style_id'] =
                                    (specs['body_style'] as BodyStyleEntity).id;
                              },
                              controller: _bodyController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  labelText: 'Body Style',
                                  hintText:
                                      'What is the Body Style of the Vehicle'),
                              focusNode: _bodyFocus,
                            ),
                          ],
                          SizedBox(
                            height: 30,
                          ),
                          if (_hasTransValues())
                            ..._radioGroup<TransmissionEntity>(
                                "Transmissions",
                                "transmission",
                                transmissions,
                                (value) => value.transmission,
                                (value) => ad['transmission_id'] = value.id),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please Ensure You the mileage of the vehicle";
                              return null;
                            },
                            onSaved: (value) {
                              ad['mileage'] = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mileage',
                                hintText: 'What is the Mileage of the Vehicle'),
                          ),
                        ],
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Ensure You the title of your ad";
                            return null;
                          },
                          onSaved: (value) {
                            ad['title'] = value.trim();
                            ad['slug'] = value.trim().toLowerCase();
                          },
                          controller: _titleController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ad Title',
                              hintText: 'The Title of the Ad'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Ensure You Select the location of the Ad";
                            return null;
                          },
                          onSaved: (value) {
                            ad['country_id'] =
                                (region['country'] as CountryEntity).id;
                            ad['state_id'] =
                                (region['state'] as StateEntity).id;
                            ad['city_id'] = (region['city'] as CityEntity).id;
                          },
                          controller: _regionController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              labelText: 'Region',
                              hintText: 'What is the Ad Location'),
                          focusNode: _regionFocus,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Ensure You describe the Ad";
                            return null;
                          },
                          onSaved: (value) {
                            ad['description'] = value;
                          },
                          minLines: 4,
                          maxLines: 6,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                              labelText: 'Description',
                              hintText: 'Describe your Ad for Your Buyer'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ..._radioGroup<Type>(
                            "Type Of Ad",
                            "type",
                            Type.values,
                            (value) => EnumToString.parse(value),
                            (value) => ad['type'] = EnumToString.parse(value)),
                        SizedBox(
                          height: 30,
                        ),
                        ..._radioGroup<Condition>(
                            "Condition Of Ad",
                            "condition",
                            Condition.values,
                            (value) => EnumToString.parse(value),
                            (value) =>
                                ad['ad_condition'] = EnumToString.parse(value)),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Ensure You enter the price of the Ad";
                            return null;
                          },
                          onSaved: (value) {
                            ad['price'] = value;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Price',
                              hintText: 'The Price of the Ad'),
                        ),
                        _checkedBox("Negotiable", "negotiable"),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Ensure You enter the address of the Ad";
                            return null;
                          },
                          onSaved: (value) {
                            ad['address'] = value;
                          },
                          minLines: 4,
                          maxLines: 6,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                              labelText: 'Address',
                              hintText: 'Where is the Location of the Ad'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
