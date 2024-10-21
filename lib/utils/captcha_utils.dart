


import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:king/utils/keys.dart';
import 'package:king/utils/utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../constants/constants.dart';
import '../models/alias_enum.dart';
import 'dio_client.dart';
import 'messages_utils.dart';


class CaptchaUtils{

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
    MessagesUtils.addNewMessage(MessagesUtils.getCaptchaRequestMessage(userIndex));
    try {
      final response = await dio.get(captchaUrl, options: Utils.getOptions(AliasEnum.none,userIndex));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final String imageUrl = data['file'];
        Utils.solveCaptcha({
          'img': 'data:image/jpg;base64,$imageUrl',
        }).then((value){
          if(value != -1){
            reservePassport(id,value,userIndex);
          }
        });
        MessagesUtils.addNewMessage(MessagesUtils.getCaptchaReceivedMessage(userIndex));
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data['Message'] ?? 'حدث خطأ اثناء طلب المعادلة';

      if(errorMessage.contains('تجاوزت') || errorMessage.contains('معالجة')){
        MessagesUtils.addNewMessage('تجاوزت/نشاط');
      }else{
        if(!errorMessage.contains('حدث خطأ اثناء طلب المعادلة')){
          MessagesUtils.addNewMessage(MessagesUtils.getNoCaptchaMessage(userIndex));
        }else{
          MessagesUtils.addNewMessage(MessagesUtils.getErrorCaptchaMessage(userIndex));
        }
      }
      return false;
    } catch (e) {
      MessagesUtils.addNewMessage(e.toString());
      return false;
    } finally {

    }
  }

  static Future<void> reservePassport(int id, int captcha,int userIndex) async {
    final reserveUrl = 'https://api.ecsc.gov.sy:8080/rs/reserve?id=$id&captcha=$captcha';
    final Dio dio = DioClient.getDio();

    for(int i = 0;i < 3;i++){
      try {
        final response = await dio.get(reserveUrl, options: Utils.getOptions(AliasEnum.reserve,userIndex));

        if (response.statusCode == 200) {
          MessagesUtils.addNewMessage(MessagesUtils.getPassportReservedMessage(userIndex));
          break;
        }
      } on DioException catch (e) {
        String errorMessage = e.response?.data['Message'] ?? 'An unexpected error occurred.';

        MessagesUtils.addNewMessage(errorMessage);

        if(errorMessage.contains('نأسف') || errorMessage.contains('النتيجة')){
          break;
        }
      } catch (e) {
        print(e);
        MessagesUtils.addNewMessage(e.toString());
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }


}