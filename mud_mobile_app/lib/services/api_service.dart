import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mud_mobile_app/models/api_models.dart';
import 'package:mud_mobile_app/services/auth_service.dart';

class ApiService {
  static final initialurl = "http://34.84.147.192:8000/news/";

  static Future<List<Clusters>> getRecommends() async {
    List<Recommends> recommends = List();
    FirebaseUser user = await AuthService.getCurrentUser();
    final response = await http.get(
      Uri.encodeFull(initialurl + "recommend/?format=json&user_id=" + user.uid), 
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 200) {     
      recommends = (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => new Recommends.fromJson(data))
          .toList();
      if (recommends.length == 0){
        return null;
      }
      return getClustersByRecommends(recommends);
    } else {
      return null;
    }
  }

  static Future<List<Clusters>> getClustersByRecommends(recommendsList) async {
    List<Clusters> clusters = List();
    for (var i = 0; i < recommendsList.length; i++){
      final response = await http.get(
        Uri.encodeFull(initialurl + "clusters/?format=json&cluster_id=" + recommendsList[i].clusterId), 
        headers: {"Accept" : "application/json"}
      );
      if (response.statusCode == 200) {     
        List<Clusters> cluster = (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => new Clusters.fromJson(data))
          .toList();
        clusters.add(cluster[0]);
      } 
    }
    return clusters;
  }

  static Future<ArticlePagination> getArticles(nextUrl) async {
    var url = initialurl + "articles/?format=json&limit=10";
    if (nextUrl != null) {
      url = nextUrl;
    }
    ArticlePagination articles;
    final response = await http.get(
      Uri.encodeFull(url), 
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 200) {
      articles = ArticlePagination.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if (articles.results.length == 0){
        return null;
      }
      return articles;
    } else {
      return null;
    }
  }

  static Future<ArticlePagination> getArticlesByCategory(category) async {
    ArticlePagination articles;
    final response = await http.get(
      Uri.encodeFull(initialurl + "articles/?format=json&limit=100&category=" + category), 
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 200) {
      articles = ArticlePagination.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if (articles.results.length == 0){
        return null;
      }
      return articles;
    } else {
      return null;
    }
  }

  static Future getAllClusters() async {
    List<Clusters> clusters = List();
    final response = await http.get(
      Uri.encodeFull(initialurl + "clusters/?format=json"), 
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 200) {     
      clusters = (json.decode(utf8.decode(response.bodyBytes)) as List)
        .map((data) => new Clusters.fromJson(data))
        .toList();
    } else {
      Clusters error = Clusters();
      error.clusterId = "Status Code : " + response.statusCode.toString();
      error.clusterHeadline = "Error Loading Data";
      error.clusterSummary = "News may have deleted from database";
      clusters.add(error);
    }
    return clusters;
  }

  static Future creatUser(uid) async {
    var jsonData = {"user_id" : uid};
    final response = await http.post(
      Uri.encodeFull(initialurl + "users/"), 
      body: jsonData,
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 201){
      print("User Create Success!");
    }
  }

  static Future<List<UserRating>> getUserRating() async {
    List<UserRating> userRating = List();
    FirebaseUser user = await AuthService.getCurrentUser();
    final response = await http.get(
      Uri.encodeFull(initialurl + "rating/?format=json&user_id=" + user.uid), 
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 200) {     
      userRating = (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => new UserRating.fromJson(data))
          .toList();
      if (userRating.length == 0){
        return null;
      }
      return userRating;
    } else {
      return null;
    }
  }

  static Future<List<AllUserBookmarks>> getBookmarksByUser() async {
    List<Bookmarks> bookmarks = List();
    FirebaseUser user = await AuthService.getCurrentUser();
    final response = await http.get(
      Uri.encodeFull(initialurl + "bookmarks/?format=json&user_id=" + user.uid), 
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 200) {     
      bookmarks = (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => new Bookmarks.fromJson(data))
          .toList();
      if (bookmarks.length == 0){
        return null;
      }
      return getBookmarks(bookmarks);
    } else {
      return null;
    }
  }

  static Future<List<AllUserBookmarks>> getBookmarks(bookmarks) async {
    List<AllUserBookmarks> allUserBookmarks = List();
    for (var i = 0; i < bookmarks.length; i++){
      final response = await http.get(
        Uri.encodeFull(initialurl + "allbookmarks/?format=json&allUserFavorite_id=" + bookmarks[i].allUserFavId), 
        headers: {"Accept" : "application/json"}
      );
      if (response.statusCode == 200) {     
        List<AllUserBookmarks> allUserBookmark = (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => new AllUserBookmarks.fromJson(data))
          .toList();
        allUserBookmarks.add(allUserBookmark[0]);
      } 
    }
    return allUserBookmarks;
  }

  static Future creatBookmark(newsId, headline, summary) async {
    AllUserBookmarks bookmark;
    var jsonData = {
        "headline": headline,
        "summary": summary,
        "news_id": newsId,
    };
    final response = await http.post(
      Uri.encodeFull(initialurl + "allbookmarks/"), 
      body: jsonData,
      headers: {"Accept" : "application/json"}
    );
    if (response.statusCode == 201){
      bookmark = AllUserBookmarks.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      FirebaseUser user = await AuthService.getCurrentUser();
      jsonData = {
        "user_id": user.uid,
        "allUserFav_id": bookmark.allUserFavoriteId,
      };
      final responseTwo = await http.post(
        Uri.encodeFull(initialurl + "bookmarks/"), 
        body: jsonData,
        headers: {"Accept" : "application/json"}
      );
      if (responseTwo.statusCode == 201){
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

}