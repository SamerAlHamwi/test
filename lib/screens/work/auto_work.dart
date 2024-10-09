

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:king/screens/login_accounts/login_accounts.dart';
import '../../utils/captcha_utils.dart';
import '../../utils/utils.dart';
import '../../widgets/clock_widget.dart';
import '../../widgets/messages_widget.dart';
import '../settings/settings.dart';


class AutoWorkScreen extends StatefulWidget {

  const AutoWorkScreen({super.key});

  @override
  State<AutoWorkScreen> createState() => _AutoWorkScreenState();
}

class _AutoWorkScreenState extends State<AutoWorkScreen> with AutomaticKeepAliveClientMixin {

  bool _isLoading = false;
  bool _isLoadingProcesses = false;

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
            onPressed: _isLoading ? stopAutoCaptcha : runAutoCaptcha,
            child: _isLoading ? const Text('جاري التثبيت') : const Text('أبدأ'),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: refreshProcesses,
            child: _isLoadingProcesses ? const Text('جاري التحميل') : const Text('تحديث المعاملات'),
          ),
          const SizedBox(height: 10,),
          const StreamClockWidget(),
          const SizedBox(height: 10,),
          const MessageStreamWidget(),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () async {
              getCaptchaForAllUsers();
            },
            child: _isLoadingProcesses ? const Text('اح تنين') : const Text('طلب معادلات'),
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

  getCaptchaForAllUsers() async {
    if(SettingsData.getSession1.isNotEmpty){
      CaptchaUtils.getCaptcha(SettingsData.getProcesses1!.pRESULT!.first.pROCESSID!,0);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if(SettingsData.getSession2.isNotEmpty){
      CaptchaUtils.getCaptcha(SettingsData.getProcesses2!.pRESULT!.first.pROCESSID!,1);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if(SettingsData.getSession3.isNotEmpty){
      CaptchaUtils.getCaptcha(SettingsData.getProcesses3!.pRESULT!.first.pROCESSID!,2);
    }
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

  Timer? _captchaTimer;

  void runAutoCaptcha() {
    setState(() {
      _isLoading = true;
    });

    List<int> intervals = SettingsData.getTimes();

    const durationLimit = Duration(minutes: 150);
    DateTime startTime = DateTime.now();

    _captchaTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      Duration elapsedTime = DateTime.now().difference(startTime);

      if (elapsedTime >= durationLimit) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      for (int i = 0; i < intervals.length; i++) {
        int currentInterval = intervals[i];
        DateTime now = CaptchaUtils.getCurrentTime();

        if (now.second == currentInterval) {
          switch (i) {
            case 0:
              if (SettingsData.getSession1.isNotEmpty) {
                CaptchaUtils.getCaptcha(SettingsData.getProcesses1!.pRESULT![0].pROCESSID!, 0);
              }
              break;
            case 1:
              if (SettingsData.getSession1.isNotEmpty) {
                CaptchaUtils.getCaptcha(SettingsData.getProcesses1!.pRESULT![1].pROCESSID!, 0);
              }
              break;
            case 2:
              if (SettingsData.getSession2.isNotEmpty) {
                CaptchaUtils.getCaptcha(SettingsData.getProcesses2!.pRESULT![0].pROCESSID!, 1);
              }
              break;
            case 3:
              if (SettingsData.getSession2.isNotEmpty) {
                CaptchaUtils.getCaptcha(SettingsData.getProcesses2!.pRESULT![1].pROCESSID!, 1);
              }
              break;
            case 4:
              if (SettingsData.getSession3.isNotEmpty) {
                CaptchaUtils.getCaptcha(SettingsData.getProcesses3!.pRESULT![0].pROCESSID!, 2);
              }
              break;
            case 5:
              if (SettingsData.getSession3.isNotEmpty) {
                CaptchaUtils.getCaptcha(SettingsData.getProcesses3!.pRESULT![1].pROCESSID!, 2);
              }
              break;
          }
        }
      }
    });
  }

  void stopAutoCaptcha() {
    if (_captchaTimer != null && _captchaTimer!.isActive) {
      _captchaTimer!.cancel();
      setState(() {
        _isLoading = false;
      });
      print('AutoCaptcha stopped manually');
      Phoenix.rebirth(context);
    }
  }

  @override
  bool get wantKeepAlive => true;

}


