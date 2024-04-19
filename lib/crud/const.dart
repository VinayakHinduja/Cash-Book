const dbName = 'entry.db';
const cashTable = 'cash';
const idColumn = 'id';
const amountColumn = 'amount';
const remarkColumn = 'remark';
const timeColumn = 'time';
const rwTimeColumn = 'rwTime';
const typeColumn = 'type';
const createCashTable = '''CREATE TABLE IF NOT EXISTS "cash" (
	"id"	INTEGER NOT NULL,
	"amount"	INTEGER NOT NULL,
	"remark"	TEXT NOT NULL,
	"time"	TEXT NOT NULL,
	"type"	TEXT NOT NULL,
	"rwTime"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
