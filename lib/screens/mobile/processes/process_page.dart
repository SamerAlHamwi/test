


import 'package:flutter/material.dart';
import 'package:king/screens/login_accounts/login_accounts.dart';
import 'package:king/screens/mobile/add_process/add_process_screen.dart';
import 'package:king/screens/mobile/processes/widgets/process_widget.dart';
import 'package:king/screens/mobile/processes/widgets/row_info_widget.dart';
import 'package:king/screens/settings/settings.dart';
import 'package:king/utils/keys.dart';

import '../../../utils/utils.dart';



class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key,this.isWithUpdate = false});

  final bool isWithUpdate;

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}


class _ProcessScreenState extends State<ProcessScreen> with AutomaticKeepAliveClientMixin {

  bool isLoadingRefresh = false;
  bool isLoadingDelete = false;


  @override
  void initState() {
    super.initState();
    getProcesses();
  }

  getProcesses() async {
    if(widget.isWithUpdate){
      await Utils.getMyProcesses(0);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 65.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(SettingsData.getSession1.isNotEmpty)
              ...List.generate(
                  SettingsData.getProcesses1!.pRECORDCOUNT!,
                      (index) => ProcessWidget(
                          model: SettingsData.getProcesses1!.pRESULT![index],
                          userIndex: 0,
                          onDelete: () async {
                            await Utils.getMyProcesses(0);
                            setState(() {});
                          })
              ),
              getDivider(),
              if(SettingsData.getSession2.isNotEmpty)
                ...List.generate(
                  SettingsData.getProcesses2!.pRECORDCOUNT!,
                      (index) => ProcessWidget(
                      model: SettingsData.getProcesses2!.pRESULT![index],
                      userIndex: 1,
                      onDelete: () async {
                        await Utils.getMyProcesses(1);
                        setState(() {});
                      })
              ),
              getDivider(),
              if(SettingsData.getSession3.isNotEmpty)
                ...List.generate(
                  SettingsData.getProcesses3!.pRECORDCOUNT!,
                      (index) => ProcessWidget(
                      model: SettingsData.getProcesses3!.pRESULT![index],
                      userIndex: 2,
                      onDelete: () async {
                        await Utils.getMyProcesses(2);
                        setState(() {});
                      })
              ),
              getDivider(),
              if(SettingsData.getSession4.isNotEmpty)
                ...List.generate(
                  SettingsData.getProcesses4!.pRECORDCOUNT!,
                      (index) => ProcessWidget(
                      model: SettingsData.getProcesses4!.pRESULT![index],
                      userIndex: 3,
                      onDelete: () async {
                        await Utils.getMyProcesses(3);
                        setState(() {});
                      })
              ),
            ]
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: '0',
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddProcessScreen()));
            },
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10,),
          FloatingActionButton(
            heroTag: '2',
            onPressed: () async {
              await Utils.getMyProcesses(0);
              // await Utils.getMyProcesses(1);
              // await Utils.getMyProcesses(2);
              // await Utils.getMyProcesses(3);
              setState(() {});
            },
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.refresh_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10,),
          FloatingActionButton(
            heroTag: '4',
            onPressed: () async {
              Navigator.pop(context);
            },
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container getDivider(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 1,
      color: Colors.black26,
    );
  }



  @override
  bool get wantKeepAlive => true;
}
