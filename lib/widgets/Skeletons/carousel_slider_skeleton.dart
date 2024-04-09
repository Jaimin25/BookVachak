import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HeroCarouselSkeleton extends StatelessWidget {
  const HeroCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
