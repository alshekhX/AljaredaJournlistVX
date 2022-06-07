import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:convert' show utf8;

import 'Provider/articleProvider.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final _formKey = GlobalKey<FormState>();
  FocusNode? artName;
  String? drop;
  final picker = ImagePicker();

  String? droDownValue;
  HtmlEditorController controller = new HtmlEditorController();
  TextEditingController? titleController, categoryController;
  Uint8List? image;

  @override
  void initState() {
    artName = FocusNode();
    artName = FocusNode();

    titleController = new TextEditingController();

    categoryController = new TextEditingController();
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
                                margin: EdgeInsets.all(2),
                                child: TextFormField(
                                  focusNode: artName,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                                                                                             fillColor: Colors.white, filled: true,

                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'يجب ادخال عنوان المقال';
                                    }
                                    return null;
                                  },
                                  controller: titleController,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: size.width * .06,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .02),
                              child: Container(
                                width: size.width * .1,
                                child: Text(
                                  'عنوان المقال',
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
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .20),
                              child: Container(
                                child: DropdownButton<String>(
                                  onTap: () {
                                    controller.disable();
                                  },
                                  elevation: 0,
                                  menuMaxHeight: 200,
                                  value: droDownValue,
                                  hint: Text(
                                    "حدد فئة المقال ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  items: <String>[
                                    "سياسة",
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
                                    "فنون",
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
                                  onChanged: (newvalue) {
                                    droDownValue = newvalue;
                                    //enable html controller to solve focus issues
                                    controller.enable();

                                    setState(() {});
                                  },
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
                                   style:ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 102, 116, 130),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                  ),
                              child: Text('الصورة الرئيسية',style: TextStyle(fontSize: 18),),
                              onPressed: () async {
 image = await ImagePickerWeb.getImageAsBytes();

      setState(() {});
                                // Pick an image
                                // bytesImage = await picker.pickMultiImage();

                                // imageFile = image!
                                //     .map((e) async => await e.readAsBytes())
                                //     .toList();
                                // // imageFile = await image!.readAsBytes();
                                // // print(imageFile);

                                // setState(() {});
                              },
                            )),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .07,
                        ),
                        Container(
                          width: size.width * .8,
                          child: HtmlEditor(
                            htmlToolbarOptions:
                                HtmlToolbarOptions(defaultToolbarButtons: [
                              StyleButtons(),
                              FontSettingButtons(),
                              FontButtons(),
                              ColorButtons(),
                              ListButtons(),
                              ParagraphButtons(),
                              InsertButtons(),
                              OtherButtons(),
                            ]),
                            controller: controller,
                            //required
                            htmlEditorOptions: HtmlEditorOptions(
                              shouldEnsureVisible: true,
                              autoAdjustHeight: true,
                              hint: "اكتب المقال هنا ....",
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

                                style:ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 102, 116, 130),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
                                    progressDialog.show();

                                    Provider.of<ArticlePrvider>(context,
                                            listen: false)
                                        .articleType = 'article';

                                    String description =
                                        await controller.getText();

                                    String response =
                                        await Provider.of<ArticlePrvider>(
                                                context,
                                                listen: false)
                                            .createNew(
                                                titleController!.text,
                                                description,
                                                droDownValue == null
                                                    ? ''
                                                    : droDownValue!,
                                                '',
                                                image!);

                                    if (response == 'success') {
                                      progressDialog.dismiss();
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
                              'اضافة المقال',
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
                  (image != null)
                      ? Positioned(
                          left: 2,
                          top: 25,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: size.width * .2),
                              child: Container(
                                  width: size.width * .25,
                                  height: size.height * .30,
                                  child: Image.memory(image!)),
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
    controller.disable();

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        controller.enable();

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
