import 'package:flutter/material.dart';

import 'package:cash_book/components/components.dart';
import 'package:cash_book/crud/crud.dart';
import 'package:cash_book/widgets/widget.dart';

class CashEditCard extends StatefulWidget {
  const CashEditCard({
    super.key,
    required this.oldAmount,
    required this.oldRemark,
    required this.oldTime,
    required this.oldType,
    required this.oldrwTime,
    required this.id,
  });

  final int oldAmount;
  final String oldRemark;
  final String oldTime;
  final EntryType oldType;
  final int oldrwTime;
  final String id;

  @override
  State<CashEditCard> createState() => _CashEditCardState();
}

class _CashEditCardState extends State<CashEditCard> {
  final formKey = GlobalKey<FormState>();

  int? newRwTime;
  String? newTime;
  EntryType? newType;
  DatabaseEntry? editableEntry;
  bool valid = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      newRwTime = widget.oldrwTime;
      newTime = widget.oldTime;
      newType = widget.oldType;
      editableEntry = DatabaseEntry(
        time: '',
        amount: 0,
        id: int.parse(widget.id),
        remark: '',
        type: widget.oldType,
        rwTime: 0,
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // Future<void> showMyDatePicker(BuildContext ctx) async {
  //   showDialog(
  //     context: ctx,
  //     builder: (c) => AlertDialog(
  //       backgroundColor: const Color(0xFF27496D),
  //       title: const Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [Icon(Icons.access_time_rounded), Text('    Pick a Date')],
  //       ),
  //       contentPadding: const EdgeInsets.all(10),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           SizedBox(
  //             height: MediaQuery.of(c).size.height * 0.25,
  //             child: CupertinoTheme(
  //               data: const CupertinoThemeData(
  //                 textTheme: CupertinoTextThemeData(
  //                   dateTimePickerTextStyle: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),
  //               child: CupertinoDatePicker(
  //                 initialDateTime: DateTime.tryParse(widget.oldTime),
  //                 mode: CupertinoDatePickerMode.dateAndTime,
  //                 onDateTimeChanged: (DateTime newDate) {
  //                   setState(() {
  //                     newTime = Time.getFormatted(newDate);
  //                     newRwTime = newDate.millisecondsSinceEpoch;
  //                   });
  //                 },
  //               ),
  //             ),
  //           ),
  //           CupertinoButton(
  //             padding: const EdgeInsets.all(0),
  //             onPressed: () => Navigator.pop(ctx),
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 43),
            child: Container(
              height: mq.size.width >= 400
                  ? mq.size.height * 0.6
                  : mq.size.height * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF27496D),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: SizedBox(
                            child: FittedBox(
                              child: Text('Edit Entry', style: kEditEntry),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async => await showMyDatePicker(
                              ctx: context,
                              initialdate: DateTime.tryParse(widget.oldTime),
                              onDateTimeChanged: (D) => setState(() {
                                newTime = Time.getFormatted(D);
                                newRwTime = D.millisecondsSinceEpoch;
                              }),
                            ),
                            child: Container(
                              width: mq.size.width * 0.56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3b6fa5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_month, size: 22),
                                  const SizedBox(width: 10),
                                  FittedBox(
                                    child: Text(
                                      newTime!,
                                      style: TextStyle(
                                        fontSize:
                                            mq.size.width >= 400 ? 16 : 11,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        child: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text('Amount', style: kAmountTextStyle),
                    TextFormField(
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Enter some amount';
                        }
                        if (int.tryParse(v) == null) {
                          return 'Enter a number';
                        }
                        return null;
                      },
                      onSaved: (v) {
                        editableEntry = DatabaseEntry(
                          time: editableEntry!.time,
                          amount: int.parse(v!),
                          id: editableEntry!.id,
                          remark: editableEntry!.remark,
                          type: editableEntry!.type,
                          rwTime: editableEntry!.rwTime,
                        );
                      },
                      initialValue: widget.oldAmount.toString(),
                      style: kInputTextStyle,
                      autofocus: true,
                      decoration: kAmountTextFieldDecoration,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Entere some remark';
                        }
                        return null;
                      },
                      onSaved: (v) {
                        editableEntry = DatabaseEntry(
                          id: editableEntry!.id,
                          amount: editableEntry!.amount,
                          remark: v!,
                          type: editableEntry!.type,
                          time: editableEntry!.time,
                          rwTime: editableEntry!.rwTime,
                        );
                      },
                      maxLines: 4,
                      style: kInputTextStyle,
                      initialValue: widget.oldRemark,
                      decoration: kRemarkTextFieldDecoration,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3b6fa5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ChoiceChip(
                            label: Text(
                              'Cash In',
                              style: TextStyle(
                                fontSize: 20,
                                color: newType == EntryType.cashIn
                                    ? Colors.white
                                    : Colors.grey[300],
                              ),
                            ),
                            disabledColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.all(5),
                            selected:
                                newType == EntryType.cashIn ? true : false,
                            selectedColor: Colors.green,
                            onSelected: (val) {
                              if (val) {
                                setState(() => newType = EntryType.cashIn);
                              }
                            },
                          ),
                          const SizedBox(width: 15.0),
                          ChoiceChip(
                            label: Text(
                              'Cash Out',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: newType == EntryType.cashOut
                                    ? Colors.white
                                    : Colors.grey[300],
                              ),
                            ),
                            disabledColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.all(5),
                            selected:
                                newType == EntryType.cashOut ? true : false,
                            selectedColor: Colors.redAccent[700],
                            onSelected: (val) {
                              if (val) {
                                setState(() => newType = EntryType.cashOut);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RoundedButton(
                            text: 'CANCEL',
                            splashColor: Colors.blueGrey,
                            style: kDeleteButtonTextStyle,
                            color: Colors.blueGrey.shade400,
                            onPressed: () => Navigator.pop(context),
                          ),
                          RoundedButton(
                            text: 'UPDATE',
                            style: kRoundedButtonTextStyle,
                            color: Colors.blue,
                            onPressed: () async {
                              valid = formKey.currentState!.validate();
                              if (!valid) return;
                              formKey.currentState!.save();
                              await EntryService()
                                  .updateEntry(
                                    id: int.parse(widget.id),
                                    amount: editableEntry!.amount,
                                    remark: editableEntry!.remark,
                                    type: newType!.name,
                                    time: newTime!,
                                    rwTime: newRwTime!,
                                  )
                                  .whenComplete(() => Navigator.pop(context));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
