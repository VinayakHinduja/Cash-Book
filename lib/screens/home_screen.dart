import 'package:flutter/material.dart';

import 'package:cash_book/components/components.dart';
import 'package:cash_book/crud/crud.dart';
import 'package:cash_book/widgets/widget.dart';
import 'package:cash_book/screens/screeens.dart';

// import 'dart:developer' as devtools show log;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(milliseconds: 500);
    controller.reverseDuration = const Duration(milliseconds: 1000);
    Tween<double>(begin: 1, end: 0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: EntryService().allEntries,
      builder: (ctx1, entriesSnap) {
        switch (entriesSnap.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return StreamBuilder(
              stream: CashBook().getBalance,
              builder: (ctx2, balanceSnap) {
                switch (balanceSnap.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    List<DatabaseEntry> entries = [];
                    if (entriesSnap.hasData) {
                      entries = entriesSnap.data as List<DatabaseEntry>;
                    }
                    int totalBalance = 0;
                    entries.sort(
                      (a, b) {
                        return DateTime.fromMillisecondsSinceEpoch(a.rwTime)
                            .compareTo(
                                DateTime.fromMillisecondsSinceEpoch(b.rwTime));
                      },
                    );
                    Widget body = entriesSnap.hasData
                        ? entries.isEmpty
                            ? const Center(
                                child: Text(
                                    'You have not entered any entries yet !!'))
                            : ListView.builder(
                                itemCount: entries.length,
                                itemBuilder: (ctx, i) {
                                  if (entries[i].type == EntryType.cashIn) {
                                    totalBalance += entries[i].amount;
                                  } else {
                                    totalBalance -= entries[i].amount;
                                  }
                                  return AccountCard(
                                    id: entries[i].id,
                                    amount: entries[i].amount,
                                    remark: entries[i].remark,
                                    type: entries[i].type,
                                    dateAndTime: entries[i].time,
                                    balance: totalBalance,
                                    onTap: () => showModalBottomSheet(
                                      context: ctx,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (ctx) => CashEditCard(
                                        id: entries[i].id.toString(),
                                        oldAmount: entries[i].amount,
                                        oldRemark: entries[i].remark,
                                        oldTime: entries[i].time,
                                        oldType: entries[i].type,
                                        oldrwTime: entries[i].rwTime,
                                      ),
                                    ).whenComplete(() => setState(() {})),
                                  );
                                },
                              )
                        : const Center(child: CircularProgressIndicator());

                    Widget bottom = balanceSnap.data!.isNotEmpty
                        ? BottomContainer(
                            totalBalance: balanceSnap.data![0],
                            totalIncome: balanceSnap.data![1],
                            totalExpense: balanceSnap.data![2],
                          )
                        : const Center(child: CircularProgressIndicator());

                    return Scaffold(
                      backgroundColor: const Color(0xFF222831),
                      appBar: AppBar(
                        toolbarHeight: 200,
                        flexibleSpace: Container(
                          color: const Color(0xFF142850),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 45,
                                  left: 15,
                                  bottom: 10,
                                ),
                                child: Text(
                                  'Cash Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  bottom: 15,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    RoundedButton(
                                      text: 'CASH IN',
                                      color: Colors.green,
                                      style: kRoundedButtonTextStyle,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => const CashCard(
                                            text: 'Cash In',
                                            style: kCashIn,
                                          ),
                                        ).whenComplete(() => setState(() {}));
                                      },
                                    ),
                                    const SizedBox(width: 15),
                                    RoundedButton(
                                      text: 'CASH OUT',
                                      style: kRoundedButtonTextStyle,
                                      color: Colors.redAccent.shade400,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => const CashCard(
                                            text: 'Cash Out',
                                            style: kCashOut,
                                          ),
                                        ).whenComplete(() => setState(() {}));
                                      },
                                    )
                                  ],
                                ),
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 25),
                                      child: Text('Date/Remark',
                                          style: kAppBarTextStyle),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text('Cr/Dr',
                                          style: kAppBarTextStyle)),
                                  Expanded(
                                      child: Text('Balance',
                                          style: kAppBarTextStyle)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: body,
                      bottomNavigationBar: bottom,
                    );
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
