import 'package:flutter/material.dart';

class UsedImages extends StatefulWidget {
  const UsedImages({
    Key? key,
  }) : super(key: key);

  @override
  _UsedImagesState createState() => _UsedImagesState();
}

class _UsedImagesState extends State<UsedImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Kullanılan resimler"),
    );
  }
}
