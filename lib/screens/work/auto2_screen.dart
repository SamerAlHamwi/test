





import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:king/screens/login_accounts/login_accounts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../constants/constants.dart';
import '../../models/alias_enum.dart';
import '../../utils/dio_client.dart';
import '../../utils/utils.dart';
import '../../widgets/clock_widget.dart';
import '../settings/settings.dart';


class AutoWorkScreen2 extends StatefulWidget {

  const AutoWorkScreen2({super.key});

  @override
  State<AutoWorkScreen2> createState() => _AutoWorkScreen2State();
}

class _AutoWorkScreen2State extends State<AutoWorkScreen2> with AutomaticKeepAliveClientMixin {

  bool _isLoading = false;
  bool _isLoadingProcesses = false;
  List<String> messages = [];
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
            onPressed: refreshProcesses,
            child: _isLoadingProcesses ? const Text('جاري التحميل') : const Text('تحديث المعاملات'),
          ),
          const SizedBox(height: 10,),
          const StreamClockWidget(),
          const SizedBox(height: 10,),
          Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ListView(
                reverse: true,
                children: List.generate(messages.length, (index) => Text(
                    messages[index],
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    messages[index].contains('تم') ?
                    Colors.green :
                    messages[index].contains('Get') ?
                    Colors.blue :
                    Colors.red,
                  ),
                )),
              ),
            ),
          ),
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
      getCaptcha(SettingsData.getProcesses1!.pRESULT!.first.pROCESSID!,0);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if(SettingsData.getSession2.isNotEmpty){
      getCaptcha(SettingsData.getProcesses2!.pRESULT!.first.pROCESSID!,1);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if(SettingsData.getSession3.isNotEmpty){
      getCaptcha(SettingsData.getProcesses3!.pRESULT!.first.pROCESSID!,2);
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

    int time = SettingsData.getTime();
    int first = time - 1;
    int second = time - 5;


    const durationLimit = Duration(minutes: 120); // Run for 60 minutes
    DateTime startTime = DateTime.now();

    _captchaTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      // Get the elapsed time
      Duration elapsedTime = DateTime.now().difference(startTime);

      // Stop the timer after 60 minutes
      if (elapsedTime >= durationLimit) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      DateTime now = DateTime.now();

      // Check if we are at the time second (same as the "time" variable)
      // and if 6 minutes (or a multiple) have passed
      if ((minutes.contains(now.minute) && now.second == first) || (minutes.contains(now.minute) && now.second == second)) {
        print('Captcha request');
        if (SettingsData.getSession1.isNotEmpty && SettingsData.getProcesses1!.pRECORDCOUNT! > 0) {
          getCaptcha(SettingsData.getProcesses1!.pRESULT![0].pROCESSID!, 0);
        }
        await Future.delayed(const Duration(milliseconds: 100));
        if (SettingsData.getSession2.isNotEmpty && SettingsData.getProcesses2!.pRECORDCOUNT! > 0) {
          getCaptcha(SettingsData.getProcesses2!.pRESULT![0].pROCESSID!, 1);
        }
        await Future.delayed(const Duration(milliseconds: 100));
        if (SettingsData.getSession3.isNotEmpty && SettingsData.getProcesses3!.pRECORDCOUNT! > 0) {
          getCaptcha(SettingsData.getProcesses3!.pRESULT![0].pROCESSID!, 2);
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
    }
  }

  Future<bool> getCaptcha(int id,int userIndex) async {

    final captchaUrl = 'https://api.ecsc.gov.sy:8080/files/fs/captcha/$id';

    final Dio dio = DioClient.getDio();

    try {
      final response = await dio.get(captchaUrl, options: Utils.getOptions(AliasEnum.none,userIndex));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final String imageUrl = data['file'];
        Utils.solveCaptcha({
          'img_url': 'data:image/jpg;base64,$imageUrl',
          'captcha': 1,
        }).then((value){
          if(value != -1){
            reservePassport(id,value,userIndex);
          }
        });
        messages.add(getCaptchaReceivedMessage(userIndex));
        setState(() {});

        return true;
      } else {
        final responseBody = json.decode(response.data);
        final message = responseBody['Message'];

        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );
        return false;
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data['Message'] ?? 'حدث خطأ اثناء طلب المعادلة';

      if(errorMessage.contains('تجاوزت') || errorMessage.contains('معالجة')){
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.info(
            message: errorMessage,
          ),
        );
        Utils.playAudio(AudioPlayer(),alertSound);
      }else{
        messages.add(getNoCaptchaMessage(userIndex));
        setState(() {});
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: errorMessage,
        //   ),
        // );
      }
      return false;
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
      return false;
    } finally {

    }
  }

  Future<void> reservePassport(int id, int captcha,int userIndex) async {
    final reserveUrl = 'https://api.ecsc.gov.sy:8080/rs/reserve?id=$id&captcha=$captcha';
    final Dio dio = DioClient.getDio();

    for(int i = 0;i < 5;i++){
      try {
        final response = await dio.get(reserveUrl, options: Utils.getOptions(AliasEnum.reserve,userIndex));

        if (response.statusCode == 200) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: "تم تثبيت المعاملة بنجاح",
            ),
          );
          messages.add(getPassportReservedMessage(userIndex));
          setState(() {});
          break;
        }
      } on DioException catch (e) {
        String errorMessage = e.response?.data['Message'] ?? 'An unexpected error occurred.';

        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: errorMessage,
          ),
        );
        if(errorMessage.contains('نأسف') || errorMessage.contains('النتيجة')){
          break;
        }
      } catch (e) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'An unexpected error occurred. Please try again.',
          ),
        );
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  getCaptchaReceivedMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} Get Captcha';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} Get Captcha';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} Get Captcha';
    }
  }

  getNoCaptchaMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} NO Captcha';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} NO Captcha';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} NO Captcha';
    }
  }

  getPassportReservedMessage(int userIndex){
    Utils.playAudio(AudioPlayer(),alertSound);
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} تم التثبيت بنجاح ';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} تم التثبيت بنجاح ';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} تم التثبيت بنجاح ';
    }
  }

  @override
  bool get wantKeepAlive => true;

}


