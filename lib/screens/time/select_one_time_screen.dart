




import 'package:flutter/material.dart';
import 'package:king/screens/settings/settings.dart';
import '../work/auto_work.dart';

class SelectAutoTimesScreen extends StatefulWidget {
  const SelectAutoTimesScreen({super.key});

  @override
  State<SelectAutoTimesScreen> createState() => _SelectAutoTimesScreenState();
}

class _SelectAutoTimesScreenState extends State<SelectAutoTimesScreen> {

  int time = 0;

  void increment() {
    setState(() {
      if (time < 60) {
        time++;
      }
    });
  }

  void decrement() {
    setState(() {
      if (time > 0) {
        time--;
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
                  onPressed: () => decrement(),
                ),
                Text(
                  time.toString(),
                  style: const TextStyle(fontSize: 24),
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
                SettingsData.setTime(time);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AutoWorkScreen()));
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }


}



