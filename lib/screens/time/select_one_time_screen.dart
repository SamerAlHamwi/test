




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

  int second1 = 0;
  int milli1 = 100;

  int second2 = 0;
  int milli2 = 100;

  int second3 = 0;
  int milli3 = 100;

  @override
  void initState() {
    super.initState();
    initTime();
  }

  initTime(){
    if(SettingsData.getTime1() != 0){
      second1 = SettingsData.getTime1();
      milli1 = SettingsData.getMilli1();
    }
    if(SettingsData.getTime2() != 0){
      second2 = SettingsData.getTime2();
      milli2 = SettingsData.getMilli2();
    }
    if(SettingsData.getTime3() != 0){
      second3 = SettingsData.getTime3();
      milli3 = SettingsData.getMilli3();
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
            getSetTimeWidget(
              second: second1,
              milli: milli1,
              updateSecond: (newSecond) => second1 = newSecond,
              updateMilli: (newMilli) => milli1 = newMilli,
            ),
            const SizedBox(height: 10),
            getSetTimeWidget(
              second: second2,
              milli: milli2,
              updateSecond: (newSecond) => second2 = newSecond,
              updateMilli: (newMilli) => milli2 = newMilli,
            ),
            const SizedBox(height: 10),
            getSetTimeWidget(
              second: second3,
              milli: milli3,
              updateSecond: (newSecond) => second3 = newSecond,
              updateMilli: (newMilli) => milli3 = newMilli,
            ),
            const SizedBox(height: 10),
            const Text(
                'سيقوم الكود بالضغط على كل المعاملات بدءاً من جزء الكبسة وبزيادة جزئين لكل حساب',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () async {
                SettingsData.setTime1(second1);
                SettingsData.setTime2(second2);
                SettingsData.setTime3(second3);
                SettingsData.setMilli1(milli1);
                SettingsData.setMilli2(milli2);
                SettingsData.setMilli3(milli3);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AutoWorkScreen2()));
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }


  getSetTimeWidget({
    required int second,
    required int milli,
    required void Function(int) updateSecond,
    required void Function(int) updateMilli,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('اختر ثانية الكبسة'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (second > 0) {
                    updateSecond(second - 1);
                  }
                });
              },
            ),
            Text(
              second.toString(),
              style: const TextStyle(fontSize: 24),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  if (second < 60) {
                    updateSecond(second + 1);
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text('اختر جزء الكبسة'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (milli > 200) {
                    updateMilli(milli - 100);
                  }
                });
              },
            ),
            Text(
              milli.toString(),
              style: const TextStyle(fontSize: 24),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  if (milli < 900) {
                    updateMilli(milli + 100);
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

}



