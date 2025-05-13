import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const Loader({
    Key? key,
    this.width = 100,
    this.height = 100,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/loading.gif',
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
