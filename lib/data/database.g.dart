// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CargosTable extends Cargos with TableInfo<$CargosTable, CargoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CargosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeCargoMeta = const VerificationMeta(
    'nomeCargo',
  );
  @override
  late final GeneratedColumn<String> nomeCargo = GeneratedColumn<String>(
    'nome_cargo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nomeCargo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cargos';
  @override
  VerificationContext validateIntegrity(
    Insertable<CargoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome_cargo')) {
      context.handle(
        _nomeCargoMeta,
        nomeCargo.isAcceptableOrUnknown(data['nome_cargo']!, _nomeCargoMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeCargoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CargoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CargoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomeCargo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_cargo'],
      )!,
    );
  }

  @override
  $CargosTable createAlias(String alias) {
    return $CargosTable(attachedDatabase, alias);
  }
}

class CargoData extends DataClass implements Insertable<CargoData> {
  final int id;
  final String nomeCargo;
  const CargoData({required this.id, required this.nomeCargo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome_cargo'] = Variable<String>(nomeCargo);
    return map;
  }

  CargosCompanion toCompanion(bool nullToAbsent) {
    return CargosCompanion(id: Value(id), nomeCargo: Value(nomeCargo));
  }

  factory CargoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CargoData(
      id: serializer.fromJson<int>(json['id']),
      nomeCargo: serializer.fromJson<String>(json['nomeCargo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomeCargo': serializer.toJson<String>(nomeCargo),
    };
  }

  CargoData copyWith({int? id, String? nomeCargo}) =>
      CargoData(id: id ?? this.id, nomeCargo: nomeCargo ?? this.nomeCargo);
  CargoData copyWithCompanion(CargosCompanion data) {
    return CargoData(
      id: data.id.present ? data.id.value : this.id,
      nomeCargo: data.nomeCargo.present ? data.nomeCargo.value : this.nomeCargo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CargoData(')
          ..write('id: $id, ')
          ..write('nomeCargo: $nomeCargo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nomeCargo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CargoData &&
          other.id == this.id &&
          other.nomeCargo == this.nomeCargo);
}

class CargosCompanion extends UpdateCompanion<CargoData> {
  final Value<int> id;
  final Value<String> nomeCargo;
  const CargosCompanion({
    this.id = const Value.absent(),
    this.nomeCargo = const Value.absent(),
  });
  CargosCompanion.insert({
    this.id = const Value.absent(),
    required String nomeCargo,
  }) : nomeCargo = Value(nomeCargo);
  static Insertable<CargoData> custom({
    Expression<int>? id,
    Expression<String>? nomeCargo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomeCargo != null) 'nome_cargo': nomeCargo,
    });
  }

  CargosCompanion copyWith({Value<int>? id, Value<String>? nomeCargo}) {
    return CargosCompanion(
      id: id ?? this.id,
      nomeCargo: nomeCargo ?? this.nomeCargo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomeCargo.present) {
      map['nome_cargo'] = Variable<String>(nomeCargo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CargosCompanion(')
          ..write('id: $id, ')
          ..write('nomeCargo: $nomeCargo')
          ..write(')'))
        .toString();
  }
}

class $TiposDispositivoTable extends TiposDispositivo
    with TableInfo<$TiposDispositivoTable, TipoDispositivoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TiposDispositivoTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeTipoMeta = const VerificationMeta(
    'nomeTipo',
  );
  @override
  late final GeneratedColumn<String> nomeTipo = GeneratedColumn<String>(
    'nome_tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nomeTipo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipos_dispositivo';
  @override
  VerificationContext validateIntegrity(
    Insertable<TipoDispositivoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome_tipo')) {
      context.handle(
        _nomeTipoMeta,
        nomeTipo.isAcceptableOrUnknown(data['nome_tipo']!, _nomeTipoMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeTipoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TipoDispositivoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TipoDispositivoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomeTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_tipo'],
      )!,
    );
  }

  @override
  $TiposDispositivoTable createAlias(String alias) {
    return $TiposDispositivoTable(attachedDatabase, alias);
  }
}

class TipoDispositivoData extends DataClass
    implements Insertable<TipoDispositivoData> {
  final int id;
  final String nomeTipo;
  const TipoDispositivoData({required this.id, required this.nomeTipo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome_tipo'] = Variable<String>(nomeTipo);
    return map;
  }

  TiposDispositivoCompanion toCompanion(bool nullToAbsent) {
    return TiposDispositivoCompanion(id: Value(id), nomeTipo: Value(nomeTipo));
  }

  factory TipoDispositivoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TipoDispositivoData(
      id: serializer.fromJson<int>(json['id']),
      nomeTipo: serializer.fromJson<String>(json['nomeTipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomeTipo': serializer.toJson<String>(nomeTipo),
    };
  }

  TipoDispositivoData copyWith({int? id, String? nomeTipo}) =>
      TipoDispositivoData(
        id: id ?? this.id,
        nomeTipo: nomeTipo ?? this.nomeTipo,
      );
  TipoDispositivoData copyWithCompanion(TiposDispositivoCompanion data) {
    return TipoDispositivoData(
      id: data.id.present ? data.id.value : this.id,
      nomeTipo: data.nomeTipo.present ? data.nomeTipo.value : this.nomeTipo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TipoDispositivoData(')
          ..write('id: $id, ')
          ..write('nomeTipo: $nomeTipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nomeTipo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TipoDispositivoData &&
          other.id == this.id &&
          other.nomeTipo == this.nomeTipo);
}

class TiposDispositivoCompanion extends UpdateCompanion<TipoDispositivoData> {
  final Value<int> id;
  final Value<String> nomeTipo;
  const TiposDispositivoCompanion({
    this.id = const Value.absent(),
    this.nomeTipo = const Value.absent(),
  });
  TiposDispositivoCompanion.insert({
    this.id = const Value.absent(),
    required String nomeTipo,
  }) : nomeTipo = Value(nomeTipo);
  static Insertable<TipoDispositivoData> custom({
    Expression<int>? id,
    Expression<String>? nomeTipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomeTipo != null) 'nome_tipo': nomeTipo,
    });
  }

  TiposDispositivoCompanion copyWith({
    Value<int>? id,
    Value<String>? nomeTipo,
  }) {
    return TiposDispositivoCompanion(
      id: id ?? this.id,
      nomeTipo: nomeTipo ?? this.nomeTipo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomeTipo.present) {
      map['nome_tipo'] = Variable<String>(nomeTipo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TiposDispositivoCompanion(')
          ..write('id: $id, ')
          ..write('nomeTipo: $nomeTipo')
          ..write(')'))
        .toString();
  }
}

class $EmprestimoStatusTable extends EmprestimoStatus
    with TableInfo<$EmprestimoStatusTable, EmprestimoStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmprestimoStatusTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeStatusMeta = const VerificationMeta(
    'nomeStatus',
  );
  @override
  late final GeneratedColumn<String> nomeStatus = GeneratedColumn<String>(
    'nome_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nomeStatus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emprestimo_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmprestimoStatusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome_status')) {
      context.handle(
        _nomeStatusMeta,
        nomeStatus.isAcceptableOrUnknown(data['nome_status']!, _nomeStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmprestimoStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmprestimoStatusData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomeStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_status'],
      )!,
    );
  }

  @override
  $EmprestimoStatusTable createAlias(String alias) {
    return $EmprestimoStatusTable(attachedDatabase, alias);
  }
}

class EmprestimoStatusData extends DataClass
    implements Insertable<EmprestimoStatusData> {
  final int id;
  final String nomeStatus;
  const EmprestimoStatusData({required this.id, required this.nomeStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome_status'] = Variable<String>(nomeStatus);
    return map;
  }

  EmprestimoStatusCompanion toCompanion(bool nullToAbsent) {
    return EmprestimoStatusCompanion(
      id: Value(id),
      nomeStatus: Value(nomeStatus),
    );
  }

  factory EmprestimoStatusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmprestimoStatusData(
      id: serializer.fromJson<int>(json['id']),
      nomeStatus: serializer.fromJson<String>(json['nomeStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomeStatus': serializer.toJson<String>(nomeStatus),
    };
  }

  EmprestimoStatusData copyWith({int? id, String? nomeStatus}) =>
      EmprestimoStatusData(
        id: id ?? this.id,
        nomeStatus: nomeStatus ?? this.nomeStatus,
      );
  EmprestimoStatusData copyWithCompanion(EmprestimoStatusCompanion data) {
    return EmprestimoStatusData(
      id: data.id.present ? data.id.value : this.id,
      nomeStatus: data.nomeStatus.present
          ? data.nomeStatus.value
          : this.nomeStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoStatusData(')
          ..write('id: $id, ')
          ..write('nomeStatus: $nomeStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nomeStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmprestimoStatusData &&
          other.id == this.id &&
          other.nomeStatus == this.nomeStatus);
}

class EmprestimoStatusCompanion extends UpdateCompanion<EmprestimoStatusData> {
  final Value<int> id;
  final Value<String> nomeStatus;
  const EmprestimoStatusCompanion({
    this.id = const Value.absent(),
    this.nomeStatus = const Value.absent(),
  });
  EmprestimoStatusCompanion.insert({
    this.id = const Value.absent(),
    required String nomeStatus,
  }) : nomeStatus = Value(nomeStatus);
  static Insertable<EmprestimoStatusData> custom({
    Expression<int>? id,
    Expression<String>? nomeStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomeStatus != null) 'nome_status': nomeStatus,
    });
  }

  EmprestimoStatusCompanion copyWith({
    Value<int>? id,
    Value<String>? nomeStatus,
  }) {
    return EmprestimoStatusCompanion(
      id: id ?? this.id,
      nomeStatus: nomeStatus ?? this.nomeStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomeStatus.present) {
      map['nome_status'] = Variable<String>(nomeStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoStatusCompanion(')
          ..write('id: $id, ')
          ..write('nomeStatus: $nomeStatus')
          ..write(')'))
        .toString();
  }
}

class $DispositivosTable extends Dispositivos
    with TableInfo<$DispositivosTable, DispositivoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DispositivosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _numSerieMeta = const VerificationMeta(
    'numSerie',
  );
  @override
  late final GeneratedColumn<int> numSerie = GeneratedColumn<int>(
    'num_serie',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numPatrimonioMeta = const VerificationMeta(
    'numPatrimonio',
  );
  @override
  late final GeneratedColumn<int> numPatrimonio = GeneratedColumn<int>(
    'num_patrimonio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idTipoDispositivoMeta = const VerificationMeta(
    'idTipoDispositivo',
  );
  @override
  late final GeneratedColumn<int> idTipoDispositivo = GeneratedColumn<int>(
    'id_tipo_dispositivo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tipos_dispositivo (id)',
    ),
  );
  static const VerificationMeta _idStatusMeta = const VerificationMeta(
    'idStatus',
  );
  @override
  late final GeneratedColumn<int> idStatus = GeneratedColumn<int>(
    'id_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES emprestimo_status (id)',
    ),
  );
  static const VerificationMeta _qtdTotalMeta = const VerificationMeta(
    'qtdTotal',
  );
  @override
  late final GeneratedColumn<int> qtdTotal = GeneratedColumn<int>(
    'qtd_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtdDisponivelMeta = const VerificationMeta(
    'qtdDisponivel',
  );
  @override
  late final GeneratedColumn<int> qtdDisponivel = GeneratedColumn<int>(
    'qtd_disponivel',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    numSerie,
    numPatrimonio,
    idTipoDispositivo,
    idStatus,
    qtdTotal,
    qtdDisponivel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dispositivos';
  @override
  VerificationContext validateIntegrity(
    Insertable<DispositivoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('num_serie')) {
      context.handle(
        _numSerieMeta,
        numSerie.isAcceptableOrUnknown(data['num_serie']!, _numSerieMeta),
      );
    } else if (isInserting) {
      context.missing(_numSerieMeta);
    }
    if (data.containsKey('num_patrimonio')) {
      context.handle(
        _numPatrimonioMeta,
        numPatrimonio.isAcceptableOrUnknown(
          data['num_patrimonio']!,
          _numPatrimonioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numPatrimonioMeta);
    }
    if (data.containsKey('id_tipo_dispositivo')) {
      context.handle(
        _idTipoDispositivoMeta,
        idTipoDispositivo.isAcceptableOrUnknown(
          data['id_tipo_dispositivo']!,
          _idTipoDispositivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idTipoDispositivoMeta);
    }
    if (data.containsKey('id_status')) {
      context.handle(
        _idStatusMeta,
        idStatus.isAcceptableOrUnknown(data['id_status']!, _idStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_idStatusMeta);
    }
    if (data.containsKey('qtd_total')) {
      context.handle(
        _qtdTotalMeta,
        qtdTotal.isAcceptableOrUnknown(data['qtd_total']!, _qtdTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_qtdTotalMeta);
    }
    if (data.containsKey('qtd_disponivel')) {
      context.handle(
        _qtdDisponivelMeta,
        qtdDisponivel.isAcceptableOrUnknown(
          data['qtd_disponivel']!,
          _qtdDisponivelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_qtdDisponivelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DispositivoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DispositivoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      numSerie: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_serie'],
      )!,
      numPatrimonio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_patrimonio'],
      )!,
      idTipoDispositivo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_tipo_dispositivo'],
      )!,
      idStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_status'],
      )!,
      qtdTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qtd_total'],
      )!,
      qtdDisponivel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qtd_disponivel'],
      )!,
    );
  }

  @override
  $DispositivosTable createAlias(String alias) {
    return $DispositivosTable(attachedDatabase, alias);
  }
}

class DispositivoData extends DataClass implements Insertable<DispositivoData> {
  final int id;
  final int numSerie;
  final int numPatrimonio;
  final int idTipoDispositivo;
  final int idStatus;
  final int qtdTotal;
  final int qtdDisponivel;
  const DispositivoData({
    required this.id,
    required this.numSerie,
    required this.numPatrimonio,
    required this.idTipoDispositivo,
    required this.idStatus,
    required this.qtdTotal,
    required this.qtdDisponivel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['num_serie'] = Variable<int>(numSerie);
    map['num_patrimonio'] = Variable<int>(numPatrimonio);
    map['id_tipo_dispositivo'] = Variable<int>(idTipoDispositivo);
    map['id_status'] = Variable<int>(idStatus);
    map['qtd_total'] = Variable<int>(qtdTotal);
    map['qtd_disponivel'] = Variable<int>(qtdDisponivel);
    return map;
  }

  DispositivosCompanion toCompanion(bool nullToAbsent) {
    return DispositivosCompanion(
      id: Value(id),
      numSerie: Value(numSerie),
      numPatrimonio: Value(numPatrimonio),
      idTipoDispositivo: Value(idTipoDispositivo),
      idStatus: Value(idStatus),
      qtdTotal: Value(qtdTotal),
      qtdDisponivel: Value(qtdDisponivel),
    );
  }

  factory DispositivoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DispositivoData(
      id: serializer.fromJson<int>(json['id']),
      numSerie: serializer.fromJson<int>(json['numSerie']),
      numPatrimonio: serializer.fromJson<int>(json['numPatrimonio']),
      idTipoDispositivo: serializer.fromJson<int>(json['idTipoDispositivo']),
      idStatus: serializer.fromJson<int>(json['idStatus']),
      qtdTotal: serializer.fromJson<int>(json['qtdTotal']),
      qtdDisponivel: serializer.fromJson<int>(json['qtdDisponivel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numSerie': serializer.toJson<int>(numSerie),
      'numPatrimonio': serializer.toJson<int>(numPatrimonio),
      'idTipoDispositivo': serializer.toJson<int>(idTipoDispositivo),
      'idStatus': serializer.toJson<int>(idStatus),
      'qtdTotal': serializer.toJson<int>(qtdTotal),
      'qtdDisponivel': serializer.toJson<int>(qtdDisponivel),
    };
  }

  DispositivoData copyWith({
    int? id,
    int? numSerie,
    int? numPatrimonio,
    int? idTipoDispositivo,
    int? idStatus,
    int? qtdTotal,
    int? qtdDisponivel,
  }) => DispositivoData(
    id: id ?? this.id,
    numSerie: numSerie ?? this.numSerie,
    numPatrimonio: numPatrimonio ?? this.numPatrimonio,
    idTipoDispositivo: idTipoDispositivo ?? this.idTipoDispositivo,
    idStatus: idStatus ?? this.idStatus,
    qtdTotal: qtdTotal ?? this.qtdTotal,
    qtdDisponivel: qtdDisponivel ?? this.qtdDisponivel,
  );
  DispositivoData copyWithCompanion(DispositivosCompanion data) {
    return DispositivoData(
      id: data.id.present ? data.id.value : this.id,
      numSerie: data.numSerie.present ? data.numSerie.value : this.numSerie,
      numPatrimonio: data.numPatrimonio.present
          ? data.numPatrimonio.value
          : this.numPatrimonio,
      idTipoDispositivo: data.idTipoDispositivo.present
          ? data.idTipoDispositivo.value
          : this.idTipoDispositivo,
      idStatus: data.idStatus.present ? data.idStatus.value : this.idStatus,
      qtdTotal: data.qtdTotal.present ? data.qtdTotal.value : this.qtdTotal,
      qtdDisponivel: data.qtdDisponivel.present
          ? data.qtdDisponivel.value
          : this.qtdDisponivel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DispositivoData(')
          ..write('id: $id, ')
          ..write('numSerie: $numSerie, ')
          ..write('numPatrimonio: $numPatrimonio, ')
          ..write('idTipoDispositivo: $idTipoDispositivo, ')
          ..write('idStatus: $idStatus, ')
          ..write('qtdTotal: $qtdTotal, ')
          ..write('qtdDisponivel: $qtdDisponivel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    numSerie,
    numPatrimonio,
    idTipoDispositivo,
    idStatus,
    qtdTotal,
    qtdDisponivel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DispositivoData &&
          other.id == this.id &&
          other.numSerie == this.numSerie &&
          other.numPatrimonio == this.numPatrimonio &&
          other.idTipoDispositivo == this.idTipoDispositivo &&
          other.idStatus == this.idStatus &&
          other.qtdTotal == this.qtdTotal &&
          other.qtdDisponivel == this.qtdDisponivel);
}

class DispositivosCompanion extends UpdateCompanion<DispositivoData> {
  final Value<int> id;
  final Value<int> numSerie;
  final Value<int> numPatrimonio;
  final Value<int> idTipoDispositivo;
  final Value<int> idStatus;
  final Value<int> qtdTotal;
  final Value<int> qtdDisponivel;
  const DispositivosCompanion({
    this.id = const Value.absent(),
    this.numSerie = const Value.absent(),
    this.numPatrimonio = const Value.absent(),
    this.idTipoDispositivo = const Value.absent(),
    this.idStatus = const Value.absent(),
    this.qtdTotal = const Value.absent(),
    this.qtdDisponivel = const Value.absent(),
  });
  DispositivosCompanion.insert({
    this.id = const Value.absent(),
    required int numSerie,
    required int numPatrimonio,
    required int idTipoDispositivo,
    required int idStatus,
    required int qtdTotal,
    required int qtdDisponivel,
  }) : numSerie = Value(numSerie),
       numPatrimonio = Value(numPatrimonio),
       idTipoDispositivo = Value(idTipoDispositivo),
       idStatus = Value(idStatus),
       qtdTotal = Value(qtdTotal),
       qtdDisponivel = Value(qtdDisponivel);
  static Insertable<DispositivoData> custom({
    Expression<int>? id,
    Expression<int>? numSerie,
    Expression<int>? numPatrimonio,
    Expression<int>? idTipoDispositivo,
    Expression<int>? idStatus,
    Expression<int>? qtdTotal,
    Expression<int>? qtdDisponivel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numSerie != null) 'num_serie': numSerie,
      if (numPatrimonio != null) 'num_patrimonio': numPatrimonio,
      if (idTipoDispositivo != null) 'id_tipo_dispositivo': idTipoDispositivo,
      if (idStatus != null) 'id_status': idStatus,
      if (qtdTotal != null) 'qtd_total': qtdTotal,
      if (qtdDisponivel != null) 'qtd_disponivel': qtdDisponivel,
    });
  }

  DispositivosCompanion copyWith({
    Value<int>? id,
    Value<int>? numSerie,
    Value<int>? numPatrimonio,
    Value<int>? idTipoDispositivo,
    Value<int>? idStatus,
    Value<int>? qtdTotal,
    Value<int>? qtdDisponivel,
  }) {
    return DispositivosCompanion(
      id: id ?? this.id,
      numSerie: numSerie ?? this.numSerie,
      numPatrimonio: numPatrimonio ?? this.numPatrimonio,
      idTipoDispositivo: idTipoDispositivo ?? this.idTipoDispositivo,
      idStatus: idStatus ?? this.idStatus,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      qtdDisponivel: qtdDisponivel ?? this.qtdDisponivel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numSerie.present) {
      map['num_serie'] = Variable<int>(numSerie.value);
    }
    if (numPatrimonio.present) {
      map['num_patrimonio'] = Variable<int>(numPatrimonio.value);
    }
    if (idTipoDispositivo.present) {
      map['id_tipo_dispositivo'] = Variable<int>(idTipoDispositivo.value);
    }
    if (idStatus.present) {
      map['id_status'] = Variable<int>(idStatus.value);
    }
    if (qtdTotal.present) {
      map['qtd_total'] = Variable<int>(qtdTotal.value);
    }
    if (qtdDisponivel.present) {
      map['qtd_disponivel'] = Variable<int>(qtdDisponivel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DispositivosCompanion(')
          ..write('id: $id, ')
          ..write('numSerie: $numSerie, ')
          ..write('numPatrimonio: $numPatrimonio, ')
          ..write('idTipoDispositivo: $idTipoDispositivo, ')
          ..write('idStatus: $idStatus, ')
          ..write('qtdTotal: $qtdTotal, ')
          ..write('qtdDisponivel: $qtdDisponivel')
          ..write(')'))
        .toString();
  }
}

class $UsuariosTable extends Usuarios
    with TableInfo<$UsuariosTable, UsuarioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idCargoMeta = const VerificationMeta(
    'idCargo',
  );
  @override
  late final GeneratedColumn<int> idCargo = GeneratedColumn<int>(
    'id_cargo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cargos (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, idCargo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsuarioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('id_cargo')) {
      context.handle(
        _idCargoMeta,
        idCargo.isAcceptableOrUnknown(data['id_cargo']!, _idCargoMeta),
      );
    } else if (isInserting) {
      context.missing(_idCargoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsuarioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsuarioData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      idCargo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_cargo'],
      )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class UsuarioData extends DataClass implements Insertable<UsuarioData> {
  final int id;
  final String nome;
  final int idCargo;
  const UsuarioData({
    required this.id,
    required this.nome,
    required this.idCargo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['id_cargo'] = Variable<int>(idCargo);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nome: Value(nome),
      idCargo: Value(idCargo),
    );
  }

  factory UsuarioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsuarioData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      idCargo: serializer.fromJson<int>(json['idCargo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'idCargo': serializer.toJson<int>(idCargo),
    };
  }

  UsuarioData copyWith({int? id, String? nome, int? idCargo}) => UsuarioData(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    idCargo: idCargo ?? this.idCargo,
  );
  UsuarioData copyWithCompanion(UsuariosCompanion data) {
    return UsuarioData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      idCargo: data.idCargo.present ? data.idCargo.value : this.idCargo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('idCargo: $idCargo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, idCargo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsuarioData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.idCargo == this.idCargo);
}

class UsuariosCompanion extends UpdateCompanion<UsuarioData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<int> idCargo;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.idCargo = const Value.absent(),
  });
  UsuariosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required int idCargo,
  }) : nome = Value(nome),
       idCargo = Value(idCargo);
  static Insertable<UsuarioData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<int>? idCargo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (idCargo != null) 'id_cargo': idCargo,
    });
  }

  UsuariosCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<int>? idCargo,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      idCargo: idCargo ?? this.idCargo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (idCargo.present) {
      map['id_cargo'] = Variable<int>(idCargo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('idCargo: $idCargo')
          ..write(')'))
        .toString();
  }
}

class $EmprestimosTable extends Emprestimos
    with TableInfo<$EmprestimosTable, EmprestimoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmprestimosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dataHoraEfetuadoMeta = const VerificationMeta(
    'dataHoraEfetuado',
  );
  @override
  late final GeneratedColumn<DateTime> dataHoraEfetuado =
      GeneratedColumn<DateTime>(
        'data_hora_efetuado',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataHoraConcluidoMeta = const VerificationMeta(
    'dataHoraConcluido',
  );
  @override
  late final GeneratedColumn<DateTime> dataHoraConcluido =
      GeneratedColumn<DateTime>(
        'data_hora_concluido',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idResponsavelMeta = const VerificationMeta(
    'idResponsavel',
  );
  @override
  late final GeneratedColumn<int> idResponsavel = GeneratedColumn<int>(
    'id_responsavel',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _idStatusMeta = const VerificationMeta(
    'idStatus',
  );
  @override
  late final GeneratedColumn<int> idStatus = GeneratedColumn<int>(
    'id_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES emprestimo_status (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dataHoraEfetuado,
    dataHoraConcluido,
    idResponsavel,
    idStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emprestimos';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmprestimoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data_hora_efetuado')) {
      context.handle(
        _dataHoraEfetuadoMeta,
        dataHoraEfetuado.isAcceptableOrUnknown(
          data['data_hora_efetuado']!,
          _dataHoraEfetuadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataHoraEfetuadoMeta);
    }
    if (data.containsKey('data_hora_concluido')) {
      context.handle(
        _dataHoraConcluidoMeta,
        dataHoraConcluido.isAcceptableOrUnknown(
          data['data_hora_concluido']!,
          _dataHoraConcluidoMeta,
        ),
      );
    }
    if (data.containsKey('id_responsavel')) {
      context.handle(
        _idResponsavelMeta,
        idResponsavel.isAcceptableOrUnknown(
          data['id_responsavel']!,
          _idResponsavelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idResponsavelMeta);
    }
    if (data.containsKey('id_status')) {
      context.handle(
        _idStatusMeta,
        idStatus.isAcceptableOrUnknown(data['id_status']!, _idStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_idStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmprestimoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmprestimoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dataHoraEfetuado: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora_efetuado'],
      )!,
      dataHoraConcluido: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora_concluido'],
      ),
      idResponsavel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_responsavel'],
      )!,
      idStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_status'],
      )!,
    );
  }

  @override
  $EmprestimosTable createAlias(String alias) {
    return $EmprestimosTable(attachedDatabase, alias);
  }
}

class EmprestimoData extends DataClass implements Insertable<EmprestimoData> {
  final int id;
  final DateTime dataHoraEfetuado;
  final DateTime? dataHoraConcluido;
  final int idResponsavel;
  final int idStatus;
  const EmprestimoData({
    required this.id,
    required this.dataHoraEfetuado,
    this.dataHoraConcluido,
    required this.idResponsavel,
    required this.idStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data_hora_efetuado'] = Variable<DateTime>(dataHoraEfetuado);
    if (!nullToAbsent || dataHoraConcluido != null) {
      map['data_hora_concluido'] = Variable<DateTime>(dataHoraConcluido);
    }
    map['id_responsavel'] = Variable<int>(idResponsavel);
    map['id_status'] = Variable<int>(idStatus);
    return map;
  }

  EmprestimosCompanion toCompanion(bool nullToAbsent) {
    return EmprestimosCompanion(
      id: Value(id),
      dataHoraEfetuado: Value(dataHoraEfetuado),
      dataHoraConcluido: dataHoraConcluido == null && nullToAbsent
          ? const Value.absent()
          : Value(dataHoraConcluido),
      idResponsavel: Value(idResponsavel),
      idStatus: Value(idStatus),
    );
  }

  factory EmprestimoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmprestimoData(
      id: serializer.fromJson<int>(json['id']),
      dataHoraEfetuado: serializer.fromJson<DateTime>(json['dataHoraEfetuado']),
      dataHoraConcluido: serializer.fromJson<DateTime?>(
        json['dataHoraConcluido'],
      ),
      idResponsavel: serializer.fromJson<int>(json['idResponsavel']),
      idStatus: serializer.fromJson<int>(json['idStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dataHoraEfetuado': serializer.toJson<DateTime>(dataHoraEfetuado),
      'dataHoraConcluido': serializer.toJson<DateTime?>(dataHoraConcluido),
      'idResponsavel': serializer.toJson<int>(idResponsavel),
      'idStatus': serializer.toJson<int>(idStatus),
    };
  }

  EmprestimoData copyWith({
    int? id,
    DateTime? dataHoraEfetuado,
    Value<DateTime?> dataHoraConcluido = const Value.absent(),
    int? idResponsavel,
    int? idStatus,
  }) => EmprestimoData(
    id: id ?? this.id,
    dataHoraEfetuado: dataHoraEfetuado ?? this.dataHoraEfetuado,
    dataHoraConcluido: dataHoraConcluido.present
        ? dataHoraConcluido.value
        : this.dataHoraConcluido,
    idResponsavel: idResponsavel ?? this.idResponsavel,
    idStatus: idStatus ?? this.idStatus,
  );
  EmprestimoData copyWithCompanion(EmprestimosCompanion data) {
    return EmprestimoData(
      id: data.id.present ? data.id.value : this.id,
      dataHoraEfetuado: data.dataHoraEfetuado.present
          ? data.dataHoraEfetuado.value
          : this.dataHoraEfetuado,
      dataHoraConcluido: data.dataHoraConcluido.present
          ? data.dataHoraConcluido.value
          : this.dataHoraConcluido,
      idResponsavel: data.idResponsavel.present
          ? data.idResponsavel.value
          : this.idResponsavel,
      idStatus: data.idStatus.present ? data.idStatus.value : this.idStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoData(')
          ..write('id: $id, ')
          ..write('dataHoraEfetuado: $dataHoraEfetuado, ')
          ..write('dataHoraConcluido: $dataHoraConcluido, ')
          ..write('idResponsavel: $idResponsavel, ')
          ..write('idStatus: $idStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dataHoraEfetuado,
    dataHoraConcluido,
    idResponsavel,
    idStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmprestimoData &&
          other.id == this.id &&
          other.dataHoraEfetuado == this.dataHoraEfetuado &&
          other.dataHoraConcluido == this.dataHoraConcluido &&
          other.idResponsavel == this.idResponsavel &&
          other.idStatus == this.idStatus);
}

class EmprestimosCompanion extends UpdateCompanion<EmprestimoData> {
  final Value<int> id;
  final Value<DateTime> dataHoraEfetuado;
  final Value<DateTime?> dataHoraConcluido;
  final Value<int> idResponsavel;
  final Value<int> idStatus;
  const EmprestimosCompanion({
    this.id = const Value.absent(),
    this.dataHoraEfetuado = const Value.absent(),
    this.dataHoraConcluido = const Value.absent(),
    this.idResponsavel = const Value.absent(),
    this.idStatus = const Value.absent(),
  });
  EmprestimosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime dataHoraEfetuado,
    this.dataHoraConcluido = const Value.absent(),
    required int idResponsavel,
    required int idStatus,
  }) : dataHoraEfetuado = Value(dataHoraEfetuado),
       idResponsavel = Value(idResponsavel),
       idStatus = Value(idStatus);
  static Insertable<EmprestimoData> custom({
    Expression<int>? id,
    Expression<DateTime>? dataHoraEfetuado,
    Expression<DateTime>? dataHoraConcluido,
    Expression<int>? idResponsavel,
    Expression<int>? idStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataHoraEfetuado != null) 'data_hora_efetuado': dataHoraEfetuado,
      if (dataHoraConcluido != null) 'data_hora_concluido': dataHoraConcluido,
      if (idResponsavel != null) 'id_responsavel': idResponsavel,
      if (idStatus != null) 'id_status': idStatus,
    });
  }

  EmprestimosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? dataHoraEfetuado,
    Value<DateTime?>? dataHoraConcluido,
    Value<int>? idResponsavel,
    Value<int>? idStatus,
  }) {
    return EmprestimosCompanion(
      id: id ?? this.id,
      dataHoraEfetuado: dataHoraEfetuado ?? this.dataHoraEfetuado,
      dataHoraConcluido: dataHoraConcluido ?? this.dataHoraConcluido,
      idResponsavel: idResponsavel ?? this.idResponsavel,
      idStatus: idStatus ?? this.idStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataHoraEfetuado.present) {
      map['data_hora_efetuado'] = Variable<DateTime>(dataHoraEfetuado.value);
    }
    if (dataHoraConcluido.present) {
      map['data_hora_concluido'] = Variable<DateTime>(dataHoraConcluido.value);
    }
    if (idResponsavel.present) {
      map['id_responsavel'] = Variable<int>(idResponsavel.value);
    }
    if (idStatus.present) {
      map['id_status'] = Variable<int>(idStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimosCompanion(')
          ..write('id: $id, ')
          ..write('dataHoraEfetuado: $dataHoraEfetuado, ')
          ..write('dataHoraConcluido: $dataHoraConcluido, ')
          ..write('idResponsavel: $idResponsavel, ')
          ..write('idStatus: $idStatus')
          ..write(')'))
        .toString();
  }
}

class $EmprestimoItensTable extends EmprestimoItens
    with TableInfo<$EmprestimoItensTable, EmprestimoItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmprestimoItensTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _idEmprestimoMeta = const VerificationMeta(
    'idEmprestimo',
  );
  @override
  late final GeneratedColumn<int> idEmprestimo = GeneratedColumn<int>(
    'id_emprestimo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES emprestimos (id)',
    ),
  );
  static const VerificationMeta _idTipoDispositivoMeta = const VerificationMeta(
    'idTipoDispositivo',
  );
  @override
  late final GeneratedColumn<int> idTipoDispositivo = GeneratedColumn<int>(
    'id_tipo_dispositivo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tipos_dispositivo (id)',
    ),
  );
  static const VerificationMeta _qtdSolicitadaMeta = const VerificationMeta(
    'qtdSolicitada',
  );
  @override
  late final GeneratedColumn<int> qtdSolicitada = GeneratedColumn<int>(
    'qtd_solicitada',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtdDevolvidaMeta = const VerificationMeta(
    'qtdDevolvida',
  );
  @override
  late final GeneratedColumn<int> qtdDevolvida = GeneratedColumn<int>(
    'qtd_devolvida',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estaResolvidoMeta = const VerificationMeta(
    'estaResolvido',
  );
  @override
  late final GeneratedColumn<bool> estaResolvido = GeneratedColumn<bool>(
    'esta_resolvido',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("esta_resolvido" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idEmprestimo,
    idTipoDispositivo,
    qtdSolicitada,
    qtdDevolvida,
    estaResolvido,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emprestimo_itens';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmprestimoItemData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_emprestimo')) {
      context.handle(
        _idEmprestimoMeta,
        idEmprestimo.isAcceptableOrUnknown(
          data['id_emprestimo']!,
          _idEmprestimoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idEmprestimoMeta);
    }
    if (data.containsKey('id_tipo_dispositivo')) {
      context.handle(
        _idTipoDispositivoMeta,
        idTipoDispositivo.isAcceptableOrUnknown(
          data['id_tipo_dispositivo']!,
          _idTipoDispositivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idTipoDispositivoMeta);
    }
    if (data.containsKey('qtd_solicitada')) {
      context.handle(
        _qtdSolicitadaMeta,
        qtdSolicitada.isAcceptableOrUnknown(
          data['qtd_solicitada']!,
          _qtdSolicitadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_qtdSolicitadaMeta);
    }
    if (data.containsKey('qtd_devolvida')) {
      context.handle(
        _qtdDevolvidaMeta,
        qtdDevolvida.isAcceptableOrUnknown(
          data['qtd_devolvida']!,
          _qtdDevolvidaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_qtdDevolvidaMeta);
    }
    if (data.containsKey('esta_resolvido')) {
      context.handle(
        _estaResolvidoMeta,
        estaResolvido.isAcceptableOrUnknown(
          data['esta_resolvido']!,
          _estaResolvidoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estaResolvidoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmprestimoItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmprestimoItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idEmprestimo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_emprestimo'],
      )!,
      idTipoDispositivo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_tipo_dispositivo'],
      )!,
      qtdSolicitada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qtd_solicitada'],
      )!,
      qtdDevolvida: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qtd_devolvida'],
      )!,
      estaResolvido: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}esta_resolvido'],
      )!,
    );
  }

  @override
  $EmprestimoItensTable createAlias(String alias) {
    return $EmprestimoItensTable(attachedDatabase, alias);
  }
}

class EmprestimoItemData extends DataClass
    implements Insertable<EmprestimoItemData> {
  final int id;
  final int idEmprestimo;
  final int idTipoDispositivo;
  final int qtdSolicitada;
  final int qtdDevolvida;
  final bool estaResolvido;
  const EmprestimoItemData({
    required this.id,
    required this.idEmprestimo,
    required this.idTipoDispositivo,
    required this.qtdSolicitada,
    required this.qtdDevolvida,
    required this.estaResolvido,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_emprestimo'] = Variable<int>(idEmprestimo);
    map['id_tipo_dispositivo'] = Variable<int>(idTipoDispositivo);
    map['qtd_solicitada'] = Variable<int>(qtdSolicitada);
    map['qtd_devolvida'] = Variable<int>(qtdDevolvida);
    map['esta_resolvido'] = Variable<bool>(estaResolvido);
    return map;
  }

  EmprestimoItensCompanion toCompanion(bool nullToAbsent) {
    return EmprestimoItensCompanion(
      id: Value(id),
      idEmprestimo: Value(idEmprestimo),
      idTipoDispositivo: Value(idTipoDispositivo),
      qtdSolicitada: Value(qtdSolicitada),
      qtdDevolvida: Value(qtdDevolvida),
      estaResolvido: Value(estaResolvido),
    );
  }

  factory EmprestimoItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmprestimoItemData(
      id: serializer.fromJson<int>(json['id']),
      idEmprestimo: serializer.fromJson<int>(json['idEmprestimo']),
      idTipoDispositivo: serializer.fromJson<int>(json['idTipoDispositivo']),
      qtdSolicitada: serializer.fromJson<int>(json['qtdSolicitada']),
      qtdDevolvida: serializer.fromJson<int>(json['qtdDevolvida']),
      estaResolvido: serializer.fromJson<bool>(json['estaResolvido']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idEmprestimo': serializer.toJson<int>(idEmprestimo),
      'idTipoDispositivo': serializer.toJson<int>(idTipoDispositivo),
      'qtdSolicitada': serializer.toJson<int>(qtdSolicitada),
      'qtdDevolvida': serializer.toJson<int>(qtdDevolvida),
      'estaResolvido': serializer.toJson<bool>(estaResolvido),
    };
  }

  EmprestimoItemData copyWith({
    int? id,
    int? idEmprestimo,
    int? idTipoDispositivo,
    int? qtdSolicitada,
    int? qtdDevolvida,
    bool? estaResolvido,
  }) => EmprestimoItemData(
    id: id ?? this.id,
    idEmprestimo: idEmprestimo ?? this.idEmprestimo,
    idTipoDispositivo: idTipoDispositivo ?? this.idTipoDispositivo,
    qtdSolicitada: qtdSolicitada ?? this.qtdSolicitada,
    qtdDevolvida: qtdDevolvida ?? this.qtdDevolvida,
    estaResolvido: estaResolvido ?? this.estaResolvido,
  );
  EmprestimoItemData copyWithCompanion(EmprestimoItensCompanion data) {
    return EmprestimoItemData(
      id: data.id.present ? data.id.value : this.id,
      idEmprestimo: data.idEmprestimo.present
          ? data.idEmprestimo.value
          : this.idEmprestimo,
      idTipoDispositivo: data.idTipoDispositivo.present
          ? data.idTipoDispositivo.value
          : this.idTipoDispositivo,
      qtdSolicitada: data.qtdSolicitada.present
          ? data.qtdSolicitada.value
          : this.qtdSolicitada,
      qtdDevolvida: data.qtdDevolvida.present
          ? data.qtdDevolvida.value
          : this.qtdDevolvida,
      estaResolvido: data.estaResolvido.present
          ? data.estaResolvido.value
          : this.estaResolvido,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoItemData(')
          ..write('id: $id, ')
          ..write('idEmprestimo: $idEmprestimo, ')
          ..write('idTipoDispositivo: $idTipoDispositivo, ')
          ..write('qtdSolicitada: $qtdSolicitada, ')
          ..write('qtdDevolvida: $qtdDevolvida, ')
          ..write('estaResolvido: $estaResolvido')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idEmprestimo,
    idTipoDispositivo,
    qtdSolicitada,
    qtdDevolvida,
    estaResolvido,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmprestimoItemData &&
          other.id == this.id &&
          other.idEmprestimo == this.idEmprestimo &&
          other.idTipoDispositivo == this.idTipoDispositivo &&
          other.qtdSolicitada == this.qtdSolicitada &&
          other.qtdDevolvida == this.qtdDevolvida &&
          other.estaResolvido == this.estaResolvido);
}

class EmprestimoItensCompanion extends UpdateCompanion<EmprestimoItemData> {
  final Value<int> id;
  final Value<int> idEmprestimo;
  final Value<int> idTipoDispositivo;
  final Value<int> qtdSolicitada;
  final Value<int> qtdDevolvida;
  final Value<bool> estaResolvido;
  const EmprestimoItensCompanion({
    this.id = const Value.absent(),
    this.idEmprestimo = const Value.absent(),
    this.idTipoDispositivo = const Value.absent(),
    this.qtdSolicitada = const Value.absent(),
    this.qtdDevolvida = const Value.absent(),
    this.estaResolvido = const Value.absent(),
  });
  EmprestimoItensCompanion.insert({
    this.id = const Value.absent(),
    required int idEmprestimo,
    required int idTipoDispositivo,
    required int qtdSolicitada,
    required int qtdDevolvida,
    required bool estaResolvido,
  }) : idEmprestimo = Value(idEmprestimo),
       idTipoDispositivo = Value(idTipoDispositivo),
       qtdSolicitada = Value(qtdSolicitada),
       qtdDevolvida = Value(qtdDevolvida),
       estaResolvido = Value(estaResolvido);
  static Insertable<EmprestimoItemData> custom({
    Expression<int>? id,
    Expression<int>? idEmprestimo,
    Expression<int>? idTipoDispositivo,
    Expression<int>? qtdSolicitada,
    Expression<int>? qtdDevolvida,
    Expression<bool>? estaResolvido,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idEmprestimo != null) 'id_emprestimo': idEmprestimo,
      if (idTipoDispositivo != null) 'id_tipo_dispositivo': idTipoDispositivo,
      if (qtdSolicitada != null) 'qtd_solicitada': qtdSolicitada,
      if (qtdDevolvida != null) 'qtd_devolvida': qtdDevolvida,
      if (estaResolvido != null) 'esta_resolvido': estaResolvido,
    });
  }

  EmprestimoItensCompanion copyWith({
    Value<int>? id,
    Value<int>? idEmprestimo,
    Value<int>? idTipoDispositivo,
    Value<int>? qtdSolicitada,
    Value<int>? qtdDevolvida,
    Value<bool>? estaResolvido,
  }) {
    return EmprestimoItensCompanion(
      id: id ?? this.id,
      idEmprestimo: idEmprestimo ?? this.idEmprestimo,
      idTipoDispositivo: idTipoDispositivo ?? this.idTipoDispositivo,
      qtdSolicitada: qtdSolicitada ?? this.qtdSolicitada,
      qtdDevolvida: qtdDevolvida ?? this.qtdDevolvida,
      estaResolvido: estaResolvido ?? this.estaResolvido,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idEmprestimo.present) {
      map['id_emprestimo'] = Variable<int>(idEmprestimo.value);
    }
    if (idTipoDispositivo.present) {
      map['id_tipo_dispositivo'] = Variable<int>(idTipoDispositivo.value);
    }
    if (qtdSolicitada.present) {
      map['qtd_solicitada'] = Variable<int>(qtdSolicitada.value);
    }
    if (qtdDevolvida.present) {
      map['qtd_devolvida'] = Variable<int>(qtdDevolvida.value);
    }
    if (estaResolvido.present) {
      map['esta_resolvido'] = Variable<bool>(estaResolvido.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoItensCompanion(')
          ..write('id: $id, ')
          ..write('idEmprestimo: $idEmprestimo, ')
          ..write('idTipoDispositivo: $idTipoDispositivo, ')
          ..write('qtdSolicitada: $qtdSolicitada, ')
          ..write('qtdDevolvida: $qtdDevolvida, ')
          ..write('estaResolvido: $estaResolvido')
          ..write(')'))
        .toString();
  }
}

class $EmprestimoDispositivosTable extends EmprestimoDispositivos
    with TableInfo<$EmprestimoDispositivosTable, EmprestimoDispositivoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmprestimoDispositivosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _idEmprestimoItemMeta = const VerificationMeta(
    'idEmprestimoItem',
  );
  @override
  late final GeneratedColumn<int> idEmprestimoItem = GeneratedColumn<int>(
    'id_emprestimo_item',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES emprestimo_itens (id)',
    ),
  );
  static const VerificationMeta _idDispositivoMeta = const VerificationMeta(
    'idDispositivo',
  );
  @override
  late final GeneratedColumn<int> idDispositivo = GeneratedColumn<int>(
    'id_dispositivo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dispositivos (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, idEmprestimoItem, idDispositivo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emprestimo_dispositivos';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmprestimoDispositivoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_emprestimo_item')) {
      context.handle(
        _idEmprestimoItemMeta,
        idEmprestimoItem.isAcceptableOrUnknown(
          data['id_emprestimo_item']!,
          _idEmprestimoItemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idEmprestimoItemMeta);
    }
    if (data.containsKey('id_dispositivo')) {
      context.handle(
        _idDispositivoMeta,
        idDispositivo.isAcceptableOrUnknown(
          data['id_dispositivo']!,
          _idDispositivoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmprestimoDispositivoData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmprestimoDispositivoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idEmprestimoItem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_emprestimo_item'],
      )!,
      idDispositivo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_dispositivo'],
      ),
    );
  }

  @override
  $EmprestimoDispositivosTable createAlias(String alias) {
    return $EmprestimoDispositivosTable(attachedDatabase, alias);
  }
}

class EmprestimoDispositivoData extends DataClass
    implements Insertable<EmprestimoDispositivoData> {
  final int id;
  final int idEmprestimoItem;
  final int? idDispositivo;
  const EmprestimoDispositivoData({
    required this.id,
    required this.idEmprestimoItem,
    this.idDispositivo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_emprestimo_item'] = Variable<int>(idEmprestimoItem);
    if (!nullToAbsent || idDispositivo != null) {
      map['id_dispositivo'] = Variable<int>(idDispositivo);
    }
    return map;
  }

  EmprestimoDispositivosCompanion toCompanion(bool nullToAbsent) {
    return EmprestimoDispositivosCompanion(
      id: Value(id),
      idEmprestimoItem: Value(idEmprestimoItem),
      idDispositivo: idDispositivo == null && nullToAbsent
          ? const Value.absent()
          : Value(idDispositivo),
    );
  }

  factory EmprestimoDispositivoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmprestimoDispositivoData(
      id: serializer.fromJson<int>(json['id']),
      idEmprestimoItem: serializer.fromJson<int>(json['idEmprestimoItem']),
      idDispositivo: serializer.fromJson<int?>(json['idDispositivo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idEmprestimoItem': serializer.toJson<int>(idEmprestimoItem),
      'idDispositivo': serializer.toJson<int?>(idDispositivo),
    };
  }

  EmprestimoDispositivoData copyWith({
    int? id,
    int? idEmprestimoItem,
    Value<int?> idDispositivo = const Value.absent(),
  }) => EmprestimoDispositivoData(
    id: id ?? this.id,
    idEmprestimoItem: idEmprestimoItem ?? this.idEmprestimoItem,
    idDispositivo: idDispositivo.present
        ? idDispositivo.value
        : this.idDispositivo,
  );
  EmprestimoDispositivoData copyWithCompanion(
    EmprestimoDispositivosCompanion data,
  ) {
    return EmprestimoDispositivoData(
      id: data.id.present ? data.id.value : this.id,
      idEmprestimoItem: data.idEmprestimoItem.present
          ? data.idEmprestimoItem.value
          : this.idEmprestimoItem,
      idDispositivo: data.idDispositivo.present
          ? data.idDispositivo.value
          : this.idDispositivo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoDispositivoData(')
          ..write('id: $id, ')
          ..write('idEmprestimoItem: $idEmprestimoItem, ')
          ..write('idDispositivo: $idDispositivo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idEmprestimoItem, idDispositivo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmprestimoDispositivoData &&
          other.id == this.id &&
          other.idEmprestimoItem == this.idEmprestimoItem &&
          other.idDispositivo == this.idDispositivo);
}

class EmprestimoDispositivosCompanion
    extends UpdateCompanion<EmprestimoDispositivoData> {
  final Value<int> id;
  final Value<int> idEmprestimoItem;
  final Value<int?> idDispositivo;
  const EmprestimoDispositivosCompanion({
    this.id = const Value.absent(),
    this.idEmprestimoItem = const Value.absent(),
    this.idDispositivo = const Value.absent(),
  });
  EmprestimoDispositivosCompanion.insert({
    this.id = const Value.absent(),
    required int idEmprestimoItem,
    this.idDispositivo = const Value.absent(),
  }) : idEmprestimoItem = Value(idEmprestimoItem);
  static Insertable<EmprestimoDispositivoData> custom({
    Expression<int>? id,
    Expression<int>? idEmprestimoItem,
    Expression<int>? idDispositivo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idEmprestimoItem != null) 'id_emprestimo_item': idEmprestimoItem,
      if (idDispositivo != null) 'id_dispositivo': idDispositivo,
    });
  }

  EmprestimoDispositivosCompanion copyWith({
    Value<int>? id,
    Value<int>? idEmprestimoItem,
    Value<int?>? idDispositivo,
  }) {
    return EmprestimoDispositivosCompanion(
      id: id ?? this.id,
      idEmprestimoItem: idEmprestimoItem ?? this.idEmprestimoItem,
      idDispositivo: idDispositivo ?? this.idDispositivo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idEmprestimoItem.present) {
      map['id_emprestimo_item'] = Variable<int>(idEmprestimoItem.value);
    }
    if (idDispositivo.present) {
      map['id_dispositivo'] = Variable<int>(idDispositivo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoDispositivosCompanion(')
          ..write('id: $id, ')
          ..write('idEmprestimoItem: $idEmprestimoItem, ')
          ..write('idDispositivo: $idDispositivo')
          ..write(')'))
        .toString();
  }
}

class $ProblemasTable extends Problemas
    with TableInfo<$ProblemasTable, ProblemaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProblemasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _idDispositivoMeta = const VerificationMeta(
    'idDispositivo',
  );
  @override
  late final GeneratedColumn<int> idDispositivo = GeneratedColumn<int>(
    'id_dispositivo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dispositivos (id)',
    ),
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, idDispositivo, descricao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'problemas';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProblemaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_dispositivo')) {
      context.handle(
        _idDispositivoMeta,
        idDispositivo.isAcceptableOrUnknown(
          data['id_dispositivo']!,
          _idDispositivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idDispositivoMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProblemaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProblemaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idDispositivo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_dispositivo'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
    );
  }

  @override
  $ProblemasTable createAlias(String alias) {
    return $ProblemasTable(attachedDatabase, alias);
  }
}

class ProblemaData extends DataClass implements Insertable<ProblemaData> {
  final int id;
  final int idDispositivo;
  final String descricao;
  const ProblemaData({
    required this.id,
    required this.idDispositivo,
    required this.descricao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_dispositivo'] = Variable<int>(idDispositivo);
    map['descricao'] = Variable<String>(descricao);
    return map;
  }

  ProblemasCompanion toCompanion(bool nullToAbsent) {
    return ProblemasCompanion(
      id: Value(id),
      idDispositivo: Value(idDispositivo),
      descricao: Value(descricao),
    );
  }

  factory ProblemaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProblemaData(
      id: serializer.fromJson<int>(json['id']),
      idDispositivo: serializer.fromJson<int>(json['idDispositivo']),
      descricao: serializer.fromJson<String>(json['descricao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idDispositivo': serializer.toJson<int>(idDispositivo),
      'descricao': serializer.toJson<String>(descricao),
    };
  }

  ProblemaData copyWith({int? id, int? idDispositivo, String? descricao}) =>
      ProblemaData(
        id: id ?? this.id,
        idDispositivo: idDispositivo ?? this.idDispositivo,
        descricao: descricao ?? this.descricao,
      );
  ProblemaData copyWithCompanion(ProblemasCompanion data) {
    return ProblemaData(
      id: data.id.present ? data.id.value : this.id,
      idDispositivo: data.idDispositivo.present
          ? data.idDispositivo.value
          : this.idDispositivo,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProblemaData(')
          ..write('id: $id, ')
          ..write('idDispositivo: $idDispositivo, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idDispositivo, descricao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProblemaData &&
          other.id == this.id &&
          other.idDispositivo == this.idDispositivo &&
          other.descricao == this.descricao);
}

class ProblemasCompanion extends UpdateCompanion<ProblemaData> {
  final Value<int> id;
  final Value<int> idDispositivo;
  final Value<String> descricao;
  const ProblemasCompanion({
    this.id = const Value.absent(),
    this.idDispositivo = const Value.absent(),
    this.descricao = const Value.absent(),
  });
  ProblemasCompanion.insert({
    this.id = const Value.absent(),
    required int idDispositivo,
    required String descricao,
  }) : idDispositivo = Value(idDispositivo),
       descricao = Value(descricao);
  static Insertable<ProblemaData> custom({
    Expression<int>? id,
    Expression<int>? idDispositivo,
    Expression<String>? descricao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idDispositivo != null) 'id_dispositivo': idDispositivo,
      if (descricao != null) 'descricao': descricao,
    });
  }

  ProblemasCompanion copyWith({
    Value<int>? id,
    Value<int>? idDispositivo,
    Value<String>? descricao,
  }) {
    return ProblemasCompanion(
      id: id ?? this.id,
      idDispositivo: idDispositivo ?? this.idDispositivo,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idDispositivo.present) {
      map['id_dispositivo'] = Variable<int>(idDispositivo.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProblemasCompanion(')
          ..write('id: $id, ')
          ..write('idDispositivo: $idDispositivo, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CargosTable cargos = $CargosTable(this);
  late final $TiposDispositivoTable tiposDispositivo = $TiposDispositivoTable(
    this,
  );
  late final $EmprestimoStatusTable emprestimoStatus = $EmprestimoStatusTable(
    this,
  );
  late final $DispositivosTable dispositivos = $DispositivosTable(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $EmprestimosTable emprestimos = $EmprestimosTable(this);
  late final $EmprestimoItensTable emprestimoItens = $EmprestimoItensTable(
    this,
  );
  late final $EmprestimoDispositivosTable emprestimoDispositivos =
      $EmprestimoDispositivosTable(this);
  late final $ProblemasTable problemas = $ProblemasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cargos,
    tiposDispositivo,
    emprestimoStatus,
    dispositivos,
    usuarios,
    emprestimos,
    emprestimoItens,
    emprestimoDispositivos,
    problemas,
  ];
}

typedef $$CargosTableCreateCompanionBuilder =
    CargosCompanion Function({Value<int> id, required String nomeCargo});
typedef $$CargosTableUpdateCompanionBuilder =
    CargosCompanion Function({Value<int> id, Value<String> nomeCargo});

final class $$CargosTableReferences
    extends BaseReferences<_$AppDatabase, $CargosTable, CargoData> {
  $$CargosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsuariosTable, List<UsuarioData>>
  _usuariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usuarios,
    aliasName: $_aliasNameGenerator(db.cargos.id, db.usuarios.idCargo),
  );

  $$UsuariosTableProcessedTableManager get usuariosRefs {
    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.idCargo.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_usuariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CargosTableFilterComposer
    extends Composer<_$AppDatabase, $CargosTable> {
  $$CargosTableFilterComposer({
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

  ColumnFilters<String> get nomeCargo => $composableBuilder(
    column: $table.nomeCargo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> usuariosRefs(
    Expression<bool> Function($$UsuariosTableFilterComposer f) f,
  ) {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.idCargo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CargosTableOrderingComposer
    extends Composer<_$AppDatabase, $CargosTable> {
  $$CargosTableOrderingComposer({
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

  ColumnOrderings<String> get nomeCargo => $composableBuilder(
    column: $table.nomeCargo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CargosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CargosTable> {
  $$CargosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomeCargo =>
      $composableBuilder(column: $table.nomeCargo, builder: (column) => column);

  Expression<T> usuariosRefs<T extends Object>(
    Expression<T> Function($$UsuariosTableAnnotationComposer a) f,
  ) {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.idCargo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CargosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CargosTable,
          CargoData,
          $$CargosTableFilterComposer,
          $$CargosTableOrderingComposer,
          $$CargosTableAnnotationComposer,
          $$CargosTableCreateCompanionBuilder,
          $$CargosTableUpdateCompanionBuilder,
          (CargoData, $$CargosTableReferences),
          CargoData,
          PrefetchHooks Function({bool usuariosRefs})
        > {
  $$CargosTableTableManager(_$AppDatabase db, $CargosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CargosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CargosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CargosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nomeCargo = const Value.absent(),
              }) => CargosCompanion(id: id, nomeCargo: nomeCargo),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nomeCargo,
              }) => CargosCompanion.insert(id: id, nomeCargo: nomeCargo),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CargosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({usuariosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (usuariosRefs) db.usuarios],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (usuariosRefs)
                    await $_getPrefetchedData<
                      CargoData,
                      $CargosTable,
                      UsuarioData
                    >(
                      currentTable: table,
                      referencedTable: $$CargosTableReferences
                          ._usuariosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CargosTableReferences(db, table, p0).usuariosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.idCargo == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CargosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CargosTable,
      CargoData,
      $$CargosTableFilterComposer,
      $$CargosTableOrderingComposer,
      $$CargosTableAnnotationComposer,
      $$CargosTableCreateCompanionBuilder,
      $$CargosTableUpdateCompanionBuilder,
      (CargoData, $$CargosTableReferences),
      CargoData,
      PrefetchHooks Function({bool usuariosRefs})
    >;
typedef $$TiposDispositivoTableCreateCompanionBuilder =
    TiposDispositivoCompanion Function({
      Value<int> id,
      required String nomeTipo,
    });
typedef $$TiposDispositivoTableUpdateCompanionBuilder =
    TiposDispositivoCompanion Function({Value<int> id, Value<String> nomeTipo});

final class $$TiposDispositivoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TiposDispositivoTable,
          TipoDispositivoData
        > {
  $$TiposDispositivoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DispositivosTable, List<DispositivoData>>
  _dispositivosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dispositivos,
    aliasName: $_aliasNameGenerator(
      db.tiposDispositivo.id,
      db.dispositivos.idTipoDispositivo,
    ),
  );

  $$DispositivosTableProcessedTableManager get dispositivosRefs {
    final manager = $$DispositivosTableTableManager(
      $_db,
      $_db.dispositivos,
    ).filter((f) => f.idTipoDispositivo.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dispositivosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EmprestimoItensTable, List<EmprestimoItemData>>
  _emprestimoItensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimoItens,
    aliasName: $_aliasNameGenerator(
      db.tiposDispositivo.id,
      db.emprestimoItens.idTipoDispositivo,
    ),
  );

  $$EmprestimoItensTableProcessedTableManager get emprestimoItensRefs {
    final manager = $$EmprestimoItensTableTableManager(
      $_db,
      $_db.emprestimoItens,
    ).filter((f) => f.idTipoDispositivo.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emprestimoItensRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TiposDispositivoTableFilterComposer
    extends Composer<_$AppDatabase, $TiposDispositivoTable> {
  $$TiposDispositivoTableFilterComposer({
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

  ColumnFilters<String> get nomeTipo => $composableBuilder(
    column: $table.nomeTipo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dispositivosRefs(
    Expression<bool> Function($$DispositivosTableFilterComposer f) f,
  ) {
    final $$DispositivosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.idTipoDispositivo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableFilterComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> emprestimoItensRefs(
    Expression<bool> Function($$EmprestimoItensTableFilterComposer f) f,
  ) {
    final $$EmprestimoItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.idTipoDispositivo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableFilterComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiposDispositivoTableOrderingComposer
    extends Composer<_$AppDatabase, $TiposDispositivoTable> {
  $$TiposDispositivoTableOrderingComposer({
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

  ColumnOrderings<String> get nomeTipo => $composableBuilder(
    column: $table.nomeTipo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TiposDispositivoTableAnnotationComposer
    extends Composer<_$AppDatabase, $TiposDispositivoTable> {
  $$TiposDispositivoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomeTipo =>
      $composableBuilder(column: $table.nomeTipo, builder: (column) => column);

  Expression<T> dispositivosRefs<T extends Object>(
    Expression<T> Function($$DispositivosTableAnnotationComposer a) f,
  ) {
    final $$DispositivosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.idTipoDispositivo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableAnnotationComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> emprestimoItensRefs<T extends Object>(
    Expression<T> Function($$EmprestimoItensTableAnnotationComposer a) f,
  ) {
    final $$EmprestimoItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.idTipoDispositivo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiposDispositivoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TiposDispositivoTable,
          TipoDispositivoData,
          $$TiposDispositivoTableFilterComposer,
          $$TiposDispositivoTableOrderingComposer,
          $$TiposDispositivoTableAnnotationComposer,
          $$TiposDispositivoTableCreateCompanionBuilder,
          $$TiposDispositivoTableUpdateCompanionBuilder,
          (TipoDispositivoData, $$TiposDispositivoTableReferences),
          TipoDispositivoData,
          PrefetchHooks Function({
            bool dispositivosRefs,
            bool emprestimoItensRefs,
          })
        > {
  $$TiposDispositivoTableTableManager(
    _$AppDatabase db,
    $TiposDispositivoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TiposDispositivoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TiposDispositivoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TiposDispositivoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nomeTipo = const Value.absent(),
              }) => TiposDispositivoCompanion(id: id, nomeTipo: nomeTipo),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nomeTipo,
              }) =>
                  TiposDispositivoCompanion.insert(id: id, nomeTipo: nomeTipo),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TiposDispositivoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({dispositivosRefs = false, emprestimoItensRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dispositivosRefs) db.dispositivos,
                    if (emprestimoItensRefs) db.emprestimoItens,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dispositivosRefs)
                        await $_getPrefetchedData<
                          TipoDispositivoData,
                          $TiposDispositivoTable,
                          DispositivoData
                        >(
                          currentTable: table,
                          referencedTable: $$TiposDispositivoTableReferences
                              ._dispositivosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TiposDispositivoTableReferences(
                                db,
                                table,
                                p0,
                              ).dispositivosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idTipoDispositivo == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (emprestimoItensRefs)
                        await $_getPrefetchedData<
                          TipoDispositivoData,
                          $TiposDispositivoTable,
                          EmprestimoItemData
                        >(
                          currentTable: table,
                          referencedTable: $$TiposDispositivoTableReferences
                              ._emprestimoItensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TiposDispositivoTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimoItensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idTipoDispositivo == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TiposDispositivoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TiposDispositivoTable,
      TipoDispositivoData,
      $$TiposDispositivoTableFilterComposer,
      $$TiposDispositivoTableOrderingComposer,
      $$TiposDispositivoTableAnnotationComposer,
      $$TiposDispositivoTableCreateCompanionBuilder,
      $$TiposDispositivoTableUpdateCompanionBuilder,
      (TipoDispositivoData, $$TiposDispositivoTableReferences),
      TipoDispositivoData,
      PrefetchHooks Function({bool dispositivosRefs, bool emprestimoItensRefs})
    >;
typedef $$EmprestimoStatusTableCreateCompanionBuilder =
    EmprestimoStatusCompanion Function({
      Value<int> id,
      required String nomeStatus,
    });
typedef $$EmprestimoStatusTableUpdateCompanionBuilder =
    EmprestimoStatusCompanion Function({
      Value<int> id,
      Value<String> nomeStatus,
    });

final class $$EmprestimoStatusTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EmprestimoStatusTable,
          EmprestimoStatusData
        > {
  $$EmprestimoStatusTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DispositivosTable, List<DispositivoData>>
  _dispositivosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dispositivos,
    aliasName: $_aliasNameGenerator(
      db.emprestimoStatus.id,
      db.dispositivos.idStatus,
    ),
  );

  $$DispositivosTableProcessedTableManager get dispositivosRefs {
    final manager = $$DispositivosTableTableManager(
      $_db,
      $_db.dispositivos,
    ).filter((f) => f.idStatus.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dispositivosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EmprestimosTable, List<EmprestimoData>>
  _emprestimosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimos,
    aliasName: $_aliasNameGenerator(
      db.emprestimoStatus.id,
      db.emprestimos.idStatus,
    ),
  );

  $$EmprestimosTableProcessedTableManager get emprestimosRefs {
    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.idStatus.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emprestimosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmprestimoStatusTableFilterComposer
    extends Composer<_$AppDatabase, $EmprestimoStatusTable> {
  $$EmprestimoStatusTableFilterComposer({
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

  ColumnFilters<String> get nomeStatus => $composableBuilder(
    column: $table.nomeStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dispositivosRefs(
    Expression<bool> Function($$DispositivosTableFilterComposer f) f,
  ) {
    final $$DispositivosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.idStatus,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableFilterComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> emprestimosRefs(
    Expression<bool> Function($$EmprestimosTableFilterComposer f) f,
  ) {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.idStatus,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimoStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $EmprestimoStatusTable> {
  $$EmprestimoStatusTableOrderingComposer({
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

  ColumnOrderings<String> get nomeStatus => $composableBuilder(
    column: $table.nomeStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmprestimoStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmprestimoStatusTable> {
  $$EmprestimoStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomeStatus => $composableBuilder(
    column: $table.nomeStatus,
    builder: (column) => column,
  );

  Expression<T> dispositivosRefs<T extends Object>(
    Expression<T> Function($$DispositivosTableAnnotationComposer a) f,
  ) {
    final $$DispositivosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.idStatus,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableAnnotationComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> emprestimosRefs<T extends Object>(
    Expression<T> Function($$EmprestimosTableAnnotationComposer a) f,
  ) {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.idStatus,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimoStatusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmprestimoStatusTable,
          EmprestimoStatusData,
          $$EmprestimoStatusTableFilterComposer,
          $$EmprestimoStatusTableOrderingComposer,
          $$EmprestimoStatusTableAnnotationComposer,
          $$EmprestimoStatusTableCreateCompanionBuilder,
          $$EmprestimoStatusTableUpdateCompanionBuilder,
          (EmprestimoStatusData, $$EmprestimoStatusTableReferences),
          EmprestimoStatusData,
          PrefetchHooks Function({bool dispositivosRefs, bool emprestimosRefs})
        > {
  $$EmprestimoStatusTableTableManager(
    _$AppDatabase db,
    $EmprestimoStatusTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmprestimoStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmprestimoStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmprestimoStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nomeStatus = const Value.absent(),
              }) => EmprestimoStatusCompanion(id: id, nomeStatus: nomeStatus),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nomeStatus,
              }) => EmprestimoStatusCompanion.insert(
                id: id,
                nomeStatus: nomeStatus,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmprestimoStatusTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({dispositivosRefs = false, emprestimosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dispositivosRefs) db.dispositivos,
                    if (emprestimosRefs) db.emprestimos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dispositivosRefs)
                        await $_getPrefetchedData<
                          EmprestimoStatusData,
                          $EmprestimoStatusTable,
                          DispositivoData
                        >(
                          currentTable: table,
                          referencedTable: $$EmprestimoStatusTableReferences
                              ._dispositivosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmprestimoStatusTableReferences(
                                db,
                                table,
                                p0,
                              ).dispositivosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idStatus == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (emprestimosRefs)
                        await $_getPrefetchedData<
                          EmprestimoStatusData,
                          $EmprestimoStatusTable,
                          EmprestimoData
                        >(
                          currentTable: table,
                          referencedTable: $$EmprestimoStatusTableReferences
                              ._emprestimosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmprestimoStatusTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idStatus == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmprestimoStatusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmprestimoStatusTable,
      EmprestimoStatusData,
      $$EmprestimoStatusTableFilterComposer,
      $$EmprestimoStatusTableOrderingComposer,
      $$EmprestimoStatusTableAnnotationComposer,
      $$EmprestimoStatusTableCreateCompanionBuilder,
      $$EmprestimoStatusTableUpdateCompanionBuilder,
      (EmprestimoStatusData, $$EmprestimoStatusTableReferences),
      EmprestimoStatusData,
      PrefetchHooks Function({bool dispositivosRefs, bool emprestimosRefs})
    >;
typedef $$DispositivosTableCreateCompanionBuilder =
    DispositivosCompanion Function({
      Value<int> id,
      required int numSerie,
      required int numPatrimonio,
      required int idTipoDispositivo,
      required int idStatus,
      required int qtdTotal,
      required int qtdDisponivel,
    });
typedef $$DispositivosTableUpdateCompanionBuilder =
    DispositivosCompanion Function({
      Value<int> id,
      Value<int> numSerie,
      Value<int> numPatrimonio,
      Value<int> idTipoDispositivo,
      Value<int> idStatus,
      Value<int> qtdTotal,
      Value<int> qtdDisponivel,
    });

final class $$DispositivosTableReferences
    extends BaseReferences<_$AppDatabase, $DispositivosTable, DispositivoData> {
  $$DispositivosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TiposDispositivoTable _idTipoDispositivoTable(_$AppDatabase db) =>
      db.tiposDispositivo.createAlias(
        $_aliasNameGenerator(
          db.dispositivos.idTipoDispositivo,
          db.tiposDispositivo.id,
        ),
      );

  $$TiposDispositivoTableProcessedTableManager get idTipoDispositivo {
    final $_column = $_itemColumn<int>('id_tipo_dispositivo')!;

    final manager = $$TiposDispositivoTableTableManager(
      $_db,
      $_db.tiposDispositivo,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idTipoDispositivoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmprestimoStatusTable _idStatusTable(_$AppDatabase db) =>
      db.emprestimoStatus.createAlias(
        $_aliasNameGenerator(db.dispositivos.idStatus, db.emprestimoStatus.id),
      );

  $$EmprestimoStatusTableProcessedTableManager get idStatus {
    final $_column = $_itemColumn<int>('id_status')!;

    final manager = $$EmprestimoStatusTableTableManager(
      $_db,
      $_db.emprestimoStatus,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idStatusTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $EmprestimoDispositivosTable,
    List<EmprestimoDispositivoData>
  >
  _emprestimoDispositivosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.emprestimoDispositivos,
        aliasName: $_aliasNameGenerator(
          db.dispositivos.id,
          db.emprestimoDispositivos.idDispositivo,
        ),
      );

  $$EmprestimoDispositivosTableProcessedTableManager
  get emprestimoDispositivosRefs {
    final manager = $$EmprestimoDispositivosTableTableManager(
      $_db,
      $_db.emprestimoDispositivos,
    ).filter((f) => f.idDispositivo.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emprestimoDispositivosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProblemasTable, List<ProblemaData>>
  _problemasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.problemas,
    aliasName: $_aliasNameGenerator(
      db.dispositivos.id,
      db.problemas.idDispositivo,
    ),
  );

  $$ProblemasTableProcessedTableManager get problemasRefs {
    final manager = $$ProblemasTableTableManager(
      $_db,
      $_db.problemas,
    ).filter((f) => f.idDispositivo.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_problemasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DispositivosTableFilterComposer
    extends Composer<_$AppDatabase, $DispositivosTable> {
  $$DispositivosTableFilterComposer({
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

  ColumnFilters<int> get numSerie => $composableBuilder(
    column: $table.numSerie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numPatrimonio => $composableBuilder(
    column: $table.numPatrimonio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtdTotal => $composableBuilder(
    column: $table.qtdTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtdDisponivel => $composableBuilder(
    column: $table.qtdDisponivel,
    builder: (column) => ColumnFilters(column),
  );

  $$TiposDispositivoTableFilterComposer get idTipoDispositivo {
    final $$TiposDispositivoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTipoDispositivo,
      referencedTable: $db.tiposDispositivo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDispositivoTableFilterComposer(
            $db: $db,
            $table: $db.tiposDispositivo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimoStatusTableFilterComposer get idStatus {
    final $$EmprestimoStatusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idStatus,
      referencedTable: $db.emprestimoStatus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoStatusTableFilterComposer(
            $db: $db,
            $table: $db.emprestimoStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimoDispositivosRefs(
    Expression<bool> Function($$EmprestimoDispositivosTableFilterComposer f) f,
  ) {
    final $$EmprestimoDispositivosTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.emprestimoDispositivos,
          getReferencedColumn: (t) => t.idDispositivo,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmprestimoDispositivosTableFilterComposer(
                $db: $db,
                $table: $db.emprestimoDispositivos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> problemasRefs(
    Expression<bool> Function($$ProblemasTableFilterComposer f) f,
  ) {
    final $$ProblemasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.problemas,
      getReferencedColumn: (t) => t.idDispositivo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProblemasTableFilterComposer(
            $db: $db,
            $table: $db.problemas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DispositivosTableOrderingComposer
    extends Composer<_$AppDatabase, $DispositivosTable> {
  $$DispositivosTableOrderingComposer({
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

  ColumnOrderings<int> get numSerie => $composableBuilder(
    column: $table.numSerie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numPatrimonio => $composableBuilder(
    column: $table.numPatrimonio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtdTotal => $composableBuilder(
    column: $table.qtdTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtdDisponivel => $composableBuilder(
    column: $table.qtdDisponivel,
    builder: (column) => ColumnOrderings(column),
  );

  $$TiposDispositivoTableOrderingComposer get idTipoDispositivo {
    final $$TiposDispositivoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTipoDispositivo,
      referencedTable: $db.tiposDispositivo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDispositivoTableOrderingComposer(
            $db: $db,
            $table: $db.tiposDispositivo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimoStatusTableOrderingComposer get idStatus {
    final $$EmprestimoStatusTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idStatus,
      referencedTable: $db.emprestimoStatus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoStatusTableOrderingComposer(
            $db: $db,
            $table: $db.emprestimoStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DispositivosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DispositivosTable> {
  $$DispositivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numSerie =>
      $composableBuilder(column: $table.numSerie, builder: (column) => column);

  GeneratedColumn<int> get numPatrimonio => $composableBuilder(
    column: $table.numPatrimonio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qtdTotal =>
      $composableBuilder(column: $table.qtdTotal, builder: (column) => column);

  GeneratedColumn<int> get qtdDisponivel => $composableBuilder(
    column: $table.qtdDisponivel,
    builder: (column) => column,
  );

  $$TiposDispositivoTableAnnotationComposer get idTipoDispositivo {
    final $$TiposDispositivoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTipoDispositivo,
      referencedTable: $db.tiposDispositivo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDispositivoTableAnnotationComposer(
            $db: $db,
            $table: $db.tiposDispositivo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimoStatusTableAnnotationComposer get idStatus {
    final $$EmprestimoStatusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idStatus,
      referencedTable: $db.emprestimoStatus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoStatusTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimoStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimoDispositivosRefs<T extends Object>(
    Expression<T> Function($$EmprestimoDispositivosTableAnnotationComposer a) f,
  ) {
    final $$EmprestimoDispositivosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.emprestimoDispositivos,
          getReferencedColumn: (t) => t.idDispositivo,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmprestimoDispositivosTableAnnotationComposer(
                $db: $db,
                $table: $db.emprestimoDispositivos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> problemasRefs<T extends Object>(
    Expression<T> Function($$ProblemasTableAnnotationComposer a) f,
  ) {
    final $$ProblemasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.problemas,
      getReferencedColumn: (t) => t.idDispositivo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProblemasTableAnnotationComposer(
            $db: $db,
            $table: $db.problemas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DispositivosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DispositivosTable,
          DispositivoData,
          $$DispositivosTableFilterComposer,
          $$DispositivosTableOrderingComposer,
          $$DispositivosTableAnnotationComposer,
          $$DispositivosTableCreateCompanionBuilder,
          $$DispositivosTableUpdateCompanionBuilder,
          (DispositivoData, $$DispositivosTableReferences),
          DispositivoData,
          PrefetchHooks Function({
            bool idTipoDispositivo,
            bool idStatus,
            bool emprestimoDispositivosRefs,
            bool problemasRefs,
          })
        > {
  $$DispositivosTableTableManager(_$AppDatabase db, $DispositivosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DispositivosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DispositivosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DispositivosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> numSerie = const Value.absent(),
                Value<int> numPatrimonio = const Value.absent(),
                Value<int> idTipoDispositivo = const Value.absent(),
                Value<int> idStatus = const Value.absent(),
                Value<int> qtdTotal = const Value.absent(),
                Value<int> qtdDisponivel = const Value.absent(),
              }) => DispositivosCompanion(
                id: id,
                numSerie: numSerie,
                numPatrimonio: numPatrimonio,
                idTipoDispositivo: idTipoDispositivo,
                idStatus: idStatus,
                qtdTotal: qtdTotal,
                qtdDisponivel: qtdDisponivel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int numSerie,
                required int numPatrimonio,
                required int idTipoDispositivo,
                required int idStatus,
                required int qtdTotal,
                required int qtdDisponivel,
              }) => DispositivosCompanion.insert(
                id: id,
                numSerie: numSerie,
                numPatrimonio: numPatrimonio,
                idTipoDispositivo: idTipoDispositivo,
                idStatus: idStatus,
                qtdTotal: qtdTotal,
                qtdDisponivel: qtdDisponivel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DispositivosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idTipoDispositivo = false,
                idStatus = false,
                emprestimoDispositivosRefs = false,
                problemasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (emprestimoDispositivosRefs) db.emprestimoDispositivos,
                    if (problemasRefs) db.problemas,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idTipoDispositivo) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idTipoDispositivo,
                                    referencedTable:
                                        $$DispositivosTableReferences
                                            ._idTipoDispositivoTable(db),
                                    referencedColumn:
                                        $$DispositivosTableReferences
                                            ._idTipoDispositivoTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (idStatus) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idStatus,
                                    referencedTable:
                                        $$DispositivosTableReferences
                                            ._idStatusTable(db),
                                    referencedColumn:
                                        $$DispositivosTableReferences
                                            ._idStatusTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (emprestimoDispositivosRefs)
                        await $_getPrefetchedData<
                          DispositivoData,
                          $DispositivosTable,
                          EmprestimoDispositivoData
                        >(
                          currentTable: table,
                          referencedTable: $$DispositivosTableReferences
                              ._emprestimoDispositivosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DispositivosTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimoDispositivosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idDispositivo == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (problemasRefs)
                        await $_getPrefetchedData<
                          DispositivoData,
                          $DispositivosTable,
                          ProblemaData
                        >(
                          currentTable: table,
                          referencedTable: $$DispositivosTableReferences
                              ._problemasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DispositivosTableReferences(
                                db,
                                table,
                                p0,
                              ).problemasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idDispositivo == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DispositivosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DispositivosTable,
      DispositivoData,
      $$DispositivosTableFilterComposer,
      $$DispositivosTableOrderingComposer,
      $$DispositivosTableAnnotationComposer,
      $$DispositivosTableCreateCompanionBuilder,
      $$DispositivosTableUpdateCompanionBuilder,
      (DispositivoData, $$DispositivosTableReferences),
      DispositivoData,
      PrefetchHooks Function({
        bool idTipoDispositivo,
        bool idStatus,
        bool emprestimoDispositivosRefs,
        bool problemasRefs,
      })
    >;
typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      required String nome,
      required int idCargo,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<int> idCargo,
    });

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, UsuarioData> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CargosTable _idCargoTable(_$AppDatabase db) => db.cargos.createAlias(
    $_aliasNameGenerator(db.usuarios.idCargo, db.cargos.id),
  );

  $$CargosTableProcessedTableManager get idCargo {
    final $_column = $_itemColumn<int>('id_cargo')!;

    final manager = $$CargosTableTableManager(
      $_db,
      $_db.cargos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idCargoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EmprestimosTable, List<EmprestimoData>>
  _emprestimosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimos,
    aliasName: $_aliasNameGenerator(
      db.usuarios.id,
      db.emprestimos.idResponsavel,
    ),
  );

  $$EmprestimosTableProcessedTableManager get emprestimosRefs {
    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.idResponsavel.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emprestimosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  $$CargosTableFilterComposer get idCargo {
    final $$CargosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCargo,
      referencedTable: $db.cargos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CargosTableFilterComposer(
            $db: $db,
            $table: $db.cargos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimosRefs(
    Expression<bool> Function($$EmprestimosTableFilterComposer f) f,
  ) {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.idResponsavel,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  $$CargosTableOrderingComposer get idCargo {
    final $$CargosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCargo,
      referencedTable: $db.cargos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CargosTableOrderingComposer(
            $db: $db,
            $table: $db.cargos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  $$CargosTableAnnotationComposer get idCargo {
    final $$CargosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCargo,
      referencedTable: $db.cargos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CargosTableAnnotationComposer(
            $db: $db,
            $table: $db.cargos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimosRefs<T extends Object>(
    Expression<T> Function($$EmprestimosTableAnnotationComposer a) f,
  ) {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.idResponsavel,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          UsuarioData,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (UsuarioData, $$UsuariosTableReferences),
          UsuarioData,
          PrefetchHooks Function({bool idCargo, bool emprestimosRefs})
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int> idCargo = const Value.absent(),
              }) => UsuariosCompanion(id: id, nome: nome, idCargo: idCargo),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required int idCargo,
              }) => UsuariosCompanion.insert(
                id: id,
                nome: nome,
                idCargo: idCargo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsuariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idCargo = false, emprestimosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (emprestimosRefs) db.emprestimos],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idCargo) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idCargo,
                                referencedTable: $$UsuariosTableReferences
                                    ._idCargoTable(db),
                                referencedColumn: $$UsuariosTableReferences
                                    ._idCargoTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (emprestimosRefs)
                    await $_getPrefetchedData<
                      UsuarioData,
                      $UsuariosTable,
                      EmprestimoData
                    >(
                      currentTable: table,
                      referencedTable: $$UsuariosTableReferences
                          ._emprestimosRefsTable(db),
                      managerFromTypedResult: (p0) => $$UsuariosTableReferences(
                        db,
                        table,
                        p0,
                      ).emprestimosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idResponsavel == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      UsuarioData,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (UsuarioData, $$UsuariosTableReferences),
      UsuarioData,
      PrefetchHooks Function({bool idCargo, bool emprestimosRefs})
    >;
typedef $$EmprestimosTableCreateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      required DateTime dataHoraEfetuado,
      Value<DateTime?> dataHoraConcluido,
      required int idResponsavel,
      required int idStatus,
    });
typedef $$EmprestimosTableUpdateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      Value<DateTime> dataHoraEfetuado,
      Value<DateTime?> dataHoraConcluido,
      Value<int> idResponsavel,
      Value<int> idStatus,
    });

final class $$EmprestimosTableReferences
    extends BaseReferences<_$AppDatabase, $EmprestimosTable, EmprestimoData> {
  $$EmprestimosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _idResponsavelTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.emprestimos.idResponsavel, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get idResponsavel {
    final $_column = $_itemColumn<int>('id_responsavel')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idResponsavelTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmprestimoStatusTable _idStatusTable(_$AppDatabase db) =>
      db.emprestimoStatus.createAlias(
        $_aliasNameGenerator(db.emprestimos.idStatus, db.emprestimoStatus.id),
      );

  $$EmprestimoStatusTableProcessedTableManager get idStatus {
    final $_column = $_itemColumn<int>('id_status')!;

    final manager = $$EmprestimoStatusTableTableManager(
      $_db,
      $_db.emprestimoStatus,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idStatusTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EmprestimoItensTable, List<EmprestimoItemData>>
  _emprestimoItensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimoItens,
    aliasName: $_aliasNameGenerator(
      db.emprestimos.id,
      db.emprestimoItens.idEmprestimo,
    ),
  );

  $$EmprestimoItensTableProcessedTableManager get emprestimoItensRefs {
    final manager = $$EmprestimoItensTableTableManager(
      $_db,
      $_db.emprestimoItens,
    ).filter((f) => f.idEmprestimo.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emprestimoItensRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmprestimosTableFilterComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHoraEfetuado => $composableBuilder(
    column: $table.dataHoraEfetuado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHoraConcluido => $composableBuilder(
    column: $table.dataHoraConcluido,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get idResponsavel {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idResponsavel,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimoStatusTableFilterComposer get idStatus {
    final $$EmprestimoStatusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idStatus,
      referencedTable: $db.emprestimoStatus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoStatusTableFilterComposer(
            $db: $db,
            $table: $db.emprestimoStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimoItensRefs(
    Expression<bool> Function($$EmprestimoItensTableFilterComposer f) f,
  ) {
    final $$EmprestimoItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.idEmprestimo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableFilterComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimosTableOrderingComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHoraEfetuado => $composableBuilder(
    column: $table.dataHoraEfetuado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHoraConcluido => $composableBuilder(
    column: $table.dataHoraConcluido,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get idResponsavel {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idResponsavel,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimoStatusTableOrderingComposer get idStatus {
    final $$EmprestimoStatusTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idStatus,
      referencedTable: $db.emprestimoStatus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoStatusTableOrderingComposer(
            $db: $db,
            $table: $db.emprestimoStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHoraEfetuado => $composableBuilder(
    column: $table.dataHoraEfetuado,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataHoraConcluido => $composableBuilder(
    column: $table.dataHoraConcluido,
    builder: (column) => column,
  );

  $$UsuariosTableAnnotationComposer get idResponsavel {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idResponsavel,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimoStatusTableAnnotationComposer get idStatus {
    final $$EmprestimoStatusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idStatus,
      referencedTable: $db.emprestimoStatus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoStatusTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimoStatus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimoItensRefs<T extends Object>(
    Expression<T> Function($$EmprestimoItensTableAnnotationComposer a) f,
  ) {
    final $$EmprestimoItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.idEmprestimo,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmprestimosTable,
          EmprestimoData,
          $$EmprestimosTableFilterComposer,
          $$EmprestimosTableOrderingComposer,
          $$EmprestimosTableAnnotationComposer,
          $$EmprestimosTableCreateCompanionBuilder,
          $$EmprestimosTableUpdateCompanionBuilder,
          (EmprestimoData, $$EmprestimosTableReferences),
          EmprestimoData,
          PrefetchHooks Function({
            bool idResponsavel,
            bool idStatus,
            bool emprestimoItensRefs,
          })
        > {
  $$EmprestimosTableTableManager(_$AppDatabase db, $EmprestimosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmprestimosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmprestimosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmprestimosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> dataHoraEfetuado = const Value.absent(),
                Value<DateTime?> dataHoraConcluido = const Value.absent(),
                Value<int> idResponsavel = const Value.absent(),
                Value<int> idStatus = const Value.absent(),
              }) => EmprestimosCompanion(
                id: id,
                dataHoraEfetuado: dataHoraEfetuado,
                dataHoraConcluido: dataHoraConcluido,
                idResponsavel: idResponsavel,
                idStatus: idStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime dataHoraEfetuado,
                Value<DateTime?> dataHoraConcluido = const Value.absent(),
                required int idResponsavel,
                required int idStatus,
              }) => EmprestimosCompanion.insert(
                id: id,
                dataHoraEfetuado: dataHoraEfetuado,
                dataHoraConcluido: dataHoraConcluido,
                idResponsavel: idResponsavel,
                idStatus: idStatus,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmprestimosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idResponsavel = false,
                idStatus = false,
                emprestimoItensRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (emprestimoItensRefs) db.emprestimoItens,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idResponsavel) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idResponsavel,
                                    referencedTable:
                                        $$EmprestimosTableReferences
                                            ._idResponsavelTable(db),
                                    referencedColumn:
                                        $$EmprestimosTableReferences
                                            ._idResponsavelTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (idStatus) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idStatus,
                                    referencedTable:
                                        $$EmprestimosTableReferences
                                            ._idStatusTable(db),
                                    referencedColumn:
                                        $$EmprestimosTableReferences
                                            ._idStatusTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (emprestimoItensRefs)
                        await $_getPrefetchedData<
                          EmprestimoData,
                          $EmprestimosTable,
                          EmprestimoItemData
                        >(
                          currentTable: table,
                          referencedTable: $$EmprestimosTableReferences
                              ._emprestimoItensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmprestimosTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimoItensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idEmprestimo == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmprestimosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmprestimosTable,
      EmprestimoData,
      $$EmprestimosTableFilterComposer,
      $$EmprestimosTableOrderingComposer,
      $$EmprestimosTableAnnotationComposer,
      $$EmprestimosTableCreateCompanionBuilder,
      $$EmprestimosTableUpdateCompanionBuilder,
      (EmprestimoData, $$EmprestimosTableReferences),
      EmprestimoData,
      PrefetchHooks Function({
        bool idResponsavel,
        bool idStatus,
        bool emprestimoItensRefs,
      })
    >;
typedef $$EmprestimoItensTableCreateCompanionBuilder =
    EmprestimoItensCompanion Function({
      Value<int> id,
      required int idEmprestimo,
      required int idTipoDispositivo,
      required int qtdSolicitada,
      required int qtdDevolvida,
      required bool estaResolvido,
    });
typedef $$EmprestimoItensTableUpdateCompanionBuilder =
    EmprestimoItensCompanion Function({
      Value<int> id,
      Value<int> idEmprestimo,
      Value<int> idTipoDispositivo,
      Value<int> qtdSolicitada,
      Value<int> qtdDevolvida,
      Value<bool> estaResolvido,
    });

final class $$EmprestimoItensTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EmprestimoItensTable,
          EmprestimoItemData
        > {
  $$EmprestimoItensTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmprestimosTable _idEmprestimoTable(_$AppDatabase db) =>
      db.emprestimos.createAlias(
        $_aliasNameGenerator(
          db.emprestimoItens.idEmprestimo,
          db.emprestimos.id,
        ),
      );

  $$EmprestimosTableProcessedTableManager get idEmprestimo {
    final $_column = $_itemColumn<int>('id_emprestimo')!;

    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idEmprestimoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TiposDispositivoTable _idTipoDispositivoTable(_$AppDatabase db) =>
      db.tiposDispositivo.createAlias(
        $_aliasNameGenerator(
          db.emprestimoItens.idTipoDispositivo,
          db.tiposDispositivo.id,
        ),
      );

  $$TiposDispositivoTableProcessedTableManager get idTipoDispositivo {
    final $_column = $_itemColumn<int>('id_tipo_dispositivo')!;

    final manager = $$TiposDispositivoTableTableManager(
      $_db,
      $_db.tiposDispositivo,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idTipoDispositivoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $EmprestimoDispositivosTable,
    List<EmprestimoDispositivoData>
  >
  _emprestimoDispositivosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.emprestimoDispositivos,
        aliasName: $_aliasNameGenerator(
          db.emprestimoItens.id,
          db.emprestimoDispositivos.idEmprestimoItem,
        ),
      );

  $$EmprestimoDispositivosTableProcessedTableManager
  get emprestimoDispositivosRefs {
    final manager = $$EmprestimoDispositivosTableTableManager(
      $_db,
      $_db.emprestimoDispositivos,
    ).filter((f) => f.idEmprestimoItem.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emprestimoDispositivosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmprestimoItensTableFilterComposer
    extends Composer<_$AppDatabase, $EmprestimoItensTable> {
  $$EmprestimoItensTableFilterComposer({
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

  ColumnFilters<int> get qtdSolicitada => $composableBuilder(
    column: $table.qtdSolicitada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtdDevolvida => $composableBuilder(
    column: $table.qtdDevolvida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estaResolvido => $composableBuilder(
    column: $table.estaResolvido,
    builder: (column) => ColumnFilters(column),
  );

  $$EmprestimosTableFilterComposer get idEmprestimo {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idEmprestimo,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiposDispositivoTableFilterComposer get idTipoDispositivo {
    final $$TiposDispositivoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTipoDispositivo,
      referencedTable: $db.tiposDispositivo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDispositivoTableFilterComposer(
            $db: $db,
            $table: $db.tiposDispositivo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimoDispositivosRefs(
    Expression<bool> Function($$EmprestimoDispositivosTableFilterComposer f) f,
  ) {
    final $$EmprestimoDispositivosTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.emprestimoDispositivos,
          getReferencedColumn: (t) => t.idEmprestimoItem,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmprestimoDispositivosTableFilterComposer(
                $db: $db,
                $table: $db.emprestimoDispositivos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EmprestimoItensTableOrderingComposer
    extends Composer<_$AppDatabase, $EmprestimoItensTable> {
  $$EmprestimoItensTableOrderingComposer({
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

  ColumnOrderings<int> get qtdSolicitada => $composableBuilder(
    column: $table.qtdSolicitada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtdDevolvida => $composableBuilder(
    column: $table.qtdDevolvida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estaResolvido => $composableBuilder(
    column: $table.estaResolvido,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmprestimosTableOrderingComposer get idEmprestimo {
    final $$EmprestimosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idEmprestimo,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableOrderingComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiposDispositivoTableOrderingComposer get idTipoDispositivo {
    final $$TiposDispositivoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTipoDispositivo,
      referencedTable: $db.tiposDispositivo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDispositivoTableOrderingComposer(
            $db: $db,
            $table: $db.tiposDispositivo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimoItensTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmprestimoItensTable> {
  $$EmprestimoItensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get qtdSolicitada => $composableBuilder(
    column: $table.qtdSolicitada,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qtdDevolvida => $composableBuilder(
    column: $table.qtdDevolvida,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get estaResolvido => $composableBuilder(
    column: $table.estaResolvido,
    builder: (column) => column,
  );

  $$EmprestimosTableAnnotationComposer get idEmprestimo {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idEmprestimo,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TiposDispositivoTableAnnotationComposer get idTipoDispositivo {
    final $$TiposDispositivoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTipoDispositivo,
      referencedTable: $db.tiposDispositivo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposDispositivoTableAnnotationComposer(
            $db: $db,
            $table: $db.tiposDispositivo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimoDispositivosRefs<T extends Object>(
    Expression<T> Function($$EmprestimoDispositivosTableAnnotationComposer a) f,
  ) {
    final $$EmprestimoDispositivosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.emprestimoDispositivos,
          getReferencedColumn: (t) => t.idEmprestimoItem,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmprestimoDispositivosTableAnnotationComposer(
                $db: $db,
                $table: $db.emprestimoDispositivos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EmprestimoItensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmprestimoItensTable,
          EmprestimoItemData,
          $$EmprestimoItensTableFilterComposer,
          $$EmprestimoItensTableOrderingComposer,
          $$EmprestimoItensTableAnnotationComposer,
          $$EmprestimoItensTableCreateCompanionBuilder,
          $$EmprestimoItensTableUpdateCompanionBuilder,
          (EmprestimoItemData, $$EmprestimoItensTableReferences),
          EmprestimoItemData,
          PrefetchHooks Function({
            bool idEmprestimo,
            bool idTipoDispositivo,
            bool emprestimoDispositivosRefs,
          })
        > {
  $$EmprestimoItensTableTableManager(
    _$AppDatabase db,
    $EmprestimoItensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmprestimoItensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmprestimoItensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmprestimoItensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idEmprestimo = const Value.absent(),
                Value<int> idTipoDispositivo = const Value.absent(),
                Value<int> qtdSolicitada = const Value.absent(),
                Value<int> qtdDevolvida = const Value.absent(),
                Value<bool> estaResolvido = const Value.absent(),
              }) => EmprestimoItensCompanion(
                id: id,
                idEmprestimo: idEmprestimo,
                idTipoDispositivo: idTipoDispositivo,
                qtdSolicitada: qtdSolicitada,
                qtdDevolvida: qtdDevolvida,
                estaResolvido: estaResolvido,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idEmprestimo,
                required int idTipoDispositivo,
                required int qtdSolicitada,
                required int qtdDevolvida,
                required bool estaResolvido,
              }) => EmprestimoItensCompanion.insert(
                id: id,
                idEmprestimo: idEmprestimo,
                idTipoDispositivo: idTipoDispositivo,
                qtdSolicitada: qtdSolicitada,
                qtdDevolvida: qtdDevolvida,
                estaResolvido: estaResolvido,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmprestimoItensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idEmprestimo = false,
                idTipoDispositivo = false,
                emprestimoDispositivosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (emprestimoDispositivosRefs) db.emprestimoDispositivos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idEmprestimo) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idEmprestimo,
                                    referencedTable:
                                        $$EmprestimoItensTableReferences
                                            ._idEmprestimoTable(db),
                                    referencedColumn:
                                        $$EmprestimoItensTableReferences
                                            ._idEmprestimoTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (idTipoDispositivo) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idTipoDispositivo,
                                    referencedTable:
                                        $$EmprestimoItensTableReferences
                                            ._idTipoDispositivoTable(db),
                                    referencedColumn:
                                        $$EmprestimoItensTableReferences
                                            ._idTipoDispositivoTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (emprestimoDispositivosRefs)
                        await $_getPrefetchedData<
                          EmprestimoItemData,
                          $EmprestimoItensTable,
                          EmprestimoDispositivoData
                        >(
                          currentTable: table,
                          referencedTable: $$EmprestimoItensTableReferences
                              ._emprestimoDispositivosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmprestimoItensTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimoDispositivosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idEmprestimoItem == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmprestimoItensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmprestimoItensTable,
      EmprestimoItemData,
      $$EmprestimoItensTableFilterComposer,
      $$EmprestimoItensTableOrderingComposer,
      $$EmprestimoItensTableAnnotationComposer,
      $$EmprestimoItensTableCreateCompanionBuilder,
      $$EmprestimoItensTableUpdateCompanionBuilder,
      (EmprestimoItemData, $$EmprestimoItensTableReferences),
      EmprestimoItemData,
      PrefetchHooks Function({
        bool idEmprestimo,
        bool idTipoDispositivo,
        bool emprestimoDispositivosRefs,
      })
    >;
typedef $$EmprestimoDispositivosTableCreateCompanionBuilder =
    EmprestimoDispositivosCompanion Function({
      Value<int> id,
      required int idEmprestimoItem,
      Value<int?> idDispositivo,
    });
typedef $$EmprestimoDispositivosTableUpdateCompanionBuilder =
    EmprestimoDispositivosCompanion Function({
      Value<int> id,
      Value<int> idEmprestimoItem,
      Value<int?> idDispositivo,
    });

final class $$EmprestimoDispositivosTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EmprestimoDispositivosTable,
          EmprestimoDispositivoData
        > {
  $$EmprestimoDispositivosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmprestimoItensTable _idEmprestimoItemTable(_$AppDatabase db) =>
      db.emprestimoItens.createAlias(
        $_aliasNameGenerator(
          db.emprestimoDispositivos.idEmprestimoItem,
          db.emprestimoItens.id,
        ),
      );

  $$EmprestimoItensTableProcessedTableManager get idEmprestimoItem {
    final $_column = $_itemColumn<int>('id_emprestimo_item')!;

    final manager = $$EmprestimoItensTableTableManager(
      $_db,
      $_db.emprestimoItens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idEmprestimoItemTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DispositivosTable _idDispositivoTable(_$AppDatabase db) =>
      db.dispositivos.createAlias(
        $_aliasNameGenerator(
          db.emprestimoDispositivos.idDispositivo,
          db.dispositivos.id,
        ),
      );

  $$DispositivosTableProcessedTableManager? get idDispositivo {
    final $_column = $_itemColumn<int>('id_dispositivo');
    if ($_column == null) return null;
    final manager = $$DispositivosTableTableManager(
      $_db,
      $_db.dispositivos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idDispositivoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmprestimoDispositivosTableFilterComposer
    extends Composer<_$AppDatabase, $EmprestimoDispositivosTable> {
  $$EmprestimoDispositivosTableFilterComposer({
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

  $$EmprestimoItensTableFilterComposer get idEmprestimoItem {
    final $$EmprestimoItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idEmprestimoItem,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableFilterComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DispositivosTableFilterComposer get idDispositivo {
    final $$DispositivosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDispositivo,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableFilterComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimoDispositivosTableOrderingComposer
    extends Composer<_$AppDatabase, $EmprestimoDispositivosTable> {
  $$EmprestimoDispositivosTableOrderingComposer({
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

  $$EmprestimoItensTableOrderingComposer get idEmprestimoItem {
    final $$EmprestimoItensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idEmprestimoItem,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableOrderingComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DispositivosTableOrderingComposer get idDispositivo {
    final $$DispositivosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDispositivo,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableOrderingComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimoDispositivosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmprestimoDispositivosTable> {
  $$EmprestimoDispositivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$EmprestimoItensTableAnnotationComposer get idEmprestimoItem {
    final $$EmprestimoItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idEmprestimoItem,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DispositivosTableAnnotationComposer get idDispositivo {
    final $$DispositivosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDispositivo,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableAnnotationComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimoDispositivosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmprestimoDispositivosTable,
          EmprestimoDispositivoData,
          $$EmprestimoDispositivosTableFilterComposer,
          $$EmprestimoDispositivosTableOrderingComposer,
          $$EmprestimoDispositivosTableAnnotationComposer,
          $$EmprestimoDispositivosTableCreateCompanionBuilder,
          $$EmprestimoDispositivosTableUpdateCompanionBuilder,
          (EmprestimoDispositivoData, $$EmprestimoDispositivosTableReferences),
          EmprestimoDispositivoData,
          PrefetchHooks Function({bool idEmprestimoItem, bool idDispositivo})
        > {
  $$EmprestimoDispositivosTableTableManager(
    _$AppDatabase db,
    $EmprestimoDispositivosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmprestimoDispositivosTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EmprestimoDispositivosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmprestimoDispositivosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idEmprestimoItem = const Value.absent(),
                Value<int?> idDispositivo = const Value.absent(),
              }) => EmprestimoDispositivosCompanion(
                id: id,
                idEmprestimoItem: idEmprestimoItem,
                idDispositivo: idDispositivo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idEmprestimoItem,
                Value<int?> idDispositivo = const Value.absent(),
              }) => EmprestimoDispositivosCompanion.insert(
                id: id,
                idEmprestimoItem: idEmprestimoItem,
                idDispositivo: idDispositivo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmprestimoDispositivosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({idEmprestimoItem = false, idDispositivo = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idEmprestimoItem) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idEmprestimoItem,
                                    referencedTable:
                                        $$EmprestimoDispositivosTableReferences
                                            ._idEmprestimoItemTable(db),
                                    referencedColumn:
                                        $$EmprestimoDispositivosTableReferences
                                            ._idEmprestimoItemTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (idDispositivo) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idDispositivo,
                                    referencedTable:
                                        $$EmprestimoDispositivosTableReferences
                                            ._idDispositivoTable(db),
                                    referencedColumn:
                                        $$EmprestimoDispositivosTableReferences
                                            ._idDispositivoTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$EmprestimoDispositivosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmprestimoDispositivosTable,
      EmprestimoDispositivoData,
      $$EmprestimoDispositivosTableFilterComposer,
      $$EmprestimoDispositivosTableOrderingComposer,
      $$EmprestimoDispositivosTableAnnotationComposer,
      $$EmprestimoDispositivosTableCreateCompanionBuilder,
      $$EmprestimoDispositivosTableUpdateCompanionBuilder,
      (EmprestimoDispositivoData, $$EmprestimoDispositivosTableReferences),
      EmprestimoDispositivoData,
      PrefetchHooks Function({bool idEmprestimoItem, bool idDispositivo})
    >;
typedef $$ProblemasTableCreateCompanionBuilder =
    ProblemasCompanion Function({
      Value<int> id,
      required int idDispositivo,
      required String descricao,
    });
typedef $$ProblemasTableUpdateCompanionBuilder =
    ProblemasCompanion Function({
      Value<int> id,
      Value<int> idDispositivo,
      Value<String> descricao,
    });

final class $$ProblemasTableReferences
    extends BaseReferences<_$AppDatabase, $ProblemasTable, ProblemaData> {
  $$ProblemasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DispositivosTable _idDispositivoTable(_$AppDatabase db) =>
      db.dispositivos.createAlias(
        $_aliasNameGenerator(db.problemas.idDispositivo, db.dispositivos.id),
      );

  $$DispositivosTableProcessedTableManager get idDispositivo {
    final $_column = $_itemColumn<int>('id_dispositivo')!;

    final manager = $$DispositivosTableTableManager(
      $_db,
      $_db.dispositivos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idDispositivoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProblemasTableFilterComposer
    extends Composer<_$AppDatabase, $ProblemasTable> {
  $$ProblemasTableFilterComposer({
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

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  $$DispositivosTableFilterComposer get idDispositivo {
    final $$DispositivosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDispositivo,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableFilterComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProblemasTableOrderingComposer
    extends Composer<_$AppDatabase, $ProblemasTable> {
  $$ProblemasTableOrderingComposer({
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

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  $$DispositivosTableOrderingComposer get idDispositivo {
    final $$DispositivosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDispositivo,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableOrderingComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProblemasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProblemasTable> {
  $$ProblemasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  $$DispositivosTableAnnotationComposer get idDispositivo {
    final $$DispositivosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDispositivo,
      referencedTable: $db.dispositivos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DispositivosTableAnnotationComposer(
            $db: $db,
            $table: $db.dispositivos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProblemasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProblemasTable,
          ProblemaData,
          $$ProblemasTableFilterComposer,
          $$ProblemasTableOrderingComposer,
          $$ProblemasTableAnnotationComposer,
          $$ProblemasTableCreateCompanionBuilder,
          $$ProblemasTableUpdateCompanionBuilder,
          (ProblemaData, $$ProblemasTableReferences),
          ProblemaData,
          PrefetchHooks Function({bool idDispositivo})
        > {
  $$ProblemasTableTableManager(_$AppDatabase db, $ProblemasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProblemasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProblemasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProblemasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idDispositivo = const Value.absent(),
                Value<String> descricao = const Value.absent(),
              }) => ProblemasCompanion(
                id: id,
                idDispositivo: idDispositivo,
                descricao: descricao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idDispositivo,
                required String descricao,
              }) => ProblemasCompanion.insert(
                id: id,
                idDispositivo: idDispositivo,
                descricao: descricao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProblemasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idDispositivo = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idDispositivo) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idDispositivo,
                                referencedTable: $$ProblemasTableReferences
                                    ._idDispositivoTable(db),
                                referencedColumn: $$ProblemasTableReferences
                                    ._idDispositivoTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProblemasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProblemasTable,
      ProblemaData,
      $$ProblemasTableFilterComposer,
      $$ProblemasTableOrderingComposer,
      $$ProblemasTableAnnotationComposer,
      $$ProblemasTableCreateCompanionBuilder,
      $$ProblemasTableUpdateCompanionBuilder,
      (ProblemaData, $$ProblemasTableReferences),
      ProblemaData,
      PrefetchHooks Function({bool idDispositivo})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CargosTableTableManager get cargos =>
      $$CargosTableTableManager(_db, _db.cargos);
  $$TiposDispositivoTableTableManager get tiposDispositivo =>
      $$TiposDispositivoTableTableManager(_db, _db.tiposDispositivo);
  $$EmprestimoStatusTableTableManager get emprestimoStatus =>
      $$EmprestimoStatusTableTableManager(_db, _db.emprestimoStatus);
  $$DispositivosTableTableManager get dispositivos =>
      $$DispositivosTableTableManager(_db, _db.dispositivos);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$EmprestimosTableTableManager get emprestimos =>
      $$EmprestimosTableTableManager(_db, _db.emprestimos);
  $$EmprestimoItensTableTableManager get emprestimoItens =>
      $$EmprestimoItensTableTableManager(_db, _db.emprestimoItens);
  $$EmprestimoDispositivosTableTableManager get emprestimoDispositivos =>
      $$EmprestimoDispositivosTableTableManager(
        _db,
        _db.emprestimoDispositivos,
      );
  $$ProblemasTableTableManager get problemas =>
      $$ProblemasTableTableManager(_db, _db.problemas);
}
