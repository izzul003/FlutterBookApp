
import 'package:flutter/material.dart';
import 'package:my_book_app/presentation/detail_book_page.dart';
import 'package:my_book_app/provider/book_provider.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookProvider? bookProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider!.fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Catalogue"),
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) => Container(
          child: bookProvider!.bookList == null ?
          Center(child: CircularProgressIndicator())
          :
          ListView.builder(
              itemCount: bookProvider!.bookList!.books!.length,
              itemBuilder: (context, index) {
                final currentBook = bookProvider!.bookList!.books![index];
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailBookPage(
                      isbn: currentBook.isbn13!,
                    )));
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.network(
                            currentBook.image!,
                            height: 100,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currentBook.title!),
                                  Text(currentBook.subtitle!),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(currentBook.price!),
                                  )
                                ],
                              )
                            )
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
