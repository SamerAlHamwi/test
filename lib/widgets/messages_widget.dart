

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:king/utils/messages_utils.dart';

StreamController<List<String>> messageController = StreamController<List<String>>.broadcast();


class MessageStreamWidget extends StatefulWidget {
  const MessageStreamWidget({super.key});

  @override
  _MessageStreamWidgetState createState() => _MessageStreamWidgetState();
}

class _MessageStreamWidgetState extends State<MessageStreamWidget> {


  @override
  void initState() {
    super.initState();
    resetMessages();
  }

  resetMessages(){
    messageController = StreamController<List<String>>.broadcast();
    messages = [];
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
          initialData: const [],
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
                  color: getTextColor(messages,index)
                ),
              )),
            );
          },
        ),
      ),
    );
  }

  getTextColor(List messages,int index){
    if(messages[index].contains('تم')){
      return Colors.green;
    }else if(messages[index].contains('Get')){
      return Colors.blue;
    }else if(messages[index].contains('Request')){
      return Colors.black;
    }else if(messages[index].contains('حدث')){
      return Colors.grey;
    }else{
      return Colors.red;
    }
  }
}
