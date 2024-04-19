import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:cash_book/screens/screeens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CashBook());
}

class CashBook extends StatelessWidget {
  const CashBook({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('az');
    return MaterialApp(
      title: 'CashBook',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
