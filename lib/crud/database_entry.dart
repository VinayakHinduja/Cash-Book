import 'const.dart';

class DatabaseEntry {
  final int id;
  final String remark;
  final int amount;
  final EntryType type;
  final String time;
  final int rwTime;

  const DatabaseEntry({
    required this.time,
    required this.amount,
    required this.id,
    required this.remark,
    required this.type,
    required this.rwTime,
  });

  DatabaseEntry.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        amount = map[amountColumn] as int,
        time = map[timeColumn] as String,
        remark = map[remarkColumn] as String,
        rwTime = map[rwTimeColumn] as int,
        type =
            map[typeColumn] == "cashIn" ? EntryType.cashIn : EntryType.cashOut;

  @override
  String toString() =>
      'ID = $id, type = ${type.name}, amount = $amount, time = $time, remark = $remark, rawTime = $rwTime';

  @override
  bool operator ==(covariant DatabaseEntry other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum EntryType { cashIn, cashOut }
