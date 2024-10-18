


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:king/screens/login_accounts/login_accounts.dart';
import 'package:king/utils/captcha_utils.dart';
import '../../utils/utils.dart';
import '../../widgets/clock_widget.dart';
import '../../widgets/messages_widget.dart';
import '../settings/settings.dart';


class AutoWorkScreen2 extends StatefulWidget {

  const AutoWorkScreen2({super.key});

  @override
  State<AutoWorkScreen2> createState() => _AutoWorkScreen2State();
}

class _AutoWorkScreen2State extends State<AutoWorkScreen2> with AutomaticKeepAliveClientMixin {

  bool _isLoading = false;
  bool _isLoadingProcesses = false;
  List<int> minutes = [3,9,15,21,27,33,39,45,51,57];
  // List<int> minutes = [2,8,14,20,26,32,38,44,50,56];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الحرق',
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
    await Future.delayed(const Duration(milliseconds: 100));
    if(SettingsData.getSession4.isNotEmpty){
      CaptchaUtils.getCaptcha(SettingsData.getProcesses4!.pRESULT!.first.pROCESSID!,3);
    }
  }

  Timer? _captchaTimer;

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
    if(SettingsData.getSession4.isNotEmpty){
      await Utils.getMyProcesses(3);
    }
    setState(() {
      _isLoadingProcesses = false;
    });
  }

  void runAutoCaptcha() {
    setState(() {
      _isLoading = true;
    });

    int first = SettingsData.getTime();

    const durationLimit = Duration(minutes: 120);
    DateTime startTime = DateTime.now();

    _captchaTimer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) async {
      Duration elapsedTime = DateTime.now().difference(startTime);

      if (elapsedTime >= durationLimit) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      DateTime now = CaptchaUtils.getCurrentTime();

      if (minutes.contains(now.minute) && now.second == first && isInBetween(now.millisecond) ) {
        if (SettingsData.getSession1.isNotEmpty) {
          CaptchaUtils.getCaptcha(SettingsData.getProcesses1!.pRESULT![0].pROCESSID!, 0);
        }
        await Future.delayed(const Duration(milliseconds: 200));
        if (SettingsData.getSession2.isNotEmpty) {
          CaptchaUtils.getCaptcha(SettingsData.getProcesses2!.pRESULT![0].pROCESSID!, 1);
        }
        await Future.delayed(const Duration(milliseconds: 200));
        if (SettingsData.getSession3.isNotEmpty) {
          CaptchaUtils.getCaptcha(SettingsData.getProcesses3!.pRESULT![0].pROCESSID!, 2);
        }
        await Future.delayed(const Duration(milliseconds: 200));
        if (SettingsData.getSession4.isNotEmpty) {
          CaptchaUtils.getCaptcha(SettingsData.getProcesses4!.pRESULT![0].pROCESSID!, 3);
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

  bool isInBetween(int current){
    int second = SettingsData.getTime2();
    int s2 = second + 100;
    if(current >= second && current <= s2){
      return true;
    }
    return false;
  }


  @override
  bool get wantKeepAlive => true;

}


