
import 'package:get_storage/get_storage.dart';
import 'package:king/models/login_model.dart';
import 'package:king/models/process_model.dart';

import '../../models/user_model.dart';

class SettingsData {

  static String storageName = 'sy';
  static GetStorage box = GetStorage(storageName);
  static String tokenKey1 = 'session1';
  static String tokenKey2 = 'session2';
  static String tokenKey3 = 'session3';
  static String tokenKey4 = 'session4';
  static String processKey1 = 'process1';
  static String processKey2 = 'process2';
  static String processKey3 = 'process3';
  static String processKey4 = 'process4';
  static String userKey1 = 'user1';
  static String userKey2 = 'user2';
  static String userKey3 = 'user3';
  static String userKey4 = 'user4';
  static String typeKey = 'type';
  static String timesKey = 'times';
  static String timeKey = 'time1';
  static String time2Key = 'time2';
  static String time3Key = 'time3';
  static String milli1Key = 'milli1';
  static String milli2Key = 'milli2';
  static String milli3Key = 'milli3';
  static String countDownTimeKey = 'countDownTime';
  static String usersKey = 'users';

  static String alias = '';

  static init() async {
    await GetStorage.init(storageName);
  }

  static setCountDownTime(int time){
    box.write(countDownTimeKey, time);
  }

  static getCountDownTime(){
    return box.read(countDownTimeKey) ?? 0;
  }

  static setTime1(int time){
    box.write(timeKey, time);
  }

  static getTime1(){
    return box.read(timeKey) ?? 0;
  }

  static setTime2(int time2){
    box.write(time2Key, time2);
  }

  static getTime2(){
    return box.read(time2Key) ?? 0;
  }

  static setTime3(int time2){
    box.write(time3Key, time2);
  }

  static getTime3(){
    return box.read(time3Key) ?? 0;
  }

  static setMilli1(int time2){
    box.write(milli1Key, time2);
  }

  static getMilli1(){
    return box.read(milli1Key) ?? 0;
  }

  static setMilli2(int time2){
    box.write(milli2Key, time2);
  }

  static getMilli2(){
    return box.read(milli2Key) ?? 0;
  }

  static setMilli3(int time2){
    box.write(milli3Key, time2);
  }

  static getMilli3(){
    return box.read(milli3Key) ?? 0;
  }

  static setTimes(List times){
    box.write(timesKey, times);
  }

  static getTimes(){
    return box.read(timesKey) ?? [];
  }

  static setProcesses1(Map model){
    box.write(processKey1, model);
  }

  static setProcesses2(Map model){
    box.write(processKey2, model);
  }

  static setProcesses3(Map model){
    box.write(processKey3, model);
  }

  static setProcesses4(Map model){
    box.write(processKey4, model);
  }

  static setUser1(Map model){
    box.write(userKey1, model);
  }

  static setUser2(Map model){
    box.write(userKey2, model);
  }

  static setUser3(Map model){
    box.write(userKey3, model);
  }

  static setUser4(Map model){
    box.write(userKey4, model);
  }

  static setSession1(String userSession){
    box.write(tokenKey1, userSession);
  }

  static setSession2(String userSession){
    box.write(tokenKey2, userSession);
  }

  static setSession3(String userSession){
    box.write(tokenKey3, userSession);
  }

  static setSession4(String userSession){
    box.write(tokenKey4, userSession);
  }

  static setType(bool isMobile){
    box.write(typeKey, isMobile);
  }

  static addSavedUser(UserModel user) {
    List<UserModel> savedUsers = ((box.read(usersKey) ?? []) as List).map((e) => UserModel.fromJson(e)).toList();
    List<String?> phoneNumbers = savedUsers.map((e) => e.phoneNumber).toList();
    if(!phoneNumbers.contains(user.phoneNumber)){
      savedUsers.add(user);
    }
    box.write(usersKey,savedUsers.map((e) => e.toJson()).toList());
  }

  static List<UserModel> getSavedUsers() {
    List<UserModel> savedUsers = ((box.read(usersKey) ?? []) as List).map((e) => UserModel.fromJson(e)).toList();
    return savedUsers;
  }



  static hasToken(){
    if(getSession1.isNotEmpty || getSession1.isNotEmpty || getSession1.isNotEmpty){
      return true;
    }
    return false;
  }

  static logout() async {
    await box.remove(tokenKey1);
    await box.remove(tokenKey2);
    await box.remove(tokenKey3);
    await box.remove(tokenKey4);

    await box.remove(userKey1);
    await box.remove(userKey2);
    await box.remove(userKey3);
    await box.remove(userKey4);

    await box.remove(processKey1);
    await box.remove(processKey2);
    await box.remove(processKey3);
    await box.remove(processKey4);
  }



  static String get getSession1 => box.read(tokenKey1) ?? '';
  static String get getSession2 => box.read(tokenKey2) ?? '';
  static String get getSession3 => box.read(tokenKey3) ?? '';
  static String get getSession4 => box.read(tokenKey4) ?? '';
  static String get getAlias => '';
  static bool get isMobile => box.read(typeKey) ?? false;

  static String get getUser1Id1 => getProcesses1!.pRESULT!.isNotEmpty ? getProcesses1!.pRESULT![0].pROCESSID.toString() : "";
  static String get getUser1Id2 => getProcesses1!.pRESULT!.length > 1 ? getProcesses1!.pRESULT![1].pROCESSID.toString() : "";

  static String get getUser2Id1 => getProcesses2!.pRESULT!.isNotEmpty ? getProcesses2!.pRESULT![0].pROCESSID.toString() : "";
  static String get getUser2Id2 => getProcesses2!.pRESULT!.length > 1 ? getProcesses2!.pRESULT![1].pROCESSID.toString() : "";

  static String get getUser3Id1 => getProcesses3!.pRESULT!.isNotEmpty ? getProcesses3!.pRESULT![0].pROCESSID.toString() : "";
  static String get getUser3Id2 => getProcesses3!.pRESULT!.length > 1 ? getProcesses3!.pRESULT![1].pROCESSID.toString() : "";

  static String get getUser4Id1 => getProcesses4!.pRESULT!.isNotEmpty ? getProcesses4!.pRESULT![0].pROCESSID.toString() : "";
  static String get getUser4Id2 => getProcesses4!.pRESULT!.length > 1 ? getProcesses4!.pRESULT![1].pROCESSID.toString() : "";

  static ProcessModel? get getProcesses1 {
    return ProcessModel.fromJson(box.read(processKey1));
  }

  static ProcessModel? get getProcesses2 {
    return ProcessModel.fromJson(box.read(processKey2));
  }

  static ProcessModel? get getProcesses3 {
    return ProcessModel.fromJson(box.read(processKey3));
  }

  static ProcessModel? get getProcesses4 {
    return ProcessModel.fromJson(box.read(processKey4));
  }

  static LoginModel? get getUser1 {
    return LoginModel.fromJson(box.read(userKey1));
  }

  static LoginModel? get getUser2 {
    return LoginModel.fromJson(box.read(userKey2));
  }

  static LoginModel? get getUser3 {
    return LoginModel.fromJson(box.read(userKey3));
  }

  static LoginModel? get getUser4 {
    return LoginModel.fromJson(box.read(userKey4));
  }


}


