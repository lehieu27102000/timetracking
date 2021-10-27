import 'package:flutter/material.dart';
class EmptyContent extends StatelessWidget {
  final String title;
  final String messege;

  const EmptyContent({Key? key, this.title = 'Nothing here', this.messege = 'Add a new to get started'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 32, color: Colors.black54),
            ),
            Text(
              messege,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            )
          ],
        )
    );
  }
}
