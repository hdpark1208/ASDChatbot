import 'package:flutter/material.dart';

class BotChat extends StatelessWidget {
  final String txt;

  const BotChat(this.txt, {Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(color: Colors.lightGreen[300]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text("B")
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bot",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Text(txt)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
