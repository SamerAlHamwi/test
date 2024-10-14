

import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:king/models/alias_enum.dart';
import 'package:king/screens/settings/settings.dart';
import 'package:king/utils/dio_client.dart';
import 'package:king/utils/keys.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/process_model.dart';
import 'messages_utils.dart';

class Utils {

  static getHeaders(AliasEnum type,int userIndex){
    String session = '';


    String alias;
    switch(type){
      case AliasEnum.add:
        alias = 'OPHRUHvKso';
      case AliasEnum.delete:
        alias = 'OPMEShwoqV';
      case AliasEnum.getAll:
        alias = 'OPkUVkYsyq';
      case AliasEnum.reserve:
        alias = '';
      case AliasEnum.details:
        alias = 'OPSfpsWfkvps';
      case AliasEnum.none:
        alias = '';

      //OPSyGCrxPB notifications
    }

    final Map<String,String> headers = {
      'Content-Type': 'application/json'
    };

    // if(!SettingsData.getType){
      headers.addAll({
        'Accept': 'application/json, text/plain, */*',
        'Accept-Encoding': 'gzip, deflate, br, zstd',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
        'Cache-Control': 'max-age=0',
        'Host': 'api.ecsc.gov.sy:8080',
        'Referer': 'https://www.ecsc.gov.sy/',
        'Origin': 'https://www.ecsc.gov.sy',
        'Sec-Ch-Ua': '"Not/A)Brand";v="8", "Chromium";v="127", "Microsoft Edge";v="127"',
        'Sec-Ch-Ua-Mobile': '?0',
        'Sec-Fetch-Dest': 'empty',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-site',
        'Source': 'WEB',
      });
    //As Edge
    //'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0',
    // }else{
    //   headers.addAll({
    //     'Source': 'API',
    //     'Version': 2,
    //     'Authorization': session,
    //   });
    // }

    switch (userIndex){
      case 0:
        session = SettingsData.getSession1;
        headers.addAll({
          'Sec-Ch-Ua-Platform': 'macOS',
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11.15; rv:129.0) Gecko/20110101 Firefox/128.0',
        });
        break;
      case 1:
        session = SettingsData.getSession2;
        headers.addAll({
          'Sec-Ch-Ua-Platform': 'Windows',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/531.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/531.36 Edg/129.0.0.0',
        });
        break;
      case 2:
        session = SettingsData.getSession3;
        headers.addAll({
          'Sec-Ch-Ua-Platform': 'Windows',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/533.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/533.36 Edg/128.0.0.0',
        });
        break;
      case 3:
        session = SettingsData.getSession4;
        headers.addAll({
          'Sec-Ch-Ua-Platform': 'Windows',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/532.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/532.36 Edg/127.0.0.0',
        });
        break;
    }

    if(alias.isNotEmpty){
      headers.addAll({
        'Alias': alias,
      });
    }

    if(session.isNotEmpty){ // && !SettingsData.getType
      headers.addAll({
        'Cookie': 'SESSION=$session',
      });
    }

    return headers;
  }


  static saveImageToDevice(Uint8List imageBytes,String imageName) async {
    try {
      final directory = await getDownloadsDirectory();

      if (directory == null) {
        return;
      }

      final imagePath = '${directory.path}/$imageName.jpg';

      final file = File(imagePath);

      if (await file.exists()) {
        print('exist');
      }
      else {
        await file.writeAsBytes(imageBytes);
        print('Image saved');
      }
    } catch (e) {
      print('Error saving image');
    }
  }


  static getOptions(AliasEnum type, int userIndex){
    return Options(
      headers: getHeaders(type,userIndex),
      sendTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      persistentConnection: true,
      followRedirects: true,
    );
  }

  static Map<String, String> getOptions2(AliasEnum type, int userIndex) {
    return getHeaders(type, userIndex);  // Ensure getHeaders returns Map<String, String>
  }


  static getMyProcesses(int userIndex) async {
    const getTransactionsUrl = 'https://api.ecsc.gov.sy:8080/dbm/db/execute';

    final Dio dio = DioClient.getDio();

    try {
      final response = await dio.post(
          getTransactionsUrl,
          options: Utils.getOptions(AliasEnum.getAll,userIndex),
          data: {
            "ALIAS": "OPkUVkYsyq",
            "P_USERNAME": "WebSite",
            "P_PAGE_INDEX": 0,
            "P_PAGE_SIZE": 100
          }
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        switch(userIndex){
          case 0:
            SettingsData.setProcesses1(data);
            break;
          case 1:
            SettingsData.setProcesses2(data);
            break;
          case 2:
            SettingsData.setProcesses3(data);
            break;
          case 3:
            SettingsData.setProcesses4(data);
            break;
        }

        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data['Message'] ?? 'An unexpected error occurred.';
      MessagesUtils.addNewMessage(errorMessage);
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<int> solveCaptcha(Map model) async {
    const solveUrl = 'http://127.0.0.1:1234/send_api';

    final Dio dio = DioClient.getDio();

    try {
      final response = await dio.post(
        solveUrl,
        data: model,
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          },
        )
      );

      print(response.data);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return data['result'];
      } else {
        return -1;
      }
    } on DioException catch (e) {
      // String errorMessage = e.response?.data['Message'] ?? 'An unexpected error occurred.';
      print(e);


      return -1;
    } catch (e) {
      return -1;
    }
  }


  static playAudio(AudioPlayer player,String audio) async {
    await player.play(AssetSource(audio));
  }

  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a time value';
    }

    int? enteredTime = int.tryParse(value);
    if (enteredTime == null || enteredTime < 0 || enteredTime > 59) {
      return 'Enter a valid time between 0 and 59';
    }

    return null;
  }


}
