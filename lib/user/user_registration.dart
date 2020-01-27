import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postit/app.dart';

class UserRegistration extends StatefulWidget {
  static get routeName => "user/register";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserRegistration();
  }
}

enum Gender { MALE, FEMALE }

class _UserRegistration extends State<UserRegistration> {
  static const int _imageQuality = 30;
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  dynamic _profilePic;
  final Map<String, dynamic> user = {};

  AccountManagement manager;
  UserEntity cUser;
  bool ready = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (ready) {
      return _getView();
    } else {
      manager.isSignedIn().then((isSignedIn) async {
        UserEntity user;
        if (isSignedIn) {
          user = await manager.getUser();
          user = await ApiService.getService().getUser(user.id, user.email);
        }
        setState(() {
          cUser = user;
          _profilePic = user.photoLink;
          ready = true;
        });
      });
      return Scaffold();
    }
  }

  Widget _getView() {
    return Scaffold(
      body: _getContent(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        color: Colors.green,
        elevation: 10,
        child: FlatButton(
          onPressed: () {
            var formState = _formKey.currentState;
            if (formState.validate()) {
              formState.save();

              print("The user is $user");
              if (user == null) {
                ApiService.getService().register(user, _profilePic).then((msg) {
                  print("The Result is $msg");
                  showToast(msg.result);
                  if (msg.success) Navigator.of(context).pop(msg);
                });
              } else {
                user['id'] = cUser.id;
                File image;
                if (_profilePic is File) image = _profilePic;
                manager.updateUsersDetails(user, image).then((value) {
                  print("The Result is ${value.msg}");
                  showToast(value.msg);
                  if (value.success) Navigator.of(context).pop(value.msg);
                });
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              user == null ? "Register" : "Edit",
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    manager = AccountManagement.getInstance();
  }

  _getContent() {
    return CustomScrollView(
      slivers: <Widget>[
        _profilePic == null ? _getAppBarNoImage() : _getAppBarImages(),
        _getForm(),
      ],
    );
  }

  Future galleryPicker() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: _imageQuality);
    if (image != null) {
      setState(() {
        _profilePic = image;
      });
    }
  }

  Future cameraPicker() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: _imageQuality);
    if (image != null) {
      setState(() {
        _profilePic = image;
      });
    }
  }

  Widget _getImage(dynamic image) {
    if (image is File) return Image.file(image, fit: BoxFit.cover);
    if (image is String && image.isNotEmpty)
      return CachedNetworkImage(
        imageUrl: '$image',
        fit: BoxFit.cover,
      );
    else
      return Container(
        color: Colors.white,
        child: SvgPicture.asset("assets/user_avatar.svg"),
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
        "Register Your Profile",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                    constraints: BoxConstraints.expand(),
                    child: _getImage(_profilePic)),
              ),
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
                          Colors.white,
                          Colors.white70,
                        ]),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                constraints: BoxConstraints.expand(height: 80),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white70,
                      ]),
                ),
              ),
              top: 0,
              left: 0,
              right: 0,
            )
          ],
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
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

  _selectCountry(FormFieldState<CountryEntity> state) async {
    final region = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepperSelection(
            [
              _getCountry,
            ],
            [
              (info) {
                CountryEntity country = info;
                return country.countryName;
              }
            ],
            null,
            ["Country"]),
      ),
    );
    if (region != null) {
      state.didChange(region[0] as CountryEntity);
    }
    return region;
  }

  Future<List<CountryEntity>> _getCountry({dynamic params}) async {
    return await ApiService.getService().getCountry();
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
                        ..._getTextField(
                            fieldName: 'first_name',
                            label: 'First Name',
                            hint: 'Enter Your First Name',
                            validationText:
                                'Please Ensure You Enter Your First Name'),
                        ..._getTextField(
                            fieldName: 'last_name',
                            label: 'Last Name',
                            hint: 'Enter Your Last Name',
                            validationText:
                                'Please Ensure You Enter Your Last Name'),
                        ..._getTextField(
                            fieldName: 'email',
                            label: 'Email Addrees',
                            inputType: TextInputType.emailAddress,
                            hint: 'Enter Your Email Address',
                            validationText:
                                'Please Ensure You Enter Your Email Address'),
                        ..._getTextField(
                            fieldName: 'phone',
                            inputType: TextInputType.phone,
                            label: 'Phone Number',
                            hint: 'Enter Your Phone Number',
                            validationText:
                                'Please Ensure You Enter Your Phone Number'),
                        ..._getObjectField<CountryEntity>(
                            fieldName: 'country_id',
                            label: 'Country',
                            hint: 'Enter Your Country',
                            validationText:
                                'Please Ensure You Select Your Country',
                            select: _selectCountry,
                            toValue: (country) => country.id,
                            toString: (country) => country.countryName),
                        ..._radioGroup(
                            fieldName: 'gender',
                            label: 'Gender',
                            toString: (value) => EnumToString.parse(value),
                            values: Gender.values),
                        if (user == null) ...[
                          ..._getTextField(
                              controller: _passwordController,
                              fieldName: 'password',
                              label: 'Password',
                              hint: 'Enter Your Password',
                              validationText:
                                  'Please Ensure You Enter Your Password',
                              obscured: true),
                          ..._getTextField(
                              label: 'Confirm Password',
                              hint: 'Enter The Password Again',
                              validationText:
                                  'Please Ensure You Enter The Password Again',
                              passwordValidationText:
                                  'Please Ensure the Password is Consistent',
                              validatorController: _passwordController,
                              obscured: true),
                        ]
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
      TextEditingController validatorController}) {
    return <Widget>[
      TextFormField(
        initialValue: user != null ? cUser.getInitial<String>(label) : null,
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
          if (fieldName != null) user[fieldName] = value.trim();
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: label, hintText: hint),
      ),
      SizedBox(
        height: 30,
      ),
    ];
  }

  _getObjectField<T>(
      {String fieldName,
      String label,
      String hint,
      String validationText,
      dynamic Function(T value) toValue,
      String Function(T value) toString,
      dynamic Function(FormFieldState<T> state) select}) {
    return <Widget>[
      FormField<T>(
          initialValue: user != null ? cUser.getInitial<T>(label) : null,
          validator: (value) {
            if (value == null) return validationText;
            return null;
          },
          onSaved: (value) {
            user[fieldName] = toValue(value);
          },
          builder: (state) {
            FocusNode focus = FocusNode();
            TextEditingController controller = TextEditingController();
            focus.addListener(() {
              focus.unfocus();
              select(state);
            });

            if (state.value != null) controller.text = toString(state.value);

            return Column(
              children: <Widget>[
                TextField(
                  focusNode: focus,
                  controller: controller,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
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

  _radioGroup<T>(
      {String fieldName,
      String label,
      List<T> values,
      String Function(T) toString}) {
    return [
      FormField<T>(
          initialValue: user != null ? cUser.getInitial<T>(label) : null,
          validator: (value) {
            if (value == null) return "Please Ensure You Select the $label";
            return null;
          },
          onSaved: (value) {
            if (fieldName != null)
              user[fieldName] = toString(value).toLowerCase();
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
