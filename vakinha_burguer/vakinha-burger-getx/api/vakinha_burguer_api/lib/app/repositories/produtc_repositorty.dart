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
    ;
  }
}
