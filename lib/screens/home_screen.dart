import 'package:bookvachak/helpers/librovox_books_provider.dart';
import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/widgets/Home/books_list.dart';
import 'package:bookvachak/widgets/Home/hero_carousel_slider.dart';
import 'package:bookvachak/widgets/Skeletons/home_screen_skeleton.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Future<BooksModal>>? bookList;

  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      isFetching = true;
    });
    LibrovoxBooksProvider lbp = LibrovoxBooksProvider();
    List<Future<BooksModal>> asyncbookList = await lbp.fetchBooks();

    setState(() {
      bookList = asyncbookList;
      isFetching = false;
    });
  }

  Future<BooksModal> getBook(index) async {
    Future<BooksModal> bookFuture = bookList![index];
    BooksModal book = await bookFuture;
    return book;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: !isFetching
          ? Column(
              children: [
                Expanded(
                  flex: 3,
                  child: HeroCarouselSlider(
                    getBook: getBook,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: BooksList(
                      bookList: bookList,
                    ),
                  ),
                ),
              ],
            )
          : const HomeScreenSkeleton(),
    );
  }
}
