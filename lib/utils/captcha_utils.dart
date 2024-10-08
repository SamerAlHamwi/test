


import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:king/utils/keys.dart';
import 'package:king/utils/utils.dart';
import 'package:king/widgets/messages_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../constants/constants.dart';
import '../models/alias_enum.dart';
import '../screens/settings/settings.dart';
import 'dio_client.dart';

List<String> messages = [];

class CaptchaUtils{

  static String requestCaptcha = 'Captcha Request';
  static String noCaptcha = 'No Captcha';
  static String getCaptchaString = 'Get Captcha';
  static String doneCaptcha = 'تم التثبيت بنجاح';

  static getCaptchaReceivedMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $getCaptchaString ${getDamascusTime()}';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $getCaptchaString ${getDamascusTime()}';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $getCaptchaString ${getDamascusTime()}';
    }
  }

  static getNoCaptchaMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $noCaptcha';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $noCaptcha';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $noCaptcha';
    }
  }

  static getPassportReservedMessage(int userIndex){
    Utils.playAudio(AudioPlayer(),alertSound);
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $doneCaptcha ${getDamascusTime()}';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $doneCaptcha ${getDamascusTime()}';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $doneCaptcha ${getDamascusTime()}';
    }
  }

  static String getDamascusTime() {
    DateTime dateTime = DateTime.now().toUtc().add(const Duration(hours: 3));
    String time = '${dateTime.minute}:${dateTime.second} ${dateTime.millisecond}';
    return time;
  }

  static DateTime getCurrentTime() {
    DateTime dateTime = DateTime.now().toUtc().add(const Duration(hours: 3));
    return dateTime;
  }

  static Future<bool> getCaptcha(int id,int userIndex) async {

    final captchaUrl = 'https://api.ecsc.gov.sy:8080/files/fs/captcha/$id';

    final Dio dio = DioClient.getDio();
    messageController.add([requestCaptcha]);
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
        messageController.add([CaptchaUtils.getCaptchaReceivedMessage(userIndex)]);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data['Message'] ?? 'حدث خطأ اثناء طلب المعادلة';

      if(errorMessage.contains('تجاوزت') || errorMessage.contains('معالجة')){
        showTopSnackBar(
          Overlay.of(Keys.overlayKey.currentContext!),
          CustomSnackBar.info(
            message: errorMessage,
          ),
        );
        Utils.playAudio(AudioPlayer(),alertSound);
      }else{
        messageController.add([CaptchaUtils.getNoCaptchaMessage(userIndex)]);
      }
      return false;
    } catch (e) {
      showTopSnackBar(
        Overlay.of(Keys.overlayKey.currentContext!),
        const CustomSnackBar.error(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
      return false;
    } finally {

    }
  }

  static Future<void> reservePassport(int id, int captcha,int userIndex) async {
    final reserveUrl = 'https://api.ecsc.gov.sy:8080/rs/reserve?id=$id&captcha=$captcha';
    final Dio dio = DioClient.getDio();

    for(int i = 0;i < 5;i++){
      try {
        final response = await dio.get(reserveUrl, options: Utils.getOptions(AliasEnum.reserve,userIndex));

        if (response.statusCode == 200) {
          showTopSnackBar(
            Overlay.of(Keys.overlayKey.currentContext!),
            const CustomSnackBar.success(
              message: "تم تثبيت المعاملة بنجاح",
            ),
          );
          messageController.add([CaptchaUtils.getPassportReservedMessage(userIndex)]);
          break;
        }
      } on DioException catch (e) {
        String errorMessage = e.response?.data['Message'] ?? 'An unexpected error occurred.';

        showTopSnackBar(
          Overlay.of(Keys.overlayKey.currentContext!),
          CustomSnackBar.error(
            message: errorMessage,
          ),
        );
        if(errorMessage.contains('نأسف') || errorMessage.contains('النتيجة')){
          break;
        }
      } catch (e) {
        showTopSnackBar(
          Overlay.of(Keys.overlayKey.currentContext!),
          const CustomSnackBar.error(
            message: 'An unexpected error occurred. Please try again.',
          ),
        );
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }


}