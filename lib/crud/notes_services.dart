import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:cash_book/crud/crud.dart';

class EntryService {
  Database? _db;

  List<DatabaseEntry> _entry = [];

  static final EntryService _shared = EntryService._sharedInstance();
  factory EntryService() => _shared;

  late final StreamController<List<DatabaseEntry>> _notesStreamController;
  Stream<List<DatabaseEntry>> get allEntries => _notesStreamController.stream;

  EntryService._sharedInstance() {
    _ensureDbIsOpen();
    _notesStreamController =
        StreamController<List<DatabaseEntry>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_entry);
    });
  }

  Future<void> _cacheNotes() async {
    final allEntries = await getAllEntries();
    _entry = allEntries.toList();
    _notesStreamController.add(_entry);
    await CashBook().getBalances();
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
      // ignore: empty_catches
    } on DatabaseAlreadyOpen {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpen();
    }
    try {
      final docPath = await getExternalStorageDirectory();
      final dbPath = p.join(docPath!.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createCashTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<DatabaseEntry> createEntry({
    required String remark,
    required int amount,
    required String type,
    required String time,
    required int rwTime,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final entry = await db.insert(cashTable, {
      typeColumn: type,
      remarkColumn: remark,
      amountColumn: amount,
      timeColumn: time,
      rwTimeColumn: rwTime,
    });
    devtools.log(entry.toString());

    final enter = DatabaseEntry(
      id: entry,
      remark: remark,
      type: type == 'cashIn' ? EntryType.cashIn : EntryType.cashOut,
      time: time,
      amount: amount,
      rwTime: rwTime,
    );

    _entry.add(enter);
    _notesStreamController.add(_entry);
    devtools.log(enter.toString());
    await CashBook().getBalances();
    return enter;
  }

  Future<DatabaseEntry> getEntry({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final entries =
        await db.query(cashTable, limit: 1, where: 'id = ?', whereArgs: [id]);
    if (entries.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final entry = DatabaseEntry.fromRow(entries.first);
      _entry.removeWhere((entry) => entry.id == id);
      _entry.add(entry);
      _notesStreamController.add(_entry);
      return entry;
    }
  }

  Future<List<DatabaseEntry>> getAllEntries() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(cashTable);
    return notes.map((noteRow) => DatabaseEntry.fromRow(noteRow)).toList();
  }

  Future<DatabaseEntry> updateEntry({
    required int id,
    required int amount,
    required String remark,
    required String type,
    required String time,
    required int rwTime,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure note exist
    await getEntry(id: id);

    // update db
    final updateCount = await db.update(
      cashTable,
      {
        typeColumn: type,
        remarkColumn: remark,
        amountColumn: amount,
        timeColumn: time,
        rwTimeColumn: rwTime,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedEntry = await getEntry(id: id);
      devtools.log(updatedEntry.toString());
      _entry.removeWhere((entry) => entry.id == updatedEntry.id);
      _entry.add(updatedEntry);
      _notesStreamController.add(_entry);
      await CashBook().getBalances();
      return updatedEntry;
    }
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount =
        await db.delete(cashTable, where: 'id = ?', whereArgs: [id]);
    if (deleteCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _entry.removeWhere((entry) => entry.id == id);
      _notesStreamController.add(_entry);
      await CashBook().getBalances();
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(cashTable);
    _entry = [];
    _notesStreamController.add(_entry);
    await CashBook().getBalances();
    return numberOfDeletions;
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}

class CashBook {
  final List<int> _balances = [];

  static final CashBook _shared = CashBook._sharedInstance();
  factory CashBook() => _shared;

  late final StreamController<List<int>> _balanceController;
  Stream<List<int>> get getBalance => _balanceController.stream;

  CashBook._sharedInstance() {
    _balanceController = StreamController<List<int>>.broadcast(onListen: () {
      _balanceController.sink.add(_balances);
    });
  }

  Future getBalances() async {
    int totalBalance = 0;
    int totalIncome = 0;
    int totalExpense = 0;
    final entries = await EntryService().getAllEntries();
    for (DatabaseEntry i in entries) {
      if (i.type == EntryType.cashIn) {
        totalBalance += i.amount;
        totalIncome += i.amount;
      } else if (i.type == EntryType.cashOut) {
        totalBalance -= i.amount;
        totalExpense += i.amount;
      }
    }

    _balances.clear();
    _balances.addAll([totalBalance, totalIncome, totalExpense]);

    _balanceController.add(_balances);
  }
}
