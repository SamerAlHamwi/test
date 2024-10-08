




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
  int time2 = 0;

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
        title: const Text('اختر وقت الحرق'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => decrement(time),
                ),
                Text(
                  time.toString(),
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => increment(time),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => decrement(time2),
                ),
                Text(
                  time2.toString(),
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => increment(time2),
                ),
              ],
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



