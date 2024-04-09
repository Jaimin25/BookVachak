import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class BooksListSkeleton extends StatelessWidget {
  const BooksListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18.0,
          crossAxisSpacing: 18.0,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
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
        },
      ),
    );
  }
}
