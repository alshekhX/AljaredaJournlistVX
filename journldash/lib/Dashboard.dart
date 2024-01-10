// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journldash/Provider/articleProvider.dart';
import 'package:journldash/htmltest.dart';
import 'package:ndialog/ndialog.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart' as intl;

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:sizer/sizer.dart';

import 'dart:ui' as ui;

import 'articleEditor.dart';
import 'authProvider.dart';
import 'gameEditor.dart';
import 'models/Article.dart';
import 'newsEditor.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController? titleController,
      descriptionController,
      artTypeController,
      categoryController,
      breakingHeadlineController,
      descriptionC;
  XFile? image;
  var imageFile;
  List? articles;

  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  HtmlEditorController controller = new HtmlEditorController();
  @override
  void initState() {
    // checkController();
    getArticle();

    titleController = new TextEditingController();
    descriptionController = new TextEditingController();
    artTypeController = new TextEditingController();
    categoryController = new TextEditingController();
    breakingHeadlineController = new TextEditingController();
    descriptionC = new TextEditingController();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context, listen: false).user;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      // appBar: AppBar(
      //   title: Center(
      //     child: Text(
      //       'الجريدة',
      //       style: TextStyle(
      //           fontFamily: ArabicFonts.El_Messiri,
      //           fontSize: 40,
      //           package: 'google_fonts_arabic'),
      //     ),
      //   ),Fe
      // ),
      body: Container(
        height: 100.h,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'img5.jpeg',
          ),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.fromLTRB(size.width * .15, size.height * .02,
              size.width * .15, size.height * .02),
          child: Container(
            width: size.width * .99,
            decoration: BoxDecoration(
                color: Color.fromARGB(224, 255, 255, 255).withOpacity(.9),
                border: Border.all(color: Colors.black, width: 3)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   height: size.height * .1,
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(width: 3, color: Colors.black),
                  //     ),
                  //   ),
                  //   child: AppBar(
                  //     automaticallyImplyLeading: false,

                  //     backgroundColor: Color.fromARGB(224, 255, 255, 255).withOpacity(.5),
                  //     elevation: 0,
                  //     title: Center(
                  //       child: Text(
                  //         'الجريدة',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //             fontSize: 50,
                  //             ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 2.h,
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: size.height * .02, top: size.height * .02),
                        child: Container(
                          child: InkWell(
                            onLongPress: () async {
                              CustomProgressDialog progressDialog =
                                  CustomProgressDialog(context, blur: 10);

                              print(user!.photo);
                              // Pick an image
                              image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              progressDialog.show();
                              if (image != null) {
                                try {
                                  String res = await Provider.of<AuthProvider>(
                                          context,
                                          listen: false)
                                      .updateUserImage(image!);
                                  if (res == 'success') {
                                    await Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .getUserData();

                                    setState(() {});
                                    progressDialog.dismiss();

                                    await showAlertDialog(context,
                                        'تم الإرسال بنجاح', "نجحت العملية");
                                  } else {
                                    progressDialog.dismiss();

                                    await showAlertDialog(
                                      context, "خطأ في الخادم", "خطأ");
                                  }
                                } catch (e) {
                                  progressDialog.dismiss();
                                  print(e);
                                  await showAlertDialog(
                                      context, "خطأ في الخادم", "خطأ");
                                }
                              }

                              setState(() {});
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 100,
                              child: CircleAvatar(
                                radius: 98,
                                backgroundImage:
                                    'http://192.168.43.250:8000/uploads/photos/' +
                                                user!.photo! !=
                                            'no_image.jpg'
                                        ? NetworkImage(
                                            'http://192.168.43.250:8000/uploads/photos/' +
                                                user.photo!,
                                          ) as ImageProvider
                                        : AssetImage('assets/profilePlace.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * .93,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * .02,
                                  right: size.width * .02),
                              child: Container(
                                child: Text(
                                  '${user.firstName} ${user.lastName}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  // top: size.height * .01,
                                  left: size.width * .01,
                                  right: size.width * .01),
                              child: Center(
                                child: Container(
                                    child: Text(
                                  user.email!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Container(
                              width: 60.w,
                              child: Divider(
                                color: Colors.grey.shade800,
                                thickness: 1,
                              ),
                            ),
                            InkWell(
                              onLongPress: () async {
                                await changeUserDesDialog(context, size);
                                setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: size.height * .01,
                                    bottom: size.height * .02,
                                    left: size.width * .01,
                                    right: size.width * .01),
                                child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      user.description == null
                                          ? 'لا يوجد وصف'
                                          : user.description!,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 18),
                                    )),
                              ),
                            ),
                            Container(
                              width: 60.w,
                              child: Divider(
                                color: Colors.grey.shade800,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: size.width * .05),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: DigitalClock(
                        hourMinuteDigitTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        secondDigitTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                        digitAnimationStyle: Curves.elasticOut,
                        is24HourTimeFormat: false,
                        areaDecoration: BoxDecoration(),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 3.h,
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .035,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Container(
                          width: size.width * .14,
                          height: size.width * .14,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => crossWordEdit()));
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    child: Text(
                                      'كلمات متقاطعة',
                                      style: TextStyle(fontSize: 4.sp),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.bottomCenter,
                                      width: size.width * .1,
                                      height: size.width * .1,
                                      child: Image.network(
                                          "https://static.thenounproject.com/png/886814-200.png")),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * .02,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1)),
                        child: InkWell(
                          onTap: () async {
                            await _displayTextInputDialog(context, size);

                            Provider.of<ArticlePrvider>(context, listen: false)
                                .articleType = 'breaking';
                          },
                          child: Container(
                            width: size.width * .14,
                            height: size.width * .14,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    child: Text(
                                      'خبر عاجل',
                                      style: TextStyle(fontSize: 4.sp),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size.width * .015,
                                    right: size.width * .01,
                                    left: size.width * .01,
                                  ),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        Colors.grey, BlendMode.saturation),
                                    child: Container(
                                        alignment: Alignment.bottomCenter,
                                        width: size.width * .09,
                                        height: size.width * .09,
                                        child: Image.asset('assets/img2.png')),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * .02,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1)),
                        child: InkWell(
                          onTap: () {
                            Provider.of<ArticlePrvider>(context, listen: false)
                                .articleType = 'article';
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Editor()));
                          },
                          child: Container(
                            width: size.width * .14,
                            height: size.width * .14,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    child: Text(
                                      ' مقال',
                                      style: TextStyle(fontSize: 4.sp),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size.width * .02,
                                    right: size.width * .01,
                                    left: size.width * .01,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: size.width * .08,
                                      height: size.width * .08,
                                      child: Image.network(
                                          'https://icon-library.com/images/article-icon-png/article-icon-png-27.jpg'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * .02,
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<ArticlePrvider>(context, listen: false)
                              .articleType = 'article';
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewsEditor()));
                        },
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Container(
                            width: size.width * .14,
                            height: size.width * .14,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    child: Text(
                                      'خبر',
                                      style: TextStyle(fontSize: 4.sp),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    width: size.width * .1,
                                    height: size.width * .1,
                                    child: Image.asset('assets/img1.png'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * .02,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 4.h,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Container(
                        child: Text(
                          'مقالات و أخبار الكاتب',
                          style: TextStyle(fontSize: 8.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),

                  Container(
                    width: 50.w,
                    child: Consumer<ArticlePrvider>(
                        builder: (context, articleProv, _) {
                      try {
                        if (articles == null) {
                          return Container(
                            width: 100,
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (articles!.length == 0) {
                          return Center(
                              child: Container(
                            width: 200,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'لا توجد مقالات او أخبار للكاتب ',
                                  style: TextStyle(
                                    fontSize: 6.sp,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    ':(',
                                    style: TextStyle(
                                      fontSize: 5.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ));
                        } else {
                          List<Widget> articlesColumn = [];

                          for (int i = 0; i < articles!.length; i++) {
                            if (articles![i].articletype[0] != 'breaking') {
                              articlesColumn.add(InkWell(
                                onTap: () async {
                                  ArticleModel articleModel = articles![i];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ArticleScreen(articles![i])));
                                  // pushNewScreen(context,
                                  //     pageTransitionAnimation:
                                  //         PageTransitionAnimation.scale,
                                  //     screen: test(articleModel),
                                  //     withNavBar: false);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ExpansionTileCard(
                                      leading: Text(
                                        articles![i].articletype[0] == 'article'
                                            ? 'مقال'
                                            : 'خبر',
                                        style: TextStyle(fontSize: 3.sp),
                                      ),
                                      title: Text(
                                        articles![i].title,
                                        style: TextStyle(fontSize: 5.sp),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .01),
                                        child: Text(
                                          intl.DateFormat.yMMMMEEEEd('ar_SA')
                                              .format(
                                            articles![i].createdAt,
                                          ),
                                          style: TextStyle(fontSize: 3.5.sp),
                                        ),
                                      ),
                                      children: <Widget>[
                                        Divider(
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 8.0,
                                            ),
                                            child: articles![i]
                                                    .assets
                                                    .isNotEmpty
                                                ? Container(
                                                    child: CachedNetworkImage(
                                                      imageUrl: articles![i]
                                                                      .articletype[
                                                                  0] ==
                                                              'article'
                                                          ? "http://192.168.43.250:8000/uploads/photos/" +
                                                              articles![i].photo
                                                          : "http://192.168.43.250:8000/uploads/photos/" +
                                                              articles![i]
                                                                  .assets[0],
                                                      placeholder: (context,
                                                              url) =>
                                                          Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        enabled: true,
                                                        child: Container(
                                                          width:
                                                              size.width * .9,
                                                          height:
                                                              size.height * .2,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  )
                                                : Image.asset(
                                                    'assets/newsPlace.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                            }
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: size.height * .1),
                            child: Column(
                              children: articlesColumn,
                            ),
                          );
                          // return Container(
                          //   height: 300,
                          //   child: ListView.builder(
                          //     itemBuilder: (context, index) {
                          //       return Container(
                          //         child: article(
                          //             'http://192.168.43.250:8000/uploads/photos/' +
                          //                 articles[index].photo,
                          //             '',
                          //             articles[index].title,
                          //             '${articles[index].user.firstName} ${articles[index].user.lastName}',
                          //             '',
                          //             size),
                          //       );
                          //     },
                          //     itemCount: articles.length,
                          //   ),
                          // );
                        }
                      } catch (e) {
                        print(e);
                        return Center(
                            child: Container(
                          width: 100,
                          height: 200,
                          child: Text('error'),
                        ));
                      }
                    }),
                  ),
                  Column(
                    children: [],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, Size size) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'ضف خبر عاجل',
              textDirection: TextDirection.rtl,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: size.width * .3,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب ادخال  الخبر';
                        }
                        return null;
                      },
                      controller: breakingHeadlineController,
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          // valueText = value;
                        });
                      },
                      textAlign: TextAlign.right,

                      // controller: _textFieldController,
                      decoration: InputDecoration(
                        hintText: "...إكتب هنا",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    child: DigitalClock(
                      hourMinuteDigitTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      secondDigitTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      digitAnimationStyle: Curves.elasticOut,
                      is24HourTimeFormat: false,
                      areaDecoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 102, 116, 130),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text('إلغاء'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 102, 116, 130),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text('موافق'),
                onPressed: () async {
                  CustomProgressDialog progressDialog =
                      CustomProgressDialog(context, blur: 10);

                  if (_formKey.currentState!.validate()) {
                    progressDialog.show();
                    try {
                      Provider.of<ArticlePrvider>(context, listen: false)
                          .articleType = 'breaking';

                      String res = await Provider.of<ArticlePrvider>(context,
                              listen: false)
                          .breakingNews(breakingHeadlineController!.text);
                      progressDialog.dismiss();
                      if (res == 'success') {
                        progressDialog.dismiss();

                        await showAlertDialog(
                            context, 'تم الإرسال بنجاح', "نجحت العملية");
                      } else {
                        progressDialog.dismiss();

                        await showAlertDialog(context, '${res}', "fuck");
                      }
                    } catch (e) {
                      progressDialog.dismiss();

                      await showAlertDialog(
                          context, 'جاططت لمن ماف طريقة', "fuck");
                    }
                  }
                },
              ),
            ],
          );
        });
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

  Future<void> changeUserDesDialog(BuildContext context, Size size) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'إكتب نبذة عنك',
              textDirection: TextDirection.rtl,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: size.width * .3,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب ادخال الوصف';
                        }
                        return null;
                      },
                      controller: descriptionC,
                      textAlign: TextAlign.right,
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          // valueText = value;
                        });
                      },
                      // controller: _textFieldController,
                      decoration: InputDecoration(
                        hintText: "...إكتب هنا",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('إلغاء'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('موافق'),
                onPressed: () async {
                  CustomProgressDialog progressDialog =
                      CustomProgressDialog(context, blur: 10);

                  if (_formKey.currentState!.validate()) {
                    progressDialog.show();
                    try {
                      String res = await Provider.of<AuthProvider>(context,
                              listen: false)
                          .updateUserDes(descriptionC!.text);
                      if (res == 'success') {
                        setState(() {});
                        progressDialog.dismiss();
                        await showAlertDialog(
                            context, 'تم تغير الوصف   ', "نجحت العملية");
                      } else {
                        progressDialog.dismiss();

                        await showAlertDialog(context, '${res}', "fuck");
                      }
                    } catch (e) {
                      progressDialog.dismiss();

                      await showAlertDialog(
                          context, 'جاططت لمن ماف طريقة', "fuck");
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  getArticle() async {
    var user = Provider.of<AuthProvider>(context, listen: false).user;

    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getJournlistArticles(user!.id!, token);
    if (res == 'success') {
      articles =
          Provider.of<ArticlePrvider>(context, listen: false).journlistArticles;
      print(articles);
      setState(() {});
    }
  }
}
