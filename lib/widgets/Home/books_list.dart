import 'package:bookvachak/modals/books_modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class BooksList extends StatefulWidget {
  final List<Future<BooksModal>>? bookList;

  const BooksList({super.key, required this.bookList});

  @override
  State<BooksList> createState() => _BooksGridViewState();
}

class _BooksGridViewState extends State<BooksList> {
  Future<BooksModal> getBook(index) async {
    Future<BooksModal> bookFuture = widget.bookList![index];
    BooksModal book = await bookFuture;
    return book;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18.0,
            crossAxisSpacing: 18.0,
          ),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: getBook(index + 4),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onTap: () => (),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      elevation: 4.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.coverMediaUrl as String,
                          placeholder: (context, url) {
                            return const SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 220.0,
                                height: 220.0,
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Card(
                    surfaceTintColor: Colors.white,
                    elevation: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: const SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 220.0,
                          height: 220.0,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }),
    );
  }
}
