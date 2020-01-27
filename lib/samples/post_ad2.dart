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

  final _categoryKey = GlobalKey<FormFieldState>();
  final _brandKey = GlobalKey<FormFieldState>();
  final _modelKey = GlobalKey<FormFieldState>();
  final _yearKey = GlobalKey<FormFieldState>();

  List<File> _images = [];

  final _titleController = TextEditingController();

  final Map<String, dynamic> ad = {};

  // extra
  List<TransmissionEntity> transmissions;
  ModelEntity model;

  // year picker

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget root = _getRoot();
    _init();
    return root;
  }

  Widget _getRoot() {
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
//            if (_formKey.currentState.validate()) {
            if (true) {
              ad.clear();
              _formKey.currentState.save();
              print("The Ad is $ad");

//
//              UserEntity user =
//                  await AccountManagement.getInstance().getUserOrLogin(context);
//              ad['user_id'] = user.id;
//              ad['seller_name'] = user.getFullName();
//              ad['seller_email'] = user.email;
//              ad['seller_phone'] = user.phone;
//
//              print("The Ad is $ad");
//              PostMessageEntity message =
//                  await ApiService.getService().postAd(ad);
//              print("The Result is $message");
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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

  _selectCategory(FormFieldState<List<dynamic>> state,
      {GlobalKey<FormFieldState> dependency}) async {
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
      state.didChange(cat);
      _getTransmission().then((transmission) {
        setState(() {
          this.transmissions = transmission;
        });
      });
      if (_brandKey.currentState != null)
        _brandKey.currentState.didChange(null);
      if (_modelKey.currentState != null)
        _modelKey.currentState.didChange(null);
    }
  }

  bool _hasTrans() {
    if (_categoryKey.currentState != null) {
      List<dynamic> cat = _categoryKey.currentState.value;
      if (cat != null)
        return cat[1] != null && (cat[1] as SubCategoryEntity).hasTrans;
    }
    return false;
  }

  bool _hasTransValues() => transmissions != null;

  bool _hasBodyStyle() {
    if (_categoryKey.currentState != null) {
      List<dynamic> cat = _categoryKey.currentState.value;
      if (cat != null)
        return cat[1] != null && (cat[1] as SubCategoryEntity).hasBodyStyle;
    }
    return false;
  }

  bool _hasBrand() {
    if (_categoryKey.currentState != null) {
      List<dynamic> cat = _categoryKey.currentState.value;
      if (cat != null)
        return cat[1] != null && (cat[1] as SubCategoryEntity).brandCount > 0;
    }
    return false;
  }

  bool _hasModel() {
    if (_brandKey.currentState != null) {
      BrandEntity brand = _brandKey.currentState.value as BrandEntity;
      return brand != null && brand.modelCount > 0;
    }
    return false;
  }

  _selectRegion(FormFieldState<List<dynamic>> state,
      {GlobalKey<FormFieldState> dependency}) async {
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
      state.didChange(region);
    }
  }

  _selectBrand(FormFieldState<BrandEntity> state,
      {GlobalKey<FormFieldState> dependency}) async {
    List<dynamic> values = dependency.currentState.value;
    SubCategoryEntity sub = values[1] as SubCategoryEntity;
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
            sub,
            ["Brand", "Model"]),
      ),
    );
    if (brand != null) {
      state.didChange(brand[0] as BrandEntity);
      setState(() {
        model = brand[1] as ModelEntity;
        _setTitle();
      });
      _setTitle();
    }
  }

  _selectBody(FormFieldState<BodyStyleEntity> state,
      {GlobalKey<FormFieldState> dependency}) async {
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
      state.didChange(body[0] as BodyStyleEntity);
      return true;
    }
    return false;
  }

  _selectYear(FormFieldState<DateTime> state,
      {GlobalKey<FormFieldState> dependency}) async {
    DateTime dateTime = state.value;
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
                                  dateTime != null
                                      ? dateTime.year.toString()
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
                        selectedDate:
                            dateTime != null ? dateTime : DateTime.now(),
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
      state.didChange(year);
      _setTitle();
    }
  }

  _selectModel(FormFieldState<ModelEntity> state,
      {GlobalKey<FormFieldState> dependency}) async {
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
            dependency.currentState.value as BrandEntity,
            ["Model"]),
      ),
    );
    if (model != null) {
      state.didChange(model[0] as ModelEntity);
      _setTitle();
      return true;
    }
    return false;
  }

  _setTitle() {
    SubCategoryEntity sub = _categoryKey.currentState != null &&
            _categoryKey.currentState.value != null
        ? _categoryKey.currentState.value[1] as SubCategoryEntity
        : null;
    BrandEntity brand =
        _brandKey.currentState != null && _brandKey.currentState.value != null
            ? _brandKey.currentState.value as BrandEntity
            : null;
    ModelEntity model =
        _modelKey.currentState != null && _modelKey.currentState.value != null
            ? _modelKey.currentState.value as ModelEntity
            : null;
    DateTime year =
        _yearKey.currentState != null && _yearKey.currentState.value != null
            ? _yearKey.currentState.value as DateTime
            : null;

    if (sub != null && sub.id == 27 && brand != null) {
      String name = "${brand.brandName} "
          "${model != null ? model.modelName : ""} "
          "${year != null ? year.year.toString() : ""} ";
      print("changing title $name");
      _titleController.text = name;
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
                        ..._getObjectField<List<dynamic>>(
                          label: 'Category',
                          hint: "What's Category of Ad",
                          validationText:
                              "Please Ensure You Select the Category",
                          onSave: (value) {
                            ad['category_id'] = (value[0] as CategoryEntity).id;
                            ad['sub_category_id'] =
                                (value[1] as SubCategoryEntity).id;
                          },
                          toString: (value) {
                            if (value[0] != null)
                              return (value[0] as CategoryEntity).categoryName;
                            return (value[1] as SubCategoryEntity).categoryName;
                          },
                          select: _selectCategory,
                          key: _categoryKey,
                        ),
                        if (_hasBrand())
                          ..._getObjectField<BrandEntity>(
                            label: 'Brand',
                            hint: "What's the Brand of Ad",
                            validationText:
                                "Please Ensure You Select the Brand",
                            fieldName: 'brand_id',
                            toValue: (value) => value.brandName,
                            select: _selectBrand,
                            toString: (value) => value.brandName,
                            key: _brandKey,
                            argument: _categoryKey,
                          ),
                        if (_hasModel())
                          ..._getObjectField<ModelEntity>(
                            label: 'Model',
                            hint: "What's the Model of Ad",
                            toString: (value) => value.modelName,
                            validationText:
                                "Please Ensure You Select the Model",
                            suppliedValue: () {
                              ModelEntity model = this.model;
                              this.model = null;
                              return model;
                            },
                            fieldName: 'brand_model_id',
                            toValue: (value) => value.modelName,
                            select: _selectModel,
                            key: _modelKey,
                            argument: _brandKey,
                          ),
                        if (_hasTrans()) ...[
                          ..._getObjectField<DateTime>(
                              label: 'Year',
                              hint: "What's the Year is the Model",
                              validationText:
                                  "Please Ensure You Select the Year",
                              fieldName: 'year',
                              toString: (value) => value.year.toString(),
                              toValue: (value) => value.year,
                              select: _selectYear,
                              key: _yearKey),
                          if (_hasBodyStyle())
                            ..._getObjectField<BodyStyleEntity>(
                              label: 'Body Style',
                              hint: "What's the Body Style",
                              validationText:
                                  "Please Ensure You Select the Body Style",
                              toString: (value) => value.bodyStyleName,
                              fieldName: 'body_style_id',
                              toValue: (value) => value.bodyStyleName,
                              select: _selectBody,
                            ),
                          if (_hasTransValues())
                            ..._radioGroup<TransmissionEntity>(
                                label: 'Transmissions',
                                fieldName: 'transmission',
                                toString: (value) => value.transmission,
                                values: transmissions),
                          ..._getTextField(
                              fieldName: 'mileage',
                              label: 'Mileage',
                              hint: "What's the Mileage of the Vehicle",
                              validationText:
                                  "Please Ensure You the mileage of the vehicle")
                        ],
                        ..._getTextField(
                            label: 'Ad Title',
                            controller: _titleController,
                            hint: "What's the Title of the Ad",
                            validationText:
                                "Please Ensure You the title of your ad",
                            onSaved: (value) {
                              ad['title'] = value.trim();
                              ad['slug'] = value.trim().toLowerCase();
                            }),
                        ..._getObjectField<List<dynamic>>(
                          label: 'Region',
                          hint: "What Region is the Ad",
                          validationText:
                              "Please Ensure You Select the location of the Ad",
                          onSave: (value) {
                            ad['country_id'] = (value[0] as CountryEntity).id;
                            ad['state_id'] = (value[1] as StateEntity).id;
                            ad['city_id'] = (value[2] as CityEntity).id;
                          },
                          toString: (value) {
                            if (value[2] != null)
                              return (value[2] as CityEntity).cityName;
                            if (value[1] != null)
                              return (value[1] as StateEntity).stateName;
                            return (value[0] as CountryEntity).countryName;
                          },
                          select: _selectRegion,
                        ),
                        ..._getTextField(
                          label: 'Description',
                          hint: "What's the Description of the Ad",
                          validationText: "Please Ensure You describe the Ad",
                          fieldName: 'description',
                          minLines: 4,
                          maxLines: 6,
                          alignLabelWithHint: true,
                        ),
                        ..._radioGroup<Type>(
                            label: 'Type of Ad',
                            fieldName: 'type',
                            toString: (value) => EnumToString.parse(value),
                            values: Type.values),
                        ..._radioGroup<Condition>(
                            label: 'Condition Of Ad',
                            fieldName: 'condition',
                            toString: (value) => EnumToString.parse(value),
                            values: Condition.values),
                        ..._getTextField(
                          label: 'Price',
                          hint: "What's the Price of the Ad",
                          validationText:
                              "Please Ensure You enter the price of the Ad",
                          fieldName: 'price',
                        ),
                        ..._checkedBox(
                            fieldName: 'negotiable', label: 'Negotiable'),
                        ..._getTextField(
                          label: 'Address',
                          hint: "What's the Location of the Ad",
                          validationText:
                              "Please Ensure You enter the address of the Ad",
                          fieldName: 'address',
                          minLines: 4,
                          maxLines: 6,
                          alignLabelWithHint: true,
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

  _getTextField({
    String fieldName,
    String label,
    String hint,
    String validationText,
    String passwordValidationText,
    bool obscured = false,
    TextEditingController controller,
    TextInputType inputType,
    TextEditingController validatorController,
    Function(String value) onSaved,
    int minLines = 1,
    int maxLines = 1,
    bool alignLabelWithHint = false,
  }) {
    return <Widget>[
      TextFormField(
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: inputType,
        controller: controller,
        obscureText: obscured,
        validator: (value) {
          if (value.isEmpty)
            return validationText;
          else if (validatorController != null &&
              validatorController.text != value) return passwordValidationText;
          return null;
        },
        onSaved: (value) {
          if (onSaved != null)
            onSaved(value);
          else if (fieldName != null) ad[fieldName] = value.trim();
        },
        decoration: InputDecoration(
            alignLabelWithHint: alignLabelWithHint,
            border: OutlineInputBorder(),
            labelText: label,
            hintText: hint),
      ),
      SizedBox(
        height: 30,
      ),
    ];
  }

  _getObjectField<T>({
    String fieldName,
    String label,
    String hint,
    String validationText,
    dynamic Function(T value) toValue,
    String Function(T value) toString,
    Function(FormFieldState<T> state, {GlobalKey<FormFieldState> dependency})
        select,
    Function(T value) onSave,
    T Function() suppliedValue,
    GlobalKey<FormFieldState> key,
    GlobalKey<FormFieldState> argument,
  }) {
    T supply;
    if (suppliedValue != null) {
      supply = suppliedValue();
    }

    return <Widget>[
      FormField<T>(
          initialValue: supply,
          key: key,
          validator: (value) {
            if (value == null) return validationText;
            return null;
          },
          onSaved: (value) {
            if (onSave != null)
              onSave(value);
            else
              ad[fieldName] = toValue(value);
          },
          builder: (state) {
            FocusNode focus = FocusNode();
            TextEditingController controller = TextEditingController();
            focus.addListener(() {
              focus.unfocus();
              select(state, dependency: argument);
            });

            if (state.value != null) controller.text = toString(state.value);

            return Column(
              children: <Widget>[
                TextField(
                  focusNode: focus,
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: state.hasError
                          ? OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red.shade800))
                          : null,
                      labelText: label,
                      hintText: hint),
                ),
                if (state.hasError)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 8),
                      child: Text(
                        state.errorText,
                        style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
              ],
            );
          }),
      SizedBox(
        height: 30,
      ),
    ];
  }

  _checkedBox({String fieldName, String label, bool initialValue = false}) {
    return <Widget>[
      FormField<bool>(
          onSaved: (value) {
            ad[fieldName] = value ? '1' : '0';
          },
          initialValue: initialValue,
          builder: (state) {
            return InkWell(
              onTap: () {
                state.didChange(!state.value);
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                        value: state.value,
                        onChanged: (value) {
                          state.didChange(!state.value);
                        }),
                    Text(
                      label,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            );
          }),
      SizedBox(
        height: 30,
      ),
    ];
  }

  _radioGroup<T>(
      {String fieldName,
      String label,
      List<T> values,
      String Function(T) toString}) {
    return <Widget>[
      FormField<T>(validator: (value) {
        if (value == null) return "Please Ensure You Select the $label";
        return null;
      }, onSaved: (value) {
        if (fieldName != null) ad[fieldName] = toString(value).toLowerCase();
      }, builder: (state) {
        return Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
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
                        state.didChange(value);
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Radio<T>(
                                value: value,
                                groupValue: state.value,
                                onChanged: (value) {
                                  state.didChange(value);
                                }),
                            Text(
                              toString(value).toLowerCase(),
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (state.hasError)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Text(
                    state.errorText,
                    style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
          ],
        );
      }),
      SizedBox(
        height: 30,
      ),
    ];
  }
}
