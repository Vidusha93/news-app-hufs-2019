import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mud_mobile_app/models/Conection_error.dart';
import 'package:mud_mobile_app/models/api_models.dart';
import 'package:mud_mobile_app/models/button_models.dart';
import 'package:mud_mobile_app/services/api_service.dart';
import 'package:mud_mobile_app/services/tts_service.dart';
import 'package:mud_mobile_app/utilities/constants.dart';
import 'dart:async';
import 'package:mud_mobile_app/utilities/fade_in_animation.dart';
import 'package:mud_mobile_app/utilities/shape_paint.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool isSwitched = false;
  List<Clusters> clusters;
  ArticlePagination articlePagination;
  ScrollController _scrollController = ScrollController();

  Future getData() async {
    return await ApiService.getRecommends();
  }

  Future getArticles(nextUrl) async {
    return await ApiService.getArticles(nextUrl);
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double devHeight = MediaQuery.of(context).size.height;
    final double devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                CustomPaint(
                  painter: Chevron(),
                  child: Container(
                    height: devHeight * 0.2,
                    width: devWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            color: Colors.transparent,
                            icon: Icon(Icons.arrow_back_ios, size: 36,),
                            onPressed: (){},
                          ),
                          Text('Today\'s News', style: kTitleStyleMain,),
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.search, size: 36,),
                            onPressed: (){},
                          ),
                        ],
                      ),
                    )
                  ),
                )
              ],
            ),
            Container(
              child: TtsService(),
            ),
            Flexible(
              child: FadeIn(1.6, FutureBuilder(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Container(
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return Container(
                      child: ErrorDisplay(errorDisplay: 'Opps Somthing is not okay!',),
                    );
                  }
                  clusters = snapshot.data;
                  return ListView.builder(
                    itemCount: clusters.length,
                    itemBuilder: (BuildContext contex, int index){
                      return Container(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Color(0xFF398AE5),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  clusters[index].clusterHeadline == null ? 'Headline' : clusters[index].clusterHeadline,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Text(
                                  clusters[index].clusterSummary == null ? 'Summary' : clusters[index].clusterSummary,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Text(
                                  clusters[index].clusterId == null ? 'ID' : clusters[index].clusterId,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  color: Color(0xFF398AE5)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RaisedGradientButton(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Icon(Icons.bookmark, color: Colors.white,),
                                          Text('Bookmark', style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                      onPressed: (){},
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF398AE5),
                                          Color(0xFF73AEF5),
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight
                                      ),
                                    ),
                                    RaisedGradientButton(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Icon(Icons.chrome_reader_mode, color: Colors.white,),
                                          Text('Read More', style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                      onPressed: (){},
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF398AE5),
                                          Color(0xFF73AEF5),
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                      );
                    },
                  );
                },
              )),
            ),
            Flexible(
              child: FutureBuilder(
                future: getArticles(null),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Container(
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return Container(
                      child: ErrorDisplay(errorDisplay: 'Opps Somthing is not okay!',),
                    );
                  }
                  articlePagination = snapshot.data;
                  return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Text(articlePagination.results.length.toString()),
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}