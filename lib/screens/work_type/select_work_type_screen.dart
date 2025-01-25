

import 'package:flutter/material.dart';
import 'package:king/screens/mobile/processes/process_page.dart';
import '../login_accounts/login_accounts.dart';
import '../mobile/home/home.dart';
import '../settings/settings.dart';
import '../time/select_one_time_screen.dart';
import '../time/select_time screen.dart';
import '../work/manual_work.dart';

class SelectWorkType extends StatefulWidget {
  const SelectWorkType({super.key});

  @override
  State<SelectWorkType> createState() => _SelectWorkTypeState();
}

class _SelectWorkTypeState extends State<SelectWorkType> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر نوع العمل'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width,),
          // ElevatedButton(
          //   onPressed: () async {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectAutoTimesScreen()));
          //   },
          //   child: const Text('نقر تلقائي'),
          // ),
          // const SizedBox(height: 20,),
          // ElevatedButton(
          //   onPressed: () async {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> const ManualScreen()));
          //   },
          //   child: const Text('نقر يدوي'),
          // ),
          // const SizedBox(height: 20,),
          // ElevatedButton(
          //   onPressed: () async {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectOneTimeScreen()));
          //   },
          //   child: const Text('الحرق'),
          // ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
            },
            child: const Text('موبايل'),
          ),
          const SizedBox(height: 20,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await SettingsData.logout();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPhonePasswordScreen()));
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.exit_to_app_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
