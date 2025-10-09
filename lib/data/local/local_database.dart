import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

@DataClassName('CampEntity')
class Camps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text()(); // JSON string of camp details
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DataClassName('UserEntity')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get campId => integer()();
  TextColumn get data => text()(); // JSON string of user data
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DataClassName('MandalEntity')
class Mandals extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}

@DriftDatabase(tables: [Camps, Users, Mandals])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // insert records
  Future<int> insertCamp(Map<String, dynamic> data) =>
      into(camps).insert(CampsCompanion.insert(data: jsonEncode(data)));

  Future<int> insertUser(int campId, Map<String, dynamic> data) => into(
    users,
  ).insert(UsersCompanion.insert(campId: campId, data: jsonEncode(data)));

  Future<int> insertMandal(int id, name) =>
      into(mandals).insert(MandalsCompanion.insert(id: id, name: name));

  Future<void> insertmandals(List<MandalEntity> mandalList) async {
    await batch((batch) {
      batch.insertAll(
        mandals,
        mandalList
            .map(
              (data) =>
                  MandalsCompanion(id: Value(data.id), name: Value(data.name)),
            )
            .toList(),
      );
    });
  }

  // get unsynced
  Future<List<CampEntity>> getUnsyncedCamps() =>
      (select(camps)..where((tbl) => tbl.isSynced.equals(false))).get();

  Future<List<UserEntity>> getUnsyncedUsers() =>
      (select(users)..where((tbl) => tbl.isSynced.equals(false))).get();

  Future<List<MandalEntity>> getMandals() => select(mandals).get();

  // mark synced
  Future<void> markCampSynced(int id) async {
    await (update(camps)..where(
      (tbl) => tbl.id.equals(id),
    )).write(CampsCompanion(isSynced: Value(true)));
  }

  Future<void> markUserSynced(int id) async {
    await (update(users)..where(
      (tbl) => tbl.id.equals(id),
    )).write(UsersCompanion(isSynced: Value(true)));
  }

  // ✅ Delete methods
  Future<int> deleteCamp(int id) async {
    return await (delete(camps)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteUser(int id) async {
    return await (delete(users)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteUserByCamp(int campId) async {
    return await (delete(users)
      ..where((tbl) => tbl.campId.equals(campId))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'ihs_data.sqlite'));
    return NativeDatabase(file);
  });
}
