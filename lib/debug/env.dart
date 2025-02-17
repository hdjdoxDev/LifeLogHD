// ignore: constant_identifier_names
enum Environment { DEV, PROD }

const env = Environment.PROD;
bool get dev => env == Environment.DEV;