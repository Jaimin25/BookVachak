import 'package:bookvachak/widgets/Skeletons/books_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Card(
                    surfaceTintColor: Colors.white,
                    elevation: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: const SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          height: 200,
                          width: 200,
                          maxHeight: 200,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1, 2, 3].asMap().entries.map((entry) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.orange)
                            .withOpacity(0 == entry.key ? 0.9 : 0.4)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 4,
          child: Center(
            child: BooksListSkeleton(),
          ),
        ),
      ],
    );
  }
}
