import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import 'Provider/articleProvider.dart';
import 'models/crossWord.dart';

class crossWordEdit extends StatefulWidget {
  const crossWordEdit({Key? key}) : super(key: key);

  @override
  _crossWordEditState createState() => _crossWordEditState();
}

class _crossWordEditState extends State<crossWordEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? wordsRow, wordsColumn, wordsQesRow, wordsQesColumn;

  String? gameQuRestion;

  List<String>? rowWordsList;
  List<String>? colWordsList;
  List<String>? rowQesList;
  List<String>? coluQesList;

  bool gameon = false;

  @override
  void initState() {
    // checkController();

    wordsColumn = TextEditingController();
    wordsRow = TextEditingController();

    wordsQesRow = TextEditingController();

    wordsQesColumn = TextEditingController();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 211, 213, 215),
      body: Container(
        child: Row(
          children: [
            gameon == true
                ? Container(
                    width: size.width * .4,
                    child: CrossWords(
                      rowWords: rowWordsList!,
                      colmnWords: colWordsList!,
                      qesColumn: coluQesList!,
                      qesRow: rowQesList!,
                      context: context,
                    ),
                  )
                : Center(
                    child: Container(
                        width: size.width * .48,
                        child: LoadingBouncingLine.circle()),
                  ),
            Container(
              width: size.width * .48,
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        SizedBox(
                          height: size.height * .1,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                                width: size.width * .25,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'أدخل كلمات الصف';
                                    }
                                    return null;
                                  },
                                  controller: wordsRow,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: size.width * .06,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .05),
                              child: Container(
                                width: size.width * .1,
                                child: Text(
                                  'كلمات الصف',
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
                                width: size.width * .25,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  maxLines: null,
                                  minLines: null,
                                  controller: wordsColumn,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: size.width * .06,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .05),
                              child: Container(
                                width: size.width * .1,
                                child: Text(
                                  'كلمات العمود',
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
                            Container(
                                width: size.width * .25,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  maxLines: null,
                                  minLines: null,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'أدخل أسئلة الصف';
                                    }
                                    return null;
                                  },
                                  controller: wordsQesRow,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: size.width * .06,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .05),
                              child: Container(
                                width: size.width * .1,
                                child: Text(
                                  ' أسئلة الصف',
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
                            Container(
                                width: size.width * .25,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  maxLines: null,
                                  minLines: null,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'أدخل أسئلة العمود';
                                    }
                                    return null;
                                  },
                                  controller: wordsQesColumn,
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: size.width * .06,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * .05),
                              child: Container(
                                width: size.width * .1,
                                child: Text(
                                  'أسئلة العمود ',
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * .04,
                        ),
                      ])),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                           style:ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 102, 116, 130),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                  ),
                            onPressed: () async {
                              CustomProgressDialog progressDialog =
                                  CustomProgressDialog(context, blur: 10);

                              String res = await Provider.of<ArticlePrvider>(
                                      context,
                                      listen: false)
                                  .createGame(rowWordsList!, colWordsList!,
                                      rowQesList!, coluQesList!);

                              if (res == 'success') {
                                progressDialog.show();
                                showAlertDialog(
                                    context, 'نجاح', "تم إضافة اللعبة");
                              } else {
                                progressDialog.dismiss();
                                showAlertDialog(context, 'خطأ', "$res");
                              }
                            },
                            child: Text('إرسال')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                           style:ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 102, 116, 130),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                  ),
                            onPressed: () async {

                              if (_formKey.currentState!
                              
                              .validate()) {
                                gameon = false;
                                rowWordsList = wordsRow!.text.split(',');
                                colWordsList = wordsColumn!.text.split(',');
                                rowQesList = wordsQesRow!.text.split(',');
                                coluQesList = wordsQesColumn!.text.split(',');
                                gameon = true;

                                setState(() {});

                                print(rowWordsList);
                                print(colWordsList);
                                print(rowQesList);
                                print(coluQesList);
                              }
                            },
                            child: Text('أظهر الشكل')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String message, String title) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("حسنا"),
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
