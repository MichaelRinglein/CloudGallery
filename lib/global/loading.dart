import 'package:cloudgallery/global/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final String? loadingText;
  const Loading({Key? key, this.loadingText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Center(
        child: Column(
          children: [
            const SpinKitRing(
              color: Colors.blue,
              size: 50.0,
            ),
            const SizedBox(
              height: heightSizedBox,
            ),
            Text(loadingText!)
          ],
        ),
      ),
    );
  }
}
