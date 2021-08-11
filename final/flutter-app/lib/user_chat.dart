import 'package:flutter/material.dart';

class UserChat extends StatelessWidget {
  final String txt;

  const UserChat(this.txt, {Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(color: Colors.lightGreen[100]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "User",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Text(txt)
                  ],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text("U")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
