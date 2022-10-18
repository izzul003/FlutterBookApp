
import 'package:flutter/material.dart';
import 'package:my_book_app/model/detail_book_response.dart';
import 'package:my_book_app/presentation/image_view_screen.dart';
import 'package:my_book_app/provider/book_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn
  }) : super(key: key);
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {

  BookProvider? bookProvider;
  @override
  void initState() {
    super.initState();
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Detail")
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) =>
        bookProvider!.detailBook == null ?
        const Center(
          child: CircularProgressIndicator(),
        )
        :
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageViewScreen(
                              imageUrl: bookProvider!.detailBook!.image!
                          ),
                      ),
                    );
                  },
                  child: Image.network(
                    bookProvider!.detailBook!.image!,
                    height: 150,
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookProvider!.detailBook!.title!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              bookProvider!.detailBook!.authors!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            bookProvider!.detailBook!.subtitle!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bookProvider!.detailBook!.price!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Row(
                                children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      color: index < int.parse(bookProvider!.detailBook!.rating!) ? Colors.yellow : Colors.grey,
                                    )
                                )
                              )
                            ],
                          ),
                        ],
                      ),
                  ),
                ),
              ],
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: () async {
                  try{
                    (await canLaunchUrlString(bookProvider!.detailBook!.url!)) ?
                    launchUrlString(bookProvider!.detailBook!.url!) : print("Tidak berhasil navigasi");
                  } catch(e) {
                    print(e.toString());
                  }
                },
                child: const Text("BUY")
                )
            ),
            const SizedBox(height: 20),
            Text(bookProvider!.detailBook!.desc!),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Year : ${bookProvider!.detailBook!.year!}"),
                Text("ISBN ${bookProvider!.detailBook!.isbn13!}"),
                Text("${bookProvider!.detailBook!.pages!} Page"),
                Text("Publisher ${bookProvider!.detailBook!.publisher!}"),
                Text("Language : ${bookProvider!.detailBook!.language!}"),
              ],
            ),
            SizedBox(height: 10),
            Divider(height: 8),
            SizedBox(height: 10),
            const Text(
              "Similar Books",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
            if (bookProvider!.similarBooks! == null) const CircularProgressIndicator() else SizedBox(
                  height: 180,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: bookProvider!.similarBooks!.books!.length,
                    itemBuilder: (context, index) {
                      final current = bookProvider!.similarBooks!.books![index];
                      return Expanded(
                        child: SizedBox(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.network(
                                  current.image!,
                                  height: 100,
                                ),
                                Expanded(
                                    child: Text(
                                      current.title!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                )
          ],
          ),
        ),
      ),
    );
  }
}
