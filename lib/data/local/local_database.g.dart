// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $CampsTable extends Camps with TableInfo<$CampsTable, CampEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CampsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, data, isSynced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'camps';
  @override
  VerificationContext validateIntegrity(
    Insertable<CampEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CampEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CampEntity(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      data:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}data'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
    );
  }

  @override
  $CampsTable createAlias(String alias) {
    return $CampsTable(attachedDatabase, alias);
  }
}

class CampEntity extends DataClass implements Insertable<CampEntity> {
  final int id;
  final String data;
  final bool isSynced;
  const CampEntity({
    required this.id,
    required this.data,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data'] = Variable<String>(data);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  CampsCompanion toCompanion(bool nullToAbsent) {
    return CampsCompanion(
      id: Value(id),
      data: Value(data),
      isSynced: Value(isSynced),
    );
  }

  factory CampEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CampEntity(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<String>(json['data']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<String>(data),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  CampEntity copyWith({int? id, String? data, bool? isSynced}) => CampEntity(
    id: id ?? this.id,
    data: data ?? this.data,
    isSynced: isSynced ?? this.isSynced,
  );
  CampEntity copyWithCompanion(CampsCompanion data) {
    return CampEntity(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CampEntity(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CampEntity &&
          other.id == this.id &&
          other.data == this.data &&
          other.isSynced == this.isSynced);
}

class CampsCompanion extends UpdateCompanion<CampEntity> {
  final Value<int> id;
  final Value<String> data;
  final Value<bool> isSynced;
  const CampsCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  CampsCompanion.insert({
    this.id = const Value.absent(),
    required String data,
    this.isSynced = const Value.absent(),
  }) : data = Value(data);
  static Insertable<CampEntity> custom({
    Expression<int>? id,
    Expression<String>? data,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  CampsCompanion copyWith({
    Value<int>? id,
    Value<String>? data,
    Value<bool>? isSynced,
  }) {
    return CampsCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CampsCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _campIdMeta = const VerificationMeta('campId');
  @override
  late final GeneratedColumn<int> campId = GeneratedColumn<int>(
    'camp_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, campId, data, isSynced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('camp_id')) {
      context.handle(
        _campIdMeta,
        campId.isAcceptableOrUnknown(data['camp_id']!, _campIdMeta),
      );
    } else if (isInserting) {
      context.missing(_campIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      campId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}camp_id'],
          )!,
      data:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}data'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  final int id;
  final int campId;
  final String data;
  final bool isSynced;
  const UserEntity({
    required this.id,
    required this.campId,
    required this.data,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['camp_id'] = Variable<int>(campId);
    map['data'] = Variable<String>(data);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      campId: Value(campId),
      data: Value(data),
      isSynced: Value(isSynced),
    );
  }

  factory UserEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<int>(json['id']),
      campId: serializer.fromJson<int>(json['campId']),
      data: serializer.fromJson<String>(json['data']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'campId': serializer.toJson<int>(campId),
      'data': serializer.toJson<String>(data),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  UserEntity copyWith({int? id, int? campId, String? data, bool? isSynced}) =>
      UserEntity(
        id: id ?? this.id,
        campId: campId ?? this.campId,
        data: data ?? this.data,
        isSynced: isSynced ?? this.isSynced,
      );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      campId: data.campId.present ? data.campId.value : this.campId,
      data: data.data.present ? data.data.value : this.data,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('campId: $campId, ')
          ..write('data: $data, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, campId, data, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.campId == this.campId &&
          other.data == this.data &&
          other.isSynced == this.isSynced);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<int> id;
  final Value<int> campId;
  final Value<String> data;
  final Value<bool> isSynced;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.campId = const Value.absent(),
    this.data = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required int campId,
    required String data,
    this.isSynced = const Value.absent(),
  }) : campId = Value(campId),
       data = Value(data);
  static Insertable<UserEntity> custom({
    Expression<int>? id,
    Expression<int>? campId,
    Expression<String>? data,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (campId != null) 'camp_id': campId,
      if (data != null) 'data': data,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<int>? campId,
    Value<String>? data,
    Value<bool>? isSynced,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      campId: campId ?? this.campId,
      data: data ?? this.data,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (campId.present) {
      map['camp_id'] = Variable<int>(campId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('campId: $campId, ')
          ..write('data: $data, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $MandalsTable extends Mandals
    with TableInfo<$MandalsTable, MandalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MandalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mandals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MandalEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  MandalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MandalEntity(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
    );
  }

  @override
  $MandalsTable createAlias(String alias) {
    return $MandalsTable(attachedDatabase, alias);
  }
}

class MandalEntity extends DataClass implements Insertable<MandalEntity> {
  final int id;
  final String name;
  const MandalEntity({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  MandalsCompanion toCompanion(bool nullToAbsent) {
    return MandalsCompanion(id: Value(id), name: Value(name));
  }

  factory MandalEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MandalEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  MandalEntity copyWith({int? id, String? name}) =>
      MandalEntity(id: id ?? this.id, name: name ?? this.name);
  MandalEntity copyWithCompanion(MandalsCompanion data) {
    return MandalEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MandalEntity(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MandalEntity && other.id == this.id && other.name == this.name);
}

class MandalsCompanion extends UpdateCompanion<MandalEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> rowid;
  const MandalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MandalsCompanion.insert({
    required int id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<MandalEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MandalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return MandalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MandalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $CampsTable camps = $CampsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $MandalsTable mandals = $MandalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [camps, users, mandals];
}

typedef $$CampsTableCreateCompanionBuilder =
    CampsCompanion Function({
      Value<int> id,
      required String data,
      Value<bool> isSynced,
    });
typedef $$CampsTableUpdateCompanionBuilder =
    CampsCompanion Function({
      Value<int> id,
      Value<String> data,
      Value<bool> isSynced,
    });

class $$CampsTableFilterComposer
    extends Composer<_$LocalDatabase, $CampsTable> {
  $$CampsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CampsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CampsTable> {
  $$CampsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CampsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CampsTable> {
  $$CampsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$CampsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CampsTable,
          CampEntity,
          $$CampsTableFilterComposer,
          $$CampsTableOrderingComposer,
          $$CampsTableAnnotationComposer,
          $$CampsTableCreateCompanionBuilder,
          $$CampsTableUpdateCompanionBuilder,
          (
            CampEntity,
            BaseReferences<_$LocalDatabase, $CampsTable, CampEntity>,
          ),
          CampEntity,
          PrefetchHooks Function()
        > {
  $$CampsTableTableManager(_$LocalDatabase db, $CampsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CampsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CampsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CampsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => CampsCompanion(id: id, data: data, isSynced: isSynced),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String data,
                Value<bool> isSynced = const Value.absent(),
              }) =>
                  CampsCompanion.insert(id: id, data: data, isSynced: isSynced),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CampsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CampsTable,
      CampEntity,
      $$CampsTableFilterComposer,
      $$CampsTableOrderingComposer,
      $$CampsTableAnnotationComposer,
      $$CampsTableCreateCompanionBuilder,
      $$CampsTableUpdateCompanionBuilder,
      (CampEntity, BaseReferences<_$LocalDatabase, $CampsTable, CampEntity>),
      CampEntity,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required int campId,
      required String data,
      Value<bool> isSynced,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<int> campId,
      Value<String> data,
      Value<bool> isSynced,
    });

class $$UsersTableFilterComposer
    extends Composer<_$LocalDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get campId => $composableBuilder(
    column: $table.campId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$LocalDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get campId => $composableBuilder(
    column: $table.campId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$LocalDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get campId =>
      $composableBuilder(column: $table.campId, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $UsersTable,
          UserEntity,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (
            UserEntity,
            BaseReferences<_$LocalDatabase, $UsersTable, UserEntity>,
          ),
          UserEntity,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$LocalDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> campId = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                campId: campId,
                data: data,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int campId,
                required String data,
                Value<bool> isSynced = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                campId: campId,
                data: data,
                isSynced: isSynced,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $UsersTable,
      UserEntity,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserEntity, BaseReferences<_$LocalDatabase, $UsersTable, UserEntity>),
      UserEntity,
      PrefetchHooks Function()
    >;
typedef $$MandalsTableCreateCompanionBuilder =
    MandalsCompanion Function({
      required int id,
      required String name,
      Value<int> rowid,
    });
typedef $$MandalsTableUpdateCompanionBuilder =
    MandalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$MandalsTableFilterComposer
    extends Composer<_$LocalDatabase, $MandalsTable> {
  $$MandalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MandalsTableOrderingComposer
    extends Composer<_$LocalDatabase, $MandalsTable> {
  $$MandalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MandalsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $MandalsTable> {
  $$MandalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$MandalsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $MandalsTable,
          MandalEntity,
          $$MandalsTableFilterComposer,
          $$MandalsTableOrderingComposer,
          $$MandalsTableAnnotationComposer,
          $$MandalsTableCreateCompanionBuilder,
          $$MandalsTableUpdateCompanionBuilder,
          (
            MandalEntity,
            BaseReferences<_$LocalDatabase, $MandalsTable, MandalEntity>,
          ),
          MandalEntity,
          PrefetchHooks Function()
        > {
  $$MandalsTableTableManager(_$LocalDatabase db, $MandalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MandalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MandalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MandalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MandalsCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required int id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => MandalsCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MandalsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $MandalsTable,
      MandalEntity,
      $$MandalsTableFilterComposer,
      $$MandalsTableOrderingComposer,
      $$MandalsTableAnnotationComposer,
      $$MandalsTableCreateCompanionBuilder,
      $$MandalsTableUpdateCompanionBuilder,
      (
        MandalEntity,
        BaseReferences<_$LocalDatabase, $MandalsTable, MandalEntity>,
      ),
      MandalEntity,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$CampsTableTableManager get camps =>
      $$CampsTableTableManager(_db, _db.camps);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$MandalsTableTableManager get mandals =>
      $$MandalsTableTableManager(_db, _db.mandals);
}
