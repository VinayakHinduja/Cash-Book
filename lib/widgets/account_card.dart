import 'package:cash_book/dialogue/delete_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:cash_book/components/components.dart';
import 'package:cash_book/crud/crud.dart';

// import 'dart:developer' as devtools show log;

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.id,
    required this.amount,
    required this.remark,
    required this.balance,
    required this.dateAndTime,
    required this.type,
    required this.onTap,
  });

  final int amount;
  final int balance;
  final String remark;
  final int id;
  final String dateAndTime;
  final EntryType type;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15),
          margin: const EdgeInsets.only(top: 15),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (d) async => await showDeleteDialogue(context),
        onDismissed: (d) async => await EntryService().deleteNote(id: id),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            right: 5,
            left: 5,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF27496D),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            dateAndTime,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Text(
                          remark,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kRemarkTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '$amount',
                    style: type == EntryType.cashIn
                        ? kCreditTextStyle
                        : kDebitTextStyle,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    // '2000',
                    balance.toString(),
                    style: balance == 0
                        ? kNeutralTextStyle
                        : balance > 0
                            ? kCreditTextStyle
                            : kDebitTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
