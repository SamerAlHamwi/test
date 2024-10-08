

import 'package:flutter/material.dart';
import 'dart:async';

final StreamController<List<String>> messageController = StreamController();

class MessageStreamWidget extends StatefulWidget {
  const MessageStreamWidget({super.key});

  @override
  _MessageStreamWidgetState createState() => _MessageStreamWidgetState();
}

class _MessageStreamWidgetState extends State<MessageStreamWidget> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: StreamBuilder<List<String>>(
          stream: messageController.stream,
          initialData: [], // Initial empty data
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox();
            }
            final messages = snapshot.data!;

            return ListView(
              reverse: true,
              children: List.generate(messages.length, (index) => Text(
                messages[index],
                style: TextStyle(
                  fontSize: 12,
                  color: messages[index].contains('تم')
                      ? Colors.green
                      : messages[index].contains('Get')
                      ? Colors.blue
                      : messages[index].contains('Request')
                      ? Colors.black
                      : Colors.red,
                ),
              )),
            );
          },
        ),
      ),
    );
  }
}
