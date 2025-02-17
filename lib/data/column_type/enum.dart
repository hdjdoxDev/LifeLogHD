
enum DatabaseColumnType {
  int,
  real,
  str,
  dt,
  bool,
  en,
  ref,
  ;

  String get sqflite {
    switch (this) {
      case DatabaseColumnType.int:
        return 'INTEGER';
      case DatabaseColumnType.real:
        return 'REAL';
      case DatabaseColumnType.str:
        return 'TEXT';
      case DatabaseColumnType.dt:
        return 'INTEGER';
      case DatabaseColumnType.bool:
        return 'INTEGER';
      case DatabaseColumnType.en:
        return 'TEXT';
      case DatabaseColumnType.ref:
        return 'TEXT';
    }
  }

  String get nice {
    switch (this) {
      case DatabaseColumnType.int:
        return 'Integer';
      case DatabaseColumnType.str:
        return 'Text';
      case DatabaseColumnType.dt:
        return 'Date';
      case DatabaseColumnType.bool:
        return 'Boolean';
      case DatabaseColumnType.en:
        return 'Enumeration';
      case DatabaseColumnType.ref:
        return 'Reference';
      default:
        return 'NoneType';
    }
  }
}
