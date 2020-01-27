import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:postit/app.dart';

Future<PostingReport> processAd(
    BuildContext context, Map<String, dynamic> ad, List<File> images,
    {bool update = false}) async {
  return await showDialog<PostingReport>(
      context: context,
      builder: (context) {
        return PostingProgress(
          ad,
          images,
          update: update,
        );
      });
}

class PostingProgress extends StatefulWidget {
  final Map<String, dynamic> _ad;
  final List<File> _images;
  final bool update;

  PostingProgress(this._ad, this._images, {Key key, this.update})
      : super(key: key);

  @override
  _PostingProgressState createState() {
    return _PostingProgressState(_ad, _images, update: update);
  }
}

class _PostingProgressState extends State<PostingProgress> {
  String currentTask;
  double progress = 0;

  final Map<String, dynamic> _ad;
  final List<File> _images;

  ApiService _apiService;

  static const double info = 0.2;
  static const double imageInfo = 0.8;

  final bool update;

  _PostingProgressState(this._ad, this._images, {this.update});

  @override
  void initState() {
    super.initState();
    _apiService = ApiService.getService();
    if (update)
      _processEdit();
    else
      _processPost();
  }

  @override
  void dispose() {
    super.dispose();
    _apiService = null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _postingProgress();
  }

  Widget _postingProgress() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 30, left: 10, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    update ? "Updating Your Ad" : "Posting Your Ad",
                    style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Posting Progress ( ${(progress * 100).toInt()}% ) : $currentTask",
                    style: TextStyle(
                        height: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.green.withOpacity(0.3),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _processPost() async {
    PostMessageEntity message = await _postAd();
    await _postAdImage(message.result.adId);
    Navigator.of(this.context)
        .pop(PostingReport(true, "Your Ad has been Posted Successfully"));
  }

  _processEdit() async {
    await _editAd();
    await _postAdImage(_ad['ad_id']);
    Navigator.of(this.context)
        .pop(PostingReport(true, "Your Ad has been updated Successfully"));
  }

  Future<PostMessageEntity> _postAd() async {
    setState(() {
      currentTask = "Posting Informations";
    });
    PostMessageEntity message = await _apiService.postAd(_ad);
    print("The Result is $message");
    if (message.success)
      setState(() {
        progress += info;
      });
    return message;
  }

  Future<MessageEntity> _editAd() async {
    setState(() {
      currentTask = "Posting Informations";
    });
    MessageEntity message = await _apiService.editAd(_ad);
    print("The Result is $message");
    if (message.success)
      setState(() {
        progress += info;
      });
    return message;
  }

  _postAdImage(int adId) async {
    double imageProgress = imageInfo / _images.length;
    int index = 1;

    for (int i = 0; i < _images.length; ++i) {
      setState(() {
        currentTask =
            "Posting Images ( ${index + 1} / ${_images.length} ) ${basename(_images[i].path)}";
      });

      MediaMessageEntity message =
          await _apiService.postAdImage(adId, _ad['user_id'], _images[i]);

      if (message.success) {
        setState(() {
          progress += imageProgress;
        });
      }
    }
  }
}

class PostingReport {
  final bool success;
  final String message;

  PostingReport(this.success, this.message);
}
