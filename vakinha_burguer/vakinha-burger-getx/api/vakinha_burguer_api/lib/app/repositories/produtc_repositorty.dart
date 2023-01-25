import 'dart:developer';
import 'package:mysql1/mysql1.dart';
import 'package:vakinha_burguer_api/app/core/database/database.dart';
import 'package:vakinha_burguer_api/app/entities/product.dart';

class ProdutcRepositorty {
  Future<List<Product>> findAll() async {
    MySqlConnection? conn;

    try {
      conn = await Database().openConnection();
      final result = await conn.query('select * from produto');

      return result
          .map((produto) => Product(
                id: produto['id'],
                name: produto['nome'],
                description: (produto['descricao'] as Blob?)?.toString() ?? '',
                price: produto['preco'],
                image: (produto['imagem'] as Blob?)?.toString() ?? '',
              ))
          .toList();
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<Product> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final result =
          await conn.query(''' select * from produto where id =?''', [id]);
      final mysqlData = result.first;

      return Product(
        id: mysqlData['id'],
        name: mysqlData['nome'],
        description: (mysqlData['descricao'] as Blob?)?.toString() ?? "",
        price: mysqlData['preco'],
        image: (mysqlData['imagem'] as Blob?)?.toString()??"",
      );
    } on MySqlException catch (e, s) {
      log("Erro ao buscar produto", error: e, stackTrace: s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
