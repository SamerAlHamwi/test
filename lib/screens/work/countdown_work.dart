

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:king/screens/login_accounts/login_accounts.dart';
import 'package:king/utils/captcha_utils.dart';
import '../../utils/utils.dart';
import '../../widgets/clock_widget.dart';
import '../../widgets/messages_widget.dart';
import '../settings/settings.dart';


class CountDownScreen extends StatefulWidget {

  const CountDownScreen({super.key});

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> with AutomaticKeepAliveClientMixin {

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
          '2الحرق',
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
    setState(() {
      _isLoadingProcesses = false;
    });
  }

  void runAutoCaptcha() {
    setState(() {
      _isLoading = true;
    });

    int time = SettingsData.getCountDownTime();
    List times = generateTimeList(time);

    const durationLimit = Duration(minutes: 120);
    DateTime startTime = DateTime.now();

    _captchaTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      Duration elapsedTime = DateTime.now().difference(startTime);

      if (elapsedTime >= durationLimit) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      DateTime now = CaptchaUtils.getCurrentTime();

      if (minutes.contains(now.minute)) {
        if(now.second == times[0]){
          if (SettingsData.getSession1.isNotEmpty) {
            CaptchaUtils.getCaptcha(SettingsData.getProcesses1!.pRESULT![0].pROCESSID!, 0);
          }
          await Future.delayed(const Duration(milliseconds: 100));
          if (SettingsData.getSession2.isNotEmpty) {
            CaptchaUtils.getCaptcha(SettingsData.getProcesses2!.pRESULT![0].pROCESSID!, 1);
          }
          await Future.delayed(const Duration(milliseconds: 100));
          if (SettingsData.getSession3.isNotEmpty) {
            CaptchaUtils.getCaptcha(SettingsData.getProcesses3!.pRESULT![0].pROCESSID!, 2);
          }
        }
        if(now.second == times[1]){
          if (SettingsData.getSession1.isNotEmpty) {
            CaptchaUtils.getCaptcha(SettingsData.getProcesses1!.pRESULT![1].pROCESSID!, 0);
          }
          await Future.delayed(const Duration(milliseconds: 100));
          if (SettingsData.getSession2.isNotEmpty) {
            CaptchaUtils.getCaptcha(SettingsData.getProcesses2!.pRESULT![1].pROCESSID!, 1);
          }
          await Future.delayed(const Duration(milliseconds: 100));
          if (SettingsData.getSession3.isNotEmpty) {
            CaptchaUtils.getCaptcha(SettingsData.getProcesses3!.pRESULT![1].pROCESSID!, 2);
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

  List<int> generateTimeList(int second) {
    List<int> timeList = [];
    int time1 = (second - 7) % 60;
    if (time1 < 0) {
      time1 += 60;
    }

    int time2 = (second - 2) % 60;
    if (time2 < 0) {
      time2 += 60;
    }

    timeList.add(time1);
    timeList.add(time2);

    // for (int i = 2; i <= 7; i++) {
    //   int time = (second - i) % 60;
    //   if (time < 0) {
    //     time += 60;
    //   }
    //   timeList.add(time);
    // }

    return timeList;
  }

  @override
  bool get wantKeepAlive => true;

}


