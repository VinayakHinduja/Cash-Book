import 'package:flutter/material.dart';
import '../components/constance.dart';

Future showDeleteDialogue(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: Icon(
            Icons.delete_outline_outlined,
            size: 50,
          ),
          //Text('Delete', textAlign: TextAlign.center),
        ),
        titleTextStyle: const TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        content: const Text('Are you sure you want to delete this Entry ?',
            textAlign: TextAlign.center),
        contentTextStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 25.0,
                width: 2.0,
                child: Container(color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  kFlutterToast("The Entry has been deleted");
                  Navigator.pop(context, true);
                },
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
