import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class AudioTrackSkeleton extends StatelessWidget {
  const AudioTrackSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Skeleton(
            isLoading: true,
            skeleton: SkeletonListTile(
              hasLeading: false,
              hasSubtitle: true,
            ),
            child: const ListTile(),
          );
        });
  }
}
