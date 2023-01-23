import 'package:mysql1/mysql1.dart';
import 'package:vakinha_burguer_api/app/core/database/database.dart';
import 'package:vakinha_burguer_api/app/core/exception/email_already_registered.dart';
import 'package:vakinha_burguer_api/app/core/helpers/crypto_helper.dart';
import 'package:vakinha_burguer_api/app/entities/user.dart';

class UserRepository {
  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final isUserRegister = await conn
          .query('select * from usuario where email = ?', [user.email]);
      if (isUserRegister.isEmpty) {
        await conn.query('''
          insert into usuario
          values(?,?,?,?)
        ''', [
          null,
          user.name,
          user.email,
          CryptoHelper.generatedSha256Hash(user.password)
        ]);
      } else {
        throw EmailAlreadyRegistered();
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
