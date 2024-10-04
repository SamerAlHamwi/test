

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../models/alias_enum.dart';
import '../../models/login_model.dart';
import '../../utils/dio_client.dart';
import '../../utils/utils.dart';
import '../settings/settings.dart';
import '../work_type/select_work_type_screen.dart';


class LoginPhonePasswordScreen extends StatefulWidget {
  const LoginPhonePasswordScreen({super.key});

  @override
  State<LoginPhonePasswordScreen> createState() => _LoginPhonePasswordScreenState();
}

class _LoginPhonePasswordScreenState extends State<LoginPhonePasswordScreen> {

  // Controllers for the text fields
  final List<TextEditingController> phoneControllers = List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> passwordControllers = List.generate(3, (index) => TextEditingController());
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Title
                      Text(getLoginTitle(index),),
                      const SizedBox(height: 10),
                      // Phone Number TextField
                      getPhoneNumberTextField(phoneControllers[index]),
                      const SizedBox(height: 10),
                      // Password TextField
                      getPasswordTextField(passwordControllers[index]),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  bool success = await loginToThreeAccounts();
                  if(success){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SelectWorkType()));
                  }
                },
                child: _isLoading ? const Text('يتم التحميل...') : const Text('تسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  getPhoneNumberTextField(TextEditingController controller){
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'رقم الموبايل',
        labelStyle: TextStyle(
          fontSize: 12,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        border: OutlineInputBorder(),
      ),
    );
  }

  getPasswordTextField(TextEditingController controller){
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'كلمة المرور',
        labelStyle: TextStyle(
          fontSize: 12,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        border: OutlineInputBorder(),
      ),
    );
  }

  getLoginTitle(int index){
    switch(index){
      case 0:
        return 'المعاملة الأولى';
      case 1:
        return 'المعاملة الثانية';
      case 2:
        return 'المعاملة الثالثة';
    }
  }

  loginToThreeAccounts() async {
    for(int index = 0; index < 3 ; index++){
      if(phoneControllers[index].text.isNotEmpty && passwordControllers[index].text.isNotEmpty){
        bool isSuccess = await login(userName: phoneControllers[index].text.trim(),password: passwordControllers[index].text.trim(),index: index);
        if(!isSuccess){
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> login({required String userName,required String password,required int index}) async {
    setState(() {
      _isLoading = true;
    });

    const loginUrl = 'https://api.ecsc.gov.sy:8080/secure/auth/login';

    final Dio dio = DioClient.getDio();

    try {
      final response = await dio.post(
          loginUrl,
          options: Utils.getOptions(AliasEnum.none,index),
          data: {
            'username': userName, 'password': password
          }
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        String session = response.headers['set-cookie']?.first as String;
        RegExp regExp = RegExp(r'SESSION=([^;]+)');
        Match? match = regExp.firstMatch(session);
        if (match != null) {
          String sessionValue = match.group(1)!;
          LoginModel model = LoginModel.fromJson(data);
          switch(index){
            case 0:
              SettingsData.setSession1(sessionValue);
              SettingsData.setUser1(data);
              break;
            case 1:
              SettingsData.setSession2(sessionValue);
              SettingsData.setUser2(data);
              break;
            case 2:
              SettingsData.setSession3(sessionValue);
              SettingsData.setUser3(data);
              break;
          }
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'مرحباً ${model.pPROFILERESULT!.fULLNAME} تم تسجيل الدخول بنجاح، جاري تحضير المعاملات ',
            ),
          );
        }

        setState(() {});
        bool isSuccess = await Utils.getMyProcesses(index);

        return isSuccess;
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
      print(e);
      String errorMessage = e.response?.data['Message'] ?? 'An unexpected error occurred.';

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: errorMessage,
        ),
      );
      return false;
    } catch (e) {
      print(e);
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


}


