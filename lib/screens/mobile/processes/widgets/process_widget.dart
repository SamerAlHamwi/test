

import 'package:flutter/material.dart';
import 'package:king/screens/mobile/processes/widgets/row_info_widget.dart';

import '../../../../models/process_model.dart';
import '../../../../utils/utils.dart';


class ProcessWidget extends StatefulWidget {
  const ProcessWidget({super.key, required this.model, required this.userIndex, required this.onDelete});

  final PRESULT model;
  final int userIndex;
  final VoidCallback onDelete;

  @override
  State<ProcessWidget> createState() => _ProcessWidgetState();
}

class _ProcessWidgetState extends State<ProcessWidget> {

  bool isLoadingDelete = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.only(top: 16,right: 8,left: 8,bottom: 16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.black,
              spreadRadius: 0.001,
              blurRadius: 1
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          rowInfo(name: 'رقم المعاملة', data: widget.model.pROCESSNO ?? ''),
          getDivider(),
          rowInfo(name: 'نوع المعاملة', data: widget.model.zPROCESSNAME ?? ''),
          getDivider(),
          rowInfo(name: 'صاحب العلاقة', data: widget.model.pPOWNER ?? ''),
          getDivider(),
          rowInfo(name: 'مركز التسليم', data: widget.model.zCENTERNAME ?? ''),
          getDivider(),
          rowInfo(name: 'حالة المعاملة', data: widget.model.zSTATUSNAME ?? ''),
          getDivider(),
          rowInfo(name: 'ملاحظات', data: widget.model.zSTATUSNOTE ?? ''),
          getDivider(),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoadingDelete = true;
              });
              await Utils.deleteProcess(widget.model.pROCESSID!,widget.userIndex);
              widget.onDelete();
              setState(() {
                isLoadingDelete = false;
              });
            },
            child: isLoadingDelete
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
                : const Text('حذف'),
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
}
