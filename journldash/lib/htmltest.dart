import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:journldash/Provider/articleProvider.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

import 'models/Article.dart';

class ArticleScreen extends StatefulWidget {
  ArticleModel articleModel;
  ArticleScreen(this.articleModel);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Timer? _timer;
  //you can choose between the two
  dom.Document document = dom.Document();
  String? thehtml;

  _AnimatedFlutterLogoState() {
    _timer = new Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        getArticle();
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }
  @override
  void initState() {
    _AnimatedFlutterLogoState();
    // TODO: implement initState
    super.initState();

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
          // SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
          
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            forceElevated: true,
            shadowColor: Colors.black,
            elevation: 2,
            centerTitle: true,
            title: Text(
              'الجريدة',
              style: TextStyle(
              
                fontSize:40
              ),
            ),
            pinned: false,
            snap: false,
            automaticallyImplyLeading: true,
            floating: false,
            expandedHeight: height * .50,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Column(
                children: [
                  SizedBox(
                    height: height * .1,
                  ),
                  Container(
                      height: height * .2,
                      width: height * .2,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Colors.black
,                        child: Container(
                           height: height * .195,
                      width: height * .195,
                          child: CircleAvatar(
                            radius: 60,
                            // backgroundImage: widget.articleModel.user.photo!='no_image.jpg'? NetworkImage(
                            //     'http://192.168.43.251:8000/uploads/photos/' +
                            //         widget.articleModel.user.photo) :AssetImage('assets/profilePlace.png')
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: height * .01),
                    child: Center(
                      child: Container(
                          width: width * .5,
                          child: Text(
                            '${widget.articleModel.user!.firstName} ${widget.articleModel.user!.lastName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .005,
                  ),
                  Center(
                    child: Container(
                        width: width * .5,
                        child: Text(
                          '${widget.articleModel.user!.email}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  Text(
                    '${widget.articleModel.createdAt.toString().substring(0, 11)}',
                    style: TextStyle(
                      fontSize:16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: SliverToBoxAdapter(
              
                child: thehtml != null
                    ? Container(
                        child: SingleChildScrollView(
                          child: Consumer<ArticlePrvider>(
                              builder: (context, articleProv, _) {
                            // thehtml=articleProv.article.description;
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                    child:Padding(
                                      padding:  EdgeInsets.fromLTRB(width*.05, width*.05, width*.05, width*.05,),
                                      child: Html(
                                        
                                        shrinkWrap: true,
                                        data: thehtml,  style: {
                                      "p": Style(
                                                                     
                                          textAlign: TextAlign.justify,
                                          direction: TextDirection.rtl),
                                              "br": Style(
                              display: Display.block,
                              // margin: EdgeInsets.fromLTRB(0, -size.height*.007, 0, -size.height*.007)
                                                                     
                                        ),
                                          "*":Style(
                                                                                  // lineHeight: LineHeight.em(1.5),
                              
                                               color: Colors.black,
                                            fontFamily: 'Almari'
                                          )
                                                                    },),
                                    )
                                    ),
                              ),
                            );
                          }),
                        ),
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Container(
                         
                          child:CircularProgressIndicator()
                        ),
                      ))),
          ),
        ]),
      ),
    );
  }

  getArticle() async {
    String res = await Provider.of<ArticlePrvider>(context, listen: false)
        .getHtml(widget.articleModel);
    if (res == 'success') {
      thehtml =
          Provider.of<ArticlePrvider>(context, listen: false).articleHtmlText;
      document = htmlparser.parse(thehtml);
      setState(() {});
      print(document);
    }
  }
}
