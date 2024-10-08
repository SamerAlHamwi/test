

import 'package:flutter/material.dart';
import 'package:king/screens/login_accounts/login_accounts.dart';
import '../../utils/captcha_utils.dart';
import '../../utils/utils.dart';
import '../../widgets/clock_widget.dart';
import '../../widgets/messages_widget.dart';
import '../settings/settings.dart';


class ManualScreen extends StatefulWidget {

  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> with AutomaticKeepAliveClientMixin {

  bool _isLoadingProcesses = false;
  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'التثبيت',
          style: TextStyle(
            color: Colors.blue
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16,width: MediaQuery.of(context).size.width,),
          ElevatedButton(
            onPressed: () async {
              getCaptchaForAllUsers();
            },
            child: const Text('طلب معادلات'),
          ),
          const SizedBox(height: 10,),
          const StreamClockWidget(),
          const SizedBox(height: 10,),
          const MessageStreamWidget(),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: refreshProcesses,
            child: _isLoadingProcesses ? const Text('جاري التحميل') : const Text('تحديث المعاملات'),
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

  void refreshProcesses() async {
    setState(() {
      _isLoadingProcesses = true;
    });
    if(SettingsData.getSession1.isNotEmpty){
      await Utils.getMyProcesses(0);
    }
    if(SettingsData.getSession2.isNotEmpty){
      await Utils.getMyProcesses(1);
    }
    if(SettingsData.getSession3.isNotEmpty){
      await Utils.getMyProcesses(2);
    }

    setState(() {
      _isLoadingProcesses = false;
    });
  }

  getCaptchaForAllUsers() async {
    if(SettingsData.getSession1.isNotEmpty){
      CaptchaUtils.getCaptcha(SettingsData.getProcesses1!.pRESULT!.first.pROCESSID!,0);
    }
    await Future.delayed(const Duration(milliseconds: 150));
    if(SettingsData.getSession2.isNotEmpty){
      CaptchaUtils.getCaptcha(SettingsData.getProcesses2!.pRESULT!.first.pROCESSID!,1);
    }
    await Future.delayed(const Duration(milliseconds: 150));
    if(SettingsData.getSession3.isNotEmpty){
      CaptchaUtils.getCaptcha(SettingsData.getProcesses3!.pRESULT!.first.pROCESSID!,2);
    }
  }

  @override
  bool get wantKeepAlive => true;

}


