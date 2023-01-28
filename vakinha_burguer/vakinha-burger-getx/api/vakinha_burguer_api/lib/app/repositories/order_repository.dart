import 'dart:developer';

import 'package:mysql1/mysql1.dart';
import 'package:vakinha_burguer_api/app/core/database/database.dart';
import 'package:vakinha_burguer_api/app/view_models/order_view_model.dart';

class OrderRepository {
  Future<int> save(OrderViewModel order) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      var orderIdResponse = 0;
      await conn.transaction((_) async {
        final orderResult = await conn!.query("""
  insert into pedido(usuario_id, cpf_cliente, endereco_entrega, status_pedido)
  values(?,?,?,?)
""", [order.userId, order.cpf, order.address, 'P']);
        final orderId = orderResult.insertId;
        await conn.queryMulti('''
insert into pedido_item(quantidade, pedido_id, produto_id) values(?,?,?)
''', order.items.map((e) => [e.quantity, orderId, e.productId]));
        if (orderId != null) {
          orderIdResponse = orderId;
        }
      });

      return orderIdResponse;
    } on MySqlException catch (e, s) {
      log('Erro ao inserir pedido', error: e, stackTrace: s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<void> updateTransactionId(int orderId, String transactionId) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      await conn.query('update pedido set id_transacao = ? where id =?',
          [transactionId, orderId]);
    } on MySqlException catch (e, s) {
      log("Erro no pagamento", error: e, stackTrace: s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<void> confirmPaymentByTransactionId(String transaction) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      await conn.query(
          '''update pedido set status_pedido = ? where id_transacao = ?''',
          ['F', transaction]);
    } on MySqlException catch (e, s) {
      print('=' * 50);
      log('Erro no processamento de pagamento', error: e, stackTrace: s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
