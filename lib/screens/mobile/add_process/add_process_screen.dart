

import 'package:flutter/material.dart';
import 'package:king/screens/settings/settings.dart';
import 'package:king/utils/keys.dart';
import 'package:king/utils/utils.dart';
import 'models/add_process_model.dart';


class AddProcessScreen extends StatefulWidget {
  const AddProcessScreen({super.key});

  @override
  State<AddProcessScreen> createState() => _AddProcessScreenState();
}

class _AddProcessScreenState extends State<AddProcessScreen> {

  final TextEditingController numberController = TextEditingController();

  int? _selectedNumber;
  String? _selectedString;
  String? _userPriority;
  int? _selectedLocation;
  int? _selectedPriority;
  bool _isLoading = false;

  final List<int> _numbers = [0, 1, 2, 3];
  final List<String> _strings = ['إدارة الهجرة', 'حلب', 'دمشق'];
  final List<String> _priority = ['عادي', 'مستعجل', 'فوري'];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'اضافة معاملة'
        ),
        centerTitle: true,
      ),
      body: Overlay(
        key: Keys.overlayProcessKey,
        initialEntries: [
          OverlayEntry(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,width: width,),
                  //
                  DropdownButton<String>(
                    hint: const Text('فرع الهجرة'),
                    value: _selectedString,
                    items: _strings.map((String string) {
                      return DropdownMenuItem<String>(
                        value: string,
                        child: Text(string),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedString = newValue;
                        _selectedLocation = _strings.indexOf(newValue!);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<int>(
                    hint: const Text('عدد المرفقين'),
                    value: _selectedNumber,
                    items: _numbers.map((int number) {
                      return DropdownMenuItem<int>(
                        value: number,
                        child: Text(number.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedNumber = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    hint: const Text('أولوية جواز السفر'),
                    value: _userPriority,
                    items: _priority.map((String string) {
                      return DropdownMenuItem<String>(
                        value: string,
                        child: Text(string),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _userPriority = newValue;
                        _selectedPriority = _priority.indexOf(newValue!) + 1;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (SettingsData.getSession1.isNotEmpty && _selectedNumber != null && _selectedString != null && _selectedPriority != null) {
                      AddProcessModel model = AddProcessModel(
                        id: _selectedLocation!,
                        pMATECOUNT: _selectedNumber,
                        pPASSPORTTYPE: _selectedPriority.toString(),
                      );
                      setState(() {
                        _isLoading = true;
                      });
                      await Utils.addProcess(model.toJson(),context,0);
                      setState(() {
                        _isLoading = false;
                      });
                      }
                    },
                    child: _isLoading
                        ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Loading...'),
                      ],
                    )
                        : const Text('إضافة للحساب الأول'),

                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if(SettingsData.getSession2.isNotEmpty && _selectedNumber != null && _selectedString != null && _selectedPriority != null){
                        AddProcessModel model = AddProcessModel(
                          id: _selectedLocation!,
                          pMATECOUNT: _selectedNumber,
                          pPASSPORTTYPE: _selectedPriority.toString(),
                        );
                        setState(() {
                          _isLoading = true;
                        });
                        await Utils.addProcess(model.toJson(),context,1);
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Loading...'),
                      ],
                    )
                        : const Text('إضافة للحساب الثاني'),

                  ),const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if(SettingsData.getSession3.isNotEmpty && _selectedNumber != null && _selectedString != null && _selectedPriority != null){
                        AddProcessModel model = AddProcessModel(
                          id: _selectedLocation!,
                          pMATECOUNT: _selectedNumber,
                          pPASSPORTTYPE: _selectedPriority.toString(),
                        );
                        setState(() {
                          _isLoading = true;
                        });
                        await Utils.addProcess(model.toJson(),context,2);
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Loading...'),
                      ],
                    )
                        : const Text('إضافة للحساب الثالث'),

                  ),const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if(SettingsData.getSession4.isNotEmpty && _selectedNumber != null && _selectedString != null && _selectedPriority != null){
                        AddProcessModel model = AddProcessModel(
                          id: _selectedLocation!,
                          pMATECOUNT: _selectedNumber,
                          pPASSPORTTYPE: _selectedPriority.toString(),
                        );
                        setState(() {
                          _isLoading = true;
                        });
                        await Utils.addProcess(model.toJson(),context,3);
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Loading...'),
                      ],
                    )
                        : const Text('إضافة للحساب الرابع'),

                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
