import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kAppBarTextStyle = TextStyle(fontSize: 20);

const kAmountTextStyle = TextStyle(fontSize: 25);

const kRemarkTextStyle = TextStyle(fontSize: 23, color: Colors.white);

const kNeutralTextStyle = TextStyle(fontSize: 25, color: Colors.white);

const kCreditTextStyle = TextStyle(fontSize: 25, color: Colors.green);

const kDebitTextStyle = TextStyle(fontSize: 25, color: Color(0xFFEE6F57));

const kCashIn = TextStyle(color: Colors.green, fontSize: 20);

const kCashOut = TextStyle(color: Color(0xFFEE6F57), fontSize: 20);

const kEditEntry =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20);

const kRoundedButtonTextStyle = TextStyle(color: Colors.white, fontSize: 20);

const kDeleteButtonTextStyle = TextStyle(color: Colors.white, fontSize: 20);

const kInputTextStyle = TextStyle(fontSize: 25, color: Colors.white);

const kAmountTextFieldDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(color: Colors.red, width: 3),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(width: 0, color: Colors.grey),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(width: 0),
  ),
  filled: true,
  fillColor: Color(0xFF3b6fa5),
);

const kRemarkTextFieldDecoration = InputDecoration(
  hintText: 'Remark',
  hintStyle: kRemarkTextStyle,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(color: Colors.red, width: 3),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(width: 0, color: Colors.grey),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(width: 0),
  ),
  filled: true,
  fillColor: Color(0xFF3b6fa5),
);

Future<void> kFlutterToast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    timeInSecForIosWeb: 1,
  );
}

Future<void> kShowDeleteDialog(context, Function() onTap) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('Delete', textAlign: TextAlign.center)),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        content: const Text(
          'Are you sure you want to delete this task',
          textAlign: TextAlign.center,
        ),
        contentTextStyle: const TextStyle(fontSize: 20.0, color: Colors.grey),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                  height: 25.0,
                  width: 2.0,
                  child: Container(color: Colors.grey)),
              TextButton(
                onPressed: onTap,
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> showMyDatePicker({
  required BuildContext ctx,
  required void Function(DateTime) onDateTimeChanged,
  required DateTime? initialdate,
}) async {
  showDialog(
    context: ctx,
    builder: (c) => AlertDialog(
      backgroundColor: const Color(0xFF27496D),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.access_time_rounded), Text('    Pick a Date')],
      ),
      contentPadding: const EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(c).size.height * 0.25,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                initialDateTime: initialdate,
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: onDateTimeChanged,
              ),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
