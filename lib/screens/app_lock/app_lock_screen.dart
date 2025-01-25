
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../login_accounts/login_accounts.dart';
import '../settings/settings.dart';
import '../work_type/select_work_type_screen.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {

  String message = 'Welcome to Tigger';

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  addUser(String id) async {
    final todo = ParseObject('Users')
      ..set('device', id)
      ..set('isEnabled', false);
    await todo.save();
  }

  checkUser() async {
    String deviceId = (await getDeviceId()) ?? '';
    QueryBuilder<ParseObject> queryTodo = QueryBuilder<ParseObject>(ParseObject('Users'));
    final ParseResponse apiResponse = await queryTodo.query();
    if (apiResponse.success && apiResponse.results != null) {
      List response = apiResponse.results as List<ParseObject>;
      List<UserModel> users = response.map((e) => UserModel.fromJson(e)).toList();
      List<String> deviceIds = users.map((e) => e.device ?? '').toList();
      bool contains = deviceIds.contains(deviceId);
      if(contains){
        if(users.where((element) => element.device == deviceId).first.isEnabled ?? false){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsData.hasToken() ? const SelectWorkType() : const LoginPhonePasswordScreen(),));
        }else{
          setState(() {
            message = 'الجهاز الخاص بك غير مصرح لاستخدام هذا التطبيق';
          });
        }
      }else{
        addUser(deviceId);
        setState(() {
          message = 'الجهاز الخاص بك غير مصرح لاستخدام هذا التطبيق';
        });
      }
    } else {
      addUser(deviceId);
      setState(() {
        message = 'الجهاز الخاص بك غير مصرح لاستخدام هذا التطبيق';
      });
    }
  }

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      return macInfo.systemGUID;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    } else {
      return null;
    }
  }

}

class UserModel {
  String? device;
  bool? isEnabled;

  UserModel({
    this.device,
    this.isEnabled,
  });

  UserModel.fromJson(ParseObject json) {
    device = json.get<String>('device') ?? '';
    isEnabled = json.get<bool>('isEnabled') ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['device'] = device;
    json['isEnabled'] = isEnabled;
    return json;
  }
}