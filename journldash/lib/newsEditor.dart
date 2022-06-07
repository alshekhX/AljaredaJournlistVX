import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:journldash/Provider/articleProvider.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert' show utf8;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NewsEditor extends StatefulWidget {
  const NewsEditor({Key? key}) : super(key: key);

  @override
  _NewsEditorState createState() => _NewsEditorState();
}

class _NewsEditorState extends State<NewsEditor> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  List<Uint8List>? bytesImage;

  HtmlEditorController controller = new HtmlEditorController();
  TextEditingController? titleController, categoryController, placeController;
  var imageFile;
  String? droDownValue;
  FocusNode? artName;

  @override
  void initState() {
    artName = FocusNode();

    titleController = TextEditingController();
    placeController = TextEditingController();

    categoryController = TextEditingController();
    // checkController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  // checkController()async {
  //   await Provider.of<ArticlePrvider>(context, listen: false).controller.getText() == null
  //       ? controller = HtmlEditorController()
  //       : controller ==
  //           Provider.of<ArticlePrvider>(context, listen: false).controller;
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 211, 213, 215),

      // backgroundColor: Colors.grey.withOpacity(.1),
      body: PointerInterceptor(
        child: GestureDetector(
          onTap: () {
            artName!.unfocus();
          },
          child: Container(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * .1,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                                height: size.height * .08,
                                width: size.width * .25,
                                child: TextFormField(
                                  focusNode: artName,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'يجب ادخال عنوان الخبر';
                                    }
                                    return null;
                                  },
                                  controller: titleController,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: size.width * .04,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .05),
                              child: Container(
                                width: size.width * .1,
                                child: Text(
                                  'عنوان الخبر',
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * .02),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                                height: size.height * .08,
                                width: size.width * .25,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder()),
                                  maxLines: null,
                                  minLines: null,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'يجب ادخال مكان الخبر';
                                    }
                                    return null;
                                  },
                                  controller: placeController,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: size.width * .04,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .05),
                              child: Container(
                                width: size.width * .1,
                                child: Text(
                                  'المكان',
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * .02,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    elevation: 0,
                                    menuMaxHeight: 200,
                                    value: droDownValue,
                                    hint: Text(
                                      "حدد فئة الخبر ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    items: <String>[
                                      "سياسة",
                                      "فنون",
                                      "تعليم",
                                      'طعام',
                                      'رياضة',
                                      'فلسفة',
                                      'أدب',
                                      'جريمة',
                                      'إقتصاد',
                                      'تكنولوجيا',
                                      'تاريخ',
                                      "دين",
                                      "علم نفس",
                                      'صحة',
                                      'كوارث'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(
                                          value,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    onTap: () {
                                      controller.disable();
                                    },
                                    onChanged: (newvalue) {
                                      droDownValue = newvalue;
                                      controller.enable();

                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * .03,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width * .3),
                            child: Container(
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 102, 116, 130),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                              ),
                              child: Text(
                                'الصورة الرئيسية',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () async {
                                // Pick an image
                                bytesImage = await ImagePickerWeb
                                    .getMultiImagesAsBytes();

                                setState(() {});
                              },
                            )),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .05,
                        ),
                        Container(
                          width: size.width * .8,
                          child: HtmlEditor(
                            controller: controller,
                            htmlToolbarOptions:
                                HtmlToolbarOptions(defaultToolbarButtons: [
                              StyleButtons(),
                              FontSettingButtons(),
                              FontButtons(),
                              ColorButtons(),
                              ListButtons(),
                              ParagraphButtons(),
                              InsertButtons(otherFile: true),
                              OtherButtons(),
                            ]), //required
                            htmlEditorOptions: HtmlEditorOptions(
                              shouldEnsureVisible: true,
                              autoAdjustHeight: true,
                              hint: ".... اكتب الخبر هنا ",

                              //initalText: "text content initial, if any",
                            ),
                            otherOptions: OtherOptions(
                              height: size.height * .7,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: size.height * .10,
                          width: size.width * .2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 102, 116, 130),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            ),
                            onPressed: () async {
                              CustomProgressDialog progressDialog =
                                  CustomProgressDialog(context, blur: 10);

                              if (_formKey.currentState!.validate()) {
                                if (droDownValue == null) {
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: "يجب تحديد فئة الخبر",
                                      ));
                                } else {
                                  try {
                                    // If the form is valid, display a Snackbar.
                                    Provider.of<ArticlePrvider>(context,
                                            listen: false)
                                        .articleType = 'news';
                                    progressDialog.show();
                                    String description =
                                        await controller.getText();

                                    String response = await Provider.of<
                                                ArticlePrvider>(context,
                                            listen: false)
                                        .createAnArticle(
                                            titleController!.text,
                                            description,
                                            // ignore: prefer_if_null_operators
                                            droDownValue!,
                                            placeController!.text,
                                            bytesImage);

                                    if (response == 'success') {
                                      progressDialog
                                          .dismiss(); // showAlertDialog(context, 'نجحت العملية',
                                      //     "تم حفظ المقال بنجاح");
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.success(
                                          message: "تم حفظ الخبر بنجاح",
                                        ),
                                      );
                                      // } else if (response == 'error') {
                                      //   await pr.hide();

                                      //   showAlertDialog(context, ' خطا', "خطا غير معروف");
                                    } else {
                                      progressDialog.dismiss();
                                      showTopSnackBar(
                                          context,
                                          CustomSnackBar.error(
                                            message: "خطأ. $response",
                                          ));
                                    }
                                  } catch (e) {
                                    progressDialog.dismiss();
                                    showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: "خطأ. $e",
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Text(
                              'اضافة الخبر',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .05,
                        )
                      ],
                    ),
                  ),
                  (bytesImage != null)
                      ? Positioned(
                          left: 2,
                          top: 25,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: size.width * .2),
                              child: Container(
                                  width: size.width * .25,
                                  height: size.height * .30,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: bytesImage!
                                          .map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Image.memory(e),
                                              ))
                                          .toList())),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String message, String title) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
