import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'Dashboard.dart';
import 'Provider/articleProvider.dart';
import 'authProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    passwordController = TextEditingController();
    emailController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    passwordController = TextEditingController();
    emailController = TextEditingController();

    Size size = MediaQuery.of(context).size;
    var textfieldText = 'البريد الإلكتروني';
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height * .15,
            ),
            Center(
              child: Container(
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * .05,
            ),
            Center(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * .4,
                          ),
                          Center(
                            child: Container(
                                margin: EdgeInsets.all(2),
                                width: size.width * .18,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(
                                        size.height * .02), // Added this

                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2.0),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  controller: emailController,
                                  textAlign: TextAlign.right,
                                  validator: (value) {
                                    Pattern pattern =
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                    RegExp regex =
                                        new RegExp(pattern.toString());
                                    if (!regex.hasMatch(value!) ||
                                        value.isEmpty)
                                      return 'Please enter a valid email';
                                  },
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: size.width * .02,
                                right: size.width * .01),
                            child: Text(
                              textfieldText,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * .4,
                          ),
                          Center(
                            child: Container(
                                margin: EdgeInsets.all(2),
                                width: size.width * .18,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'أدخل كلمة السر';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(
                                        size.height * .02), // Added this

                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2.0),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  controller: passwordController,
                                  textAlign: TextAlign.right,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: size.width * .03,
                                right: size.width * .01),
                            child: Text(
                              'كلمة السر',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1)),
                        child: TextButton(
                          onPressed: () async {
                            CustomProgressDialog progressDialog =
                                CustomProgressDialog(context, blur: 10);

                            // if (_formKey.currentState.validate()) {
                            progressDialog.show();
                            try {
                              print(emailController
                              !.text +
                                  passwordController!.text);
                              String res = await Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .signIN('kaenona@gmail.com', '12345678');
                              // .signIN(emailController.text,
                              //     passwordController.text);

                              if (res == 'success') {
                                progressDialog.dismiss();
                                Provider.of<ArticlePrvider>(context,
                                        listen: false)
                                    .token = Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .token!;

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                              } else {
                                progressDialog.dismiss();
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: "خطأ في التسجيل $res",
                                    ));
                              }
                            } catch (e) {
                                progressDialog.dismiss();
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message: "خطأ في التسجيل $e",
                                  ));
                            }
                            // }
                          },
                          child: Container(
                            child: Text(
                              'تسجيل',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

}
