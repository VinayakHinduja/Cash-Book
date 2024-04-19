import 'package:flutter/material.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer(
      {super.key,
      required this.totalBalance,
      required this.totalIncome,
      required this.totalExpense});

  final int totalBalance;
  final int totalIncome;
  final int totalExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0xFF142850),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_circle_down_outlined,
                color: Colors.green,
              ),
              const SizedBox(height: 5),
              const Text(
                'Cash In',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '\$ $totalIncome',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_circle_up_outlined,
                color: Colors.red,
              ),
              const SizedBox(height: 5),
              const Text(
                'Cash Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '\$ $totalExpense',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              const Text(
                'Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '\$ $totalBalance',
                style: TextStyle(
                  color: totalBalance == 0
                      ? Colors.white
                      : totalBalance > 0
                          ? Colors.green
                          : Colors.red,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
