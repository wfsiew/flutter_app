// ignore_for_file: file_names

import 'package:flutter_app/models/comments.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/services/api-helper.dart';

Future<List<Post>> getAllPost() async {
  List<Post> lx = [];

  try {
    var res = await ApiHelper.dio.get('https://jsonplaceholder.typicode.com/posts');
    var ls = res.data as List? ?? [];
    lx = ls.map((x) => Post.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<Post> getPost(num postId) async {
  Post? o;

  try {
    var res = await ApiHelper.dio.get('https://jsonplaceholder.typicode.com/posts/$postId');
    o = Post.fromJson(res.data);
  }

  catch (error) {
    rethrow;
  }

  return o;
}

Future<List<Comments>> getCommentsFromPost(num postId) async {
  List<Comments> lx = [];

  try {
    var res = await ApiHelper.dio.get('https://jsonplaceholder.typicode.com/comments?postId=$postId');
    var ls = res.data as List? ?? [];
    lx = ls.map((x) => Comments.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}