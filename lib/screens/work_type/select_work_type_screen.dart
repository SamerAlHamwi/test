

import 'package:flutter/material.dart';

import '../accounts/login_accounts.dart';
import '../settings/settings.dart';
import '../time/select_time screen.dart';
import '../work/manual_work.dart';

class SelectWorkType extends StatelessWidget {
  const SelectWorkType({super.key});

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
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectAutoTimesScreen()));
            },
            child: const Text('نقر تلقائي'),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ManualScreen()));
            },
            child: const Text('نقر يدوي'),
          ),
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
