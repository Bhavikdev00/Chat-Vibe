import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShemmerContainer extends StatelessWidget {
  const ShemmerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            baseColor: Colors.black12,
            highlightColor: Colors.grey.shade800,
            period: Duration(seconds: 5),
            child: Row(children: [
              const CircleAvatar(radius: 30),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(7)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(7)),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
