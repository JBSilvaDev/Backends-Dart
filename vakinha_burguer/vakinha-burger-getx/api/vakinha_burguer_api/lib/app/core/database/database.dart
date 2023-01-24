import 'package:dotenv/dotenv.dart';
import 'package:mysql1/mysql1.dart';

class Database {
  Future<MySqlConnection> openConnection() async {
    final _conn = await MySqlConnection.connect(ConnectionSettings(
      host: env['DATABASE_HOST'] ?? env['databaseHost'] ?? '',
      port: int.tryParse(env['DATABASE_PORT'] ?? env['databaseHPort'] ?? '') ??
          3306,
      user: env['DATABASE_USER'] ?? env['databaseUser'],
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword'],
      db: env['DATABASE_NAME'] ?? env['databaseName'],
    ));
    await Future.delayed(Duration(seconds: 1));
    return _conn;
  }
}
