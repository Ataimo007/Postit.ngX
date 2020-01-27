import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
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
  final _regionKey = GlobalKey<FormFieldState>();

  List<dynamic> _images = [];

  TextEditingController _titleController = TextEditingController();
  bool gpsLoading = false;

  final Map<String, dynamic> ad = {};
  AdFullEntity initials;
  GeocodingResponseEntity address;

  // extra
  List<TransmissionEntity> transmissions;
  int currentPage;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int adId = ModalRoute.of(context).settings.arguments;
    if (adId != null) {
      if (initials == null) {
        ApiService.getService().getAdFull(adId).then((ad) {
          _titleController = TextEditingController(text: ad.getTitle());
          _images.addAll(ad.getImages());
          setState(() {
            initials = ad;
          });
        });
        return Scaffold();
      } else
        return _getBuild();
    } else
      return _getBuild();
  }

  Widget _getBuild() {
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
            if (initials == null)
              _postAd();
            else
              _editAd();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              initials == null ? "Post Ad" : "Edit Ad",
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

  _postAd() async {
    if (_formKey.currentState.validate()) {
      ad.clear();
      _formKey.currentState.save();
      print("The Ad is $ad");

      UserEntity user =
          await AccountManagement.getInstance().getUserOrLogin(context);

      print("user is $user");

      ad['user_id'] = user.id;
      ad['seller_name'] = user.getFullName();
      ad['seller_email'] = user.email;
      ad['seller_phone'] = user.phone;

      print("The Ad is $ad with images $_images");

      PostingReport report = await processAd(
          context, ad, _images.map((image) => image as File).toList());

      showToast(report.message);
      if (report.success) {
        Navigator.of(context).pop();
      }
    }
  }

  List<File> getUploadableImages() {
    return _images
        .where((image) {
          return image is File;
        })
        .map((image) => image as File)
        .toList(growable: false);
  }

  String getDeletableImages() {
    List<AdFullResultMedia> oldMedias = _images
        .where((image) {
          return image is AdFullResultMedia;
        })
        .map((image) => image as AdFullResultMedia)
        .toList(growable: false);
    List<AdFullResultMedia> medias = initials.getImages().where((image) {
      return !oldMedias.contains(image);
    }).toList(growable: false);
    if (medias.length > 0) {
      String ids = "";
      for (int i = 0; i < medias.length - 1; ++i) ids = "$ids${medias[i].id},";
      ids = "$ids${medias[medias.length - 1].id}";
      return ids;
    }
    return "";
  }

  _editAd() async {
    if (_formKey.currentState.validate()) {
      ad.clear();
      _formKey.currentState.save();

      ad['ad_id'] = initials.result.ad.id;

      print("The Ad is $ad");

      UserEntity user =
          await AccountManagement.getInstance().getUserOrLogin(context);

      print("user is $user");

      ad['user_id'] = user.id;
      ad['seller_name'] = user.getFullName();
      ad['seller_email'] = user.email;
      ad['seller_phone'] = user.phone;

      print("The Ad is $ad with images $_images");

      String deletable = getDeletableImages();
      ad['deleteMedias'] = deletable;

      List<File> uploadable = getUploadableImages();

      PostingReport report =
          await processAd(context, ad, uploadable, update: true);

      showToast(report.message);
      if (report.success) {
        Navigator.of(context).pop();
      }
    }
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

  _initAd() {}

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
            child: _getImage(image),
          ));
    }).toList();
  }

  Widget _getImage(dynamic image) {
    if (image is File) return Image.file(image, fit: BoxFit.cover);
    if (image is AdFullResultMedia)
      return CachedNetworkImage(
        imageUrl: '${image.mediaLink}',
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, object) => Container(
          color: Colors.white,
          child: Icon(
            Icons.shopping_cart,
            color: Colors.green,
            size: 100,
          ),
        ),
        fit: BoxFit.cover,
      );
    else
      return Container(
        color: Colors.white,
        child: Icon(
          Icons.shopping_cart,
          color: Colors.green,
          size: 100,
        ),
      );
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
              onPageChanged: (index) {
                currentPage = index;
              },
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
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
                        ]),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
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
                                Icons.close,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                            onTap: _removeImages),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.7),
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
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.7),
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

  _removeImages() {
    setState(() {
      _images.removeAt(currentPage);
    });
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
          ["Category", "Sub Category"],
          layout: [Layout.WRAP],
          provider: [
            (info) {
              CategoryIcon icon =
                  CategoryIcon.getCategory((info as CategoryEntity).id);
              return SvgPicture.asset(
                icon.iconName,
                height: 70,
                width: 70,
              );
            },
          ],
        ),
      ),
    );
    if (cat != null) {
      state.didChange(cat);
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
    } else if (initials != null) {
      return initials.getSubCategory().hasTrans;
    }
    return false;
  }

  bool _hasTransValues() {
    if (transmissions == null) {
      _getTransmission().then((transmission) {
        setState(() {
          this.transmissions = transmission;
        });
      });
      return false;
    }
    return true;
  }

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
    } else if (initials != null) {
      return initials.getSubCategory().brandCount > 0;
    }
    return false;
  }

  bool _hasModel() {
    if (_brandKey.currentState != null) {
      BrandEntity brand = _brandKey.currentState.value as BrandEntity;
      return brand != null && brand.modelCount > 0;
    } else if (initials != null) {
      return initials.getBrand().modelCount > 0;
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
            [_getBrand],
            [
              (info) {
                BrandEntity brand = info;
                return brand.brandName;
              }
            ],
            sub,
            ["Brand"]),
      ),
    );
    if (brand != null) {
      state.didChange(brand[0] as BrandEntity);
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
                            if (value[1] != null)
                              return (value[1] as SubCategoryEntity)
                                  .categoryName;
                            return (value[0] as CategoryEntity).categoryName;
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
                            toValue: (value) => value.id,
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
                            fieldName: 'brand_model_id',
                            toValue: (value) => value.id,
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
                              toValue: (value) => value.id,
                              select: _selectBody,
                            ),
                          if (_hasTransValues())
                            ..._radioGroup<TransmissionEntity>(
                                label: 'Transmissions',
                                fieldName: 'transmission_id',
                                toString: (value) => value.transmission,
                                toValue: (value) => value.id,
                                values: transmissions),
                          ..._getTextField(
                              fieldName: 'mileage',
                              label: 'Mileage',
                              isNumber: true,
                              inputType: TextInputType.phone,
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
                        Stack(
                          children: <Widget>[
                            Column(
                              children: _getObjectField<List<dynamic>>(
                                key: _regionKey,
                                label: 'Region',
                                hint: "What Region is the Ad",
                                suffix: false,
                                validationText:
                                    "Please Ensure You Select the location of the Ad",
                                onSave: (value) {
                                  ad['country_id'] =
                                      (value[0] as CountryEntity).id;
                                  ad['state_id'] = (value[1] as StateEntity).id;
                                  ad['city_id'] = (value[2] as CityEntity).id;
                                },
                                toString: (value) {
                                  if (value[2] != null)
                                    return (value[2] as CityEntity).cityName;
                                  if (value[1] != null)
                                    return (value[1] as StateEntity).stateName;
                                  return (value[0] as CountryEntity)
                                      .countryName;
                                },
                                select: _selectRegion,
                              ),
                            ),
                            !gpsLoading
                                ? Positioned(
                                    right: 0,
                                    top: 5,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _getLocation();
                                      },
                                    ))
                                : Positioned(
                                    right: 15,
                                    top: 20,
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        value: null,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    ))
                          ],
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
                            toValue: (value) => EnumToString.parse(value),
                            values: Type.values),
                        ..._radioGroup<Condition>(
                            label: 'Condition Of Ad',
                            fieldName: 'ad_condition',
                            toString: (value) => EnumToString.parse(value),
                            toValue: (value) =>
                                EnumToString.parse(value).toLowerCase(),
                            values: Condition.values),
                        ..._getTextField(
                          label: 'Price',
                          isCurrency: true,
                          hint: "What's the Price of the Ad",
                          inputType: TextInputType.phone,
                          validationText:
                              "Please Ensure You enter the price of the Ad",
                          fieldName: 'price',
                        ),
                        ..._checkedBox(
                            fieldName: 'is_negotiable', label: 'Negotiable'),
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

  _getTextField(
      {String fieldName,
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
      bool isCurrency = false,
      bool isNumber = false}) {
    return <Widget>[
      TextFormField(
        initialValue: controller == null && initials != null
            ? initials.getInitial<String>(label)
            : null,
        inputFormatters: [
          if (isCurrency) MoneyFormatter(),
          if (isNumber) NumberFormatter()
        ],
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
          else if (fieldName != null) {
            if (isCurrency)
              ad[fieldName] = moneyFormat.parse(value.trim());
            else if (isNumber)
              ad[fieldName] = numberFormat.parse(value.trim());
            else
              ad[fieldName] = value.trim();
          }
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

  _getGpsLocation(Geolocator geolocator) async {
    print("Getting GPS Position");
    geolocator
        .getCurrentPosition(
            locationPermissionLevel: GeolocationPermission.location,
            desiredAccuracy: LocationAccuracy.high)
        .timeout(Duration(seconds: 10), onTimeout: () {
      print("GPS Time Out");
      showToast(
          "Please you need to be outsied in other to obtain your current location");
      setState(() {
        gpsLoading = false;
      });
      return null;
    }).then((position) async {
      print("Position is $position");
      if (address == null)
        address = await GeocodingService.getPositionAddress(position);
      print(
          "country ${address.getCountry()} state ${address.getState()} city ${address.getCity()} ");
      LocationEntity location = await ApiService.getService().getAddress(
          address.getCountry(),
          address.getCountryCode(),
          address.getState(),
          address.getCity());
      print('location is $location');
      _regionKey.currentState
          .didChange([location.country, location.states, location.city]);
      setState(() {
        gpsLoading = false;
      });
    });
  }

  _getLocation() async {
    setState(() {
      gpsLoading = true;
    });
    print("Getting Position");
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus status =
        await geolocator.checkGeolocationPermissionStatus();
    print("GPS status $status");
    geolocator.isLocationServiceEnabled().then((enabled) async {
      if (enabled) {
        _getGpsLocation(geolocator);
      } else {
        bool isGpsService = await tuneGps(context, geolocator);
        print("GPS Service is online $isGpsService");
        if (isGpsService) {
          _getGpsLocation(geolocator);
        } else {
          showToast(
              "Please you need to enable your GPS service to obtain your location");
          setState(() {
            gpsLoading = false;
          });
        }
      }
    });
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
    bool suffix = true,
    GlobalKey<FormFieldState> key,
    GlobalKey<FormFieldState> argument,
  }) {
    return <Widget>[
      FormField<T>(
          initialValue: initials != null ? initials.getInitial<T>(label) : null,
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
                      suffixIcon: suffix ? Icon(Icons.arrow_drop_down) : null,
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
    initialValue =
        initials != null ? initials.getInitial<bool>(label) : initialValue;
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
      String Function(T) toString,
      dynamic Function(T) toValue}) {
    return <Widget>[
      FormField<T>(
          initialValue: initials != null ? initials.getInitial<T>(label) : null,
          validator: (value) {
            if (value == null) return "Please Ensure You Select the $label";
            return null;
          },
          onSaved: (value) {
            if (fieldName != null) ad[fieldName] = toValue(value);
          },
          builder: (state) {
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
                                  capitalizeFirst(
                                      toString(value).toLowerCase()),
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

class MoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    String money = "";
    try {
      var value = double.tryParse(newValue.text.trim());
      if (value == null) value = moneyFormat.parse(newValue.text.trim());
      money = moneyFormat.format(value);
    } on FormatException {
      money = "";
    }

    int offset = newValue.selection.end + (money.length - newValue.text.length);

    return TextEditingValue(
        text: money, selection: TextSelection.collapsed(offset: offset));
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    String money = "";
    try {
      var value = double.tryParse(newValue.text.trim());
      if (value == null) value = numberFormat.parse(newValue.text.trim());
      money = numberFormat.format(value);
    } on FormatException {
      money = "";
    }

    int offset = newValue.selection.end + (money.length - newValue.text.length);

    return TextEditingValue(
        text: money, selection: TextSelection.collapsed(offset: offset));
  }
}
