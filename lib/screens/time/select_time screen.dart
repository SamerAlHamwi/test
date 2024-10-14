

import 'package:flutter/material.dart';
import 'package:king/screens/settings/settings.dart';
import '../work/auto_work.dart';

class SelectAutoTimesScreen extends StatefulWidget {
  const SelectAutoTimesScreen({super.key});

  @override
  State<SelectAutoTimesScreen> createState() => _SelectAutoTimesScreenState();
}

class _SelectAutoTimesScreenState extends State<SelectAutoTimesScreen> {

  List counters = List<int>.filled(8, 0);

  @override
  void initState() {
    super.initState();
    initTime();
  }

  initTime(){
    if(SettingsData.getTimes().isNotEmpty){
      List times = SettingsData.getTimes();
      counters = times;
    }
  }

  void increment(int index) {
    setState(() {
      if (counters[index] < 60) {
        counters[index]++;
      }
    });
  }

  void decrement(int index) {
    setState(() {
      if (counters[index] > 0) {
        counters[index]--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر وقت النقرات'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //////////////
            const Text('توقيت المعاملة الأولى'),
            ...List.generate(2, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => decrement(index),
                  ),
                  Text(
                    counters[index].toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => increment(index),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10,),

            /////////////
            const Text('توقيت المعاملة الثانية'),
            ...List.generate(2, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => decrement(index+2),
                  ),
                  Text(
                    counters[index+2].toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => increment(index+2),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10,),

            /////////////
            const Text('توقيت المعاملة الثالثة'),
            ...List.generate(2, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => decrement(index+4),
                  ),
                  Text(
                    counters[index+4].toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => increment(index+4),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10,),

            /////////////
            const Text('توقيت المعاملة الرابعة'),
            ...List.generate(2, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => decrement(index+4),
                  ),
                  Text(
                    counters[index+6].toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => increment(index+4),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () async {
                SettingsData.setTimes(counters);
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



