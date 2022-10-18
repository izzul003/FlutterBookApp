import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_book_app/model/list_book_response.dart';
import 'package:my_book_app/model/detail_book_response.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookProvider extends ChangeNotifier {
  ListBookResponse ? bookList;
  DetailBookResponse ? detailBook;
  ListBookResponse ? similarBooks;

  fetchBookApi() async{
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = ListBookResponse.fromJson(jsonBookList);
      notifyListeners();
    }
  }

  fetchDetailBookApi(String isbn) async{
    var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = DetailBookResponse.fromJson(jsonDetail);
      fetchSimilarBookApi(detailBook!.title!);
      notifyListeners();
    }
  }

  fetchSimilarBookApi(String title) async{
    var url = Uri.parse('https://api.itbook.store/1.0/search/$title');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonSimilar = jsonDecode(response.body);
      similarBooks = ListBookResponse.fromJson(jsonSimilar);
      notifyListeners();
    }
    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

}