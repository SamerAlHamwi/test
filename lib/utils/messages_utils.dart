

import 'package:audioplayers/audioplayers.dart';
import 'package:king/utils/utils.dart';

import '../constants/constants.dart';
import '../screens/settings/settings.dart';
import '../widgets/messages_widget.dart';
import 'captcha_utils.dart';

List<String> messages = [];

class MessagesUtils{

  static String requestCaptcha = 'Captcha Request';
  static String noCaptcha = 'No Captcha';
  static String errorCaptcha = 'حدث خطأ أثناء طلب المعادلة';
  static String getCaptchaString = 'Get Captcha';
  static String doneCaptcha = 'تم التثبيت بنجاح';

  static getCaptchaRequestMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $requestCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $requestCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $requestCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 3:
        return '${SettingsData.getUser4!.pPROFILERESULT!.fULLNAME ?? ''} $requestCaptcha ${CaptchaUtils.getDamascusTime()}';
    }
  }

  static getCaptchaReceivedMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $getCaptchaString ${CaptchaUtils.getDamascusTime()}';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $getCaptchaString ${CaptchaUtils.getDamascusTime()}';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $getCaptchaString ${CaptchaUtils.getDamascusTime()}';
      case 3:
        return '${SettingsData.getUser4!.pPROFILERESULT!.fULLNAME ?? ''} $getCaptchaString ${CaptchaUtils.getDamascusTime()}';
    }
  }

  static getNoCaptchaMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $noCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $noCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $noCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 3:
        return '${SettingsData.getUser4!.pPROFILERESULT!.fULLNAME ?? ''} $noCaptcha ${CaptchaUtils.getDamascusTime()}';
    }
  }

  static getErrorCaptchaMessage(int userIndex){
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $errorCaptcha';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $errorCaptcha';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $errorCaptcha';
      case 3:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $errorCaptcha';
    }
  }

  static getPassportReservedMessage(int userIndex){
    Utils.playAudio(AudioPlayer(),alertSound);
    switch(userIndex){
      case 0:
        return '${SettingsData.getUser1!.pPROFILERESULT!.fULLNAME ?? ''} $doneCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 1:
        return '${SettingsData.getUser2!.pPROFILERESULT!.fULLNAME ?? ''} $doneCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 2:
        return '${SettingsData.getUser3!.pPROFILERESULT!.fULLNAME ?? ''} $doneCaptcha ${CaptchaUtils.getDamascusTime()}';
      case 3:
        return '${SettingsData.getUser4!.pPROFILERESULT!.fULLNAME ?? ''} $doneCaptcha ${CaptchaUtils.getDamascusTime()}';
    }
  }

  static addNewMessage(String newMessage) {
    messages.add(newMessage);
    messageController.add(List.from(messages));
  }




}