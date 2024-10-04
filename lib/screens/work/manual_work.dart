

import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:king/screens/accounts/login_accounts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../constants/constants.dart';
import '../../models/alias_enum.dart';
import '../../utils/dio_client.dart';
import '../../utils/utils.dart';
import '../../widgets/clock_widget.dart';
import '../settings/settings.dart';


class ManualScreen extends StatefulWidget {

  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> with AutomaticKeepAliveClientMixin {

  bool _isLoading = false;
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
            child: _isLoading ? const Text('اح تنين') : const Text('طلب معادلات'),
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
                children: List.generate(messages.length, (index) => Text(messages[index])),
              ),
            ),
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

  getCaptchaForAllUsers(){
    if(SettingsData.getSession1.isNotEmpty){
      getCaptcha(SettingsData.getProcesses1!.pRESULT!.first.pROCESSID!,0);
    }
    if(SettingsData.getSession2.isNotEmpty){
      getCaptcha(SettingsData.getProcesses2!.pRESULT!.first.pROCESSID!,1);
    }
    if(SettingsData.getSession3.isNotEmpty){
      getCaptcha(SettingsData.getProcesses3!.pRESULT!.first.pROCESSID!,2);
    }
  }

  Future<bool> getCaptcha(int id,int userIndex) async {
    setState(() {
      _isLoading = true;
    });

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
      String errorMessage = e.response?.data['Message'] ?? 'حدث خطأ اثناء طلب المعادلة في الصفحة 1';

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
      setState(() {
        _isLoading = false;
      });
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


