
import 'package:flutter/material.dart';
import 'package:my_book_app/presentation/image_view_screen.dart';
import 'package:my_book_app/provider/book_provider.dart';
import 'package:provider/provider.dart';
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
          title: const Text("Detail")
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) => Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),

            child: bookProvider!.detailBook == null ?
            const Center(child: CircularProgressIndicator())
                :
            Column(children: [
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
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              bookProvider!.detailBook!.authors!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: Text(
                              bookProvider!.detailBook!.subtitle!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  children: List.generate(
                                      5,
                                          (index) => Icon(
                                        Icons.star,
                                        color: index < int.parse(bookProvider!.detailBook!.rating!) ? Colors.yellow : Colors.grey,
                                      )
                                  )
                              ),
                              Text(
                                bookProvider!.detailBook!.price!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        try{
                          // final check = await canLaunchUrlString(bookProvider!.detailBook!.url!);
                          //  check ?
                          launchUrlString(bookProvider!.detailBook!.url!) ;
                          // launchUrlString(bookProvider!.detailBook!.url!) :
                          // launchUrlString(bookProvider!.detailBook!.url!);
                          // print("Tidak berhasil navigasi ${check} ${bookProvider!.detailBook!.url!}");
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
              const SizedBox(height: 10),
              const Divider(height: 8),
              const SizedBox(height: 10),
              const Text(
                "Similar Books",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              ),
              if (bookProvider!.similarBooks! == null) const CircularProgressIndicator() else Container(
                height: 180,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: bookProvider!.similarBooks!.books!.length,
                    itemBuilder: (context, index) {
                      final current = bookProvider!.similarBooks!.books![index];
                      return Container(
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
                      );
                    }
                ),
              )
            ],
            ),
          ),
        ),

      ),
    );
  }
}
