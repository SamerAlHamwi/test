

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../models/alias_enum.dart';
import '../../models/login_model.dart';
import '../../models/user_model.dart';
import '../../utils/dio_client.dart';
import '../../utils/utils.dart';
import '../login_accounts/login_accounts.dart';
import '../settings/settings.dart';
import '../time/select_countdown_time_screen.dart';
import '../time/select_one_time_screen.dart';
import '../time/select_time screen.dart';
import '../work/manual_work.dart';

class SelectWorkType extends StatefulWidget {
  const SelectWorkType({super.key});

  @override
  State<SelectWorkType> createState() => _SelectWorkTypeState();
}

class _SelectWorkTypeState extends State<SelectWorkType> {

  String pDate = '', aDate = '', sDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر نوع العمل'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width,),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectAutoTimesScreen()));
            },
            child: const Text('نقر تلقائي'),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ManualScreen()));
            },
            child: const Text('نقر يدوي'),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectOneTimeScreen()));
            },
            child: const Text('الحرق'),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectCountDownTimeScreen()));
            },
            child: const Text('الحرق2'),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              login(userName: '0945718880',password: 'Sr12345678');
            },
            child: const Text('حساب وقت الفتحة'),
          ),
          const SizedBox(height: 20,),
          Text('$pDate \n $aDate \n $sDate',
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.black),
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


  Future<bool> login({required String userName,required String password}) async {

    const loginUrl = 'https://api.ecsc.gov.sy:8080/secure/auth/login';

    final Dio dio = DioClient.getDio();
    DateTime previous = DateTime.now();
    pDate = 'Previous Date: ${previous.hour}:${previous.minute}:${previous.second}';

    try {
      final response = await dio.post(
          loginUrl,
          options: Utils.getOptions(AliasEnum.none,0),
          data: {
            'username': userName, 'password': password
          }
      );

      if (response.statusCode == 200) {
        String serverDate = response.headers['Date']?.first as String;
        DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
        DateTime parsedDate = format.parseUTC(serverDate);
        DateTime now = DateTime.now();
        aDate = 'After Date: ${now.hour}:${now.minute}:${now.second}';
        sDate = 'Server Date: ${parsedDate.hour}:${parsedDate.minute}:${parsedDate.second}';
        setState(() {});
        return true;
      } else {
        final responseBody = json.decode(response.data);
        final message = responseBody['Message'];
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: message,
          ),
        );
        return false;
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data['Message'] ?? 'An unexpected error occurred.';

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: errorMessage,
        ),
      );
      return false;
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
      return false;
    }
  }
}
