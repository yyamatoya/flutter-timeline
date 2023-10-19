import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:post_app/helpers/local_data_helper.dart';
import 'package:post_app/models/post_model.dart';

import '../models/user_model.dart';

class ApiHelper {
  // エンドポイント
  final String domain = "http://10.0.2.2:8080";
  // 各種エンドポイント
  final String postPostEndPoint = "/api/post";

  // タイムアウト時間
  final Duration apiTimeOut = const Duration(seconds: 10);
  // デフォルトHTTPHeaders
  final Map<String, String> defaultHttpHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  var logger = Logger();

  Future<User?> login(
      {required String loginId, required String password}) async {
    try {
      final Response res = await http
          .post(Uri.parse('$domain/api/login'),
              headers: defaultHttpHeaders,
              body: jsonEncode({'login_id': loginId, 'password': password}))
          .timeout(apiTimeOut);

      if (res.statusCode == 200) {
        logger.d("Login successful");
        dynamic body = jsonDecode(res.body);
        LocalDataHelper.setUserToken = body['token'];
        logger.d(body);
        return User.fromJson(body);
      }
      return null;
    } catch (error) {
      logger.d(error.toString());
      rethrow;
    }
  }

  Future<List<Post>> getPosts() async {
    final Map<String, String> headers = await getAuthHeaders();
    try {
      return await http
          .get(Uri.parse(domain + postPostEndPoint), headers: headers)
          .timeout(apiTimeOut)
          .then((Response response) {
        if (response.statusCode == 200) {
          logger.d("getPosts successful");
          List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
          return body.map((e) => Post.fromJson(e)).toList();
        }
        return throw Error();
      }).catchError((error) {
        logger.e(error.toString());
        throw error;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<Post> getDetailPost(int id) async {
    final Map<String, String> headers = await getAuthHeaders();
    try {
      return await http
          .get(Uri.parse('$domain$postPostEndPoint/$id'), headers: headers)
          .timeout(apiTimeOut)
          .then((Response response) {
        if (response.statusCode == 200) {
          logger.d("getDetailPost successful id=$id");
          Map<String, dynamic> body = jsonDecode(response.body);
          return Post.fromJson(body);
        }
        throw Exception(response.statusCode);
      }).catchError((error) {
        logger.e(error.toString());
        throw error;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> postReply(Post post, User usr, String reply) async {
    final Map<String, String> headers = await getAuthHeaders();

    Object jsonObj = {
      'description': reply,
      'input_user_id': usr.id,
      'parent_post_id': post.id,
      'reply_flag': 1,
      // 日時
      'created_at': DateFormat('y-M-d H:m:s').format(DateTime.now()),
      'updated_at': DateFormat('y-M-d H:m:s').format(DateTime.now()),
      // 作成者
      'updated_by': usr.name,
    };
    try {
      final Response res = await http
          .post(Uri.parse(domain + postPostEndPoint),
              headers: headers, body: jsonEncode(jsonObj))
          .timeout(apiTimeOut);

      return res.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<int?> pushNice(Post post) async {
    final Map<String, String> headers = await getAuthHeaders();
    try {
      final Response res = await http
          .post(Uri.parse('$domain$postPostEndPoint/${post.id}/nice'),
              headers: headers)
          .timeout(apiTimeOut);
      logger.d("nice ${res.body}");
      dynamic body = jsonDecode(res.body);
      return body['nices'];
    } catch (error) {
      return null;
    }
  }

  Future<Map<String, String>> getAuthHeaders() async {
    try {
      if (LocalDataHelper.userToken == null) throw Error();
      return {
        'Authorization': 'Bearer ${LocalDataHelper.userToken}',
      };
    } catch (error) {
      rethrow;
    }
  }
}
