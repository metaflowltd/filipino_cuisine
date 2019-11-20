import 'package:flutter/material.dart';

class Preloader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      );
}
