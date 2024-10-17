




import 'package:flutter/material.dart';
import 'package:king/screens/settings/settings.dart';
import '../work/auto2_screen.dart';
import '../work/auto_work.dart';

class SelectOneTimeScreen extends StatefulWidget {
  const SelectOneTimeScreen({super.key});

  @override
  State<SelectOneTimeScreen> createState() => _SelectOneTimeScreenState();
}

class _SelectOneTimeScreenState extends State<SelectOneTimeScreen> {

  int time = 0;
  int time2 = 100;

  @override
  void initState() {
    super.initState();
    initTime();
  }

  initTime(){
    if(SettingsData.getTime() != 0){
      time = SettingsData.getTime();
      time2 = SettingsData.getTime2();
    }
  }

  void increment(int value) {
    setState(() {
      if (value < 60) {
        value++;
      }
    });
  }

  void decrement(int value) {
    setState(() {
      if (value > 0) {
        value--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحرق'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //////////////
            const Text('اختر ثانية الكبسة'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: (){
                    setState(() {
                      if (time > 0) {
                        time--;
                      }
                    });
                  },
                ),
                Text(
                  time.toString(),
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (){
                    setState(() {
                      if (time < 60) {
                        time++;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Text('اختر جزء الكبسة'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: (){
                    setState(() {
                      if (time2 > 199) {
                        time2 = time2 - 100;
                      }
                    });
                  },
                ),
                Text(
                  time2.toString(),
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (){
                    setState(() {
                      if (time2 < 900) {
                        time2 = time2 + 100;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const Text(
                'سيقوم الكود بالضغط على كل المعاملات بدءاً من جزء الكبسة وبزيادة جزئين لكل حساب',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () async {
                SettingsData.setTime(time);
                SettingsData.setTime2(time2);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AutoWorkScreen2()));
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }


}



