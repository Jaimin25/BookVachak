import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/screens/audio_tracks_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class BooksList extends StatefulWidget {
  final List<BooksModal>? bookList;

  const BooksList({
    super.key,
    required this.bookList,
  });

  @override
  State<BooksList> createState() => _BooksGridViewState();
}

class _BooksGridViewState extends State<BooksList> {
  BooksModal getBook(index) {
    BooksModal book = widget.bookList![index];
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
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioTracksScreen(
                  book: getBook(index + 4),
                ),
              ),
            ),
            child: Card(
              surfaceTintColor: Colors.white,
              elevation: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: getBook(index + 4).coverMediaUrl as String,
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
        },
      ),
    );
  }
}
