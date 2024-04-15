import 'package:bookvachak/modals/books_modal.dart';
import 'package:bookvachak/screens/audio_tracks_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HeroCarouselSlider extends StatefulWidget {
  final BooksModal Function(dynamic) getBook;
  const HeroCarouselSlider({super.key, required this.getBook});

  @override
  State<HeroCarouselSlider> createState() => _HeroCarouselSliderState();
}

class _HeroCarouselSliderState extends State<HeroCarouselSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
              itemCount: 4,
              options: CarouselOptions(
                autoPlay: true,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioTracksScreen(
                        book: widget.getBook(index),
                      ),
                    ),
                  ),
                  child: Card(
                    elevation: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.getBook(index).coverMediaUrl as String,
                        placeholder: (context, url) {
                          return const SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                width: 200.0, height: 200.0),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
              // }
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [0, 1, 2, 3].asMap().entries.map((entry) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.orange)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
