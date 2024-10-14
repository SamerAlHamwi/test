

import 'package:flutter/material.dart';
import 'package:king/screens/settings/settings.dart';
import '../../utils/utils.dart';
import '../work/auto2_screen.dart';
import '../work/auto_work.dart';
import '../work/countdown_work.dart';

class SelectCountDownTimeScreen extends StatefulWidget {
  const SelectCountDownTimeScreen({super.key});

  @override
  State<SelectCountDownTimeScreen> createState() => _SelectCountDownTimeScreenState();
}

class _SelectCountDownTimeScreenState extends State<SelectCountDownTimeScreen> {

  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int time = 0;

  @override
  void initState() {
    super.initState();
    initTime();
  }

  void increment() {
    setState(() {
      time = (time + 1) % 60;
      controller.text = time.toString();
    });
  }

  void decrement() {
    setState(() {
      time = (time - 1) < 0 ? 59 : time - 1;
      controller.text = time.toString();
    });
  }

  initTime(){
    if(SettingsData.getCountDownTime() != 0){
      time = SettingsData.getCountDownTime();
    }
    controller.text = time.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر ثانية الحرق'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => decrement(),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      validator: Utils.validateTime,
                      onChanged: (value) {
                        setState(() {
                          int? newTime = int.tryParse(value);
                          if (newTime != null && newTime >= 0 && newTime <= 59) {
                            time = newTime;
                          } else {
                            controller.text = time.toString();
                          }
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => increment(),
                  ),
                ],
              ),
              const SizedBox(height: 10,),

              ElevatedButton(
                onPressed: () async {
                  if(formKey.currentState!.validate()){
                    SettingsData.setCountDownTime(time);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const CountDownScreen()));
                  }
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



