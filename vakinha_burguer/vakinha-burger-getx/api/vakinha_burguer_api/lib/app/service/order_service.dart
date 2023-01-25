import 'package:vakinha_burguer_api/app/core/gerencianet/pix/gerencianet_pix.dart';
import 'package:vakinha_burguer_api/app/core/gerencianet/pix/models/qr_code_gerencianet_model.dart';
import 'package:vakinha_burguer_api/app/repositories/order_repository.dart';
import 'package:vakinha_burguer_api/app/repositories/produtc_repositorty.dart';
import 'package:vakinha_burguer_api/app/repositories/user_repository.dart';
import 'package:vakinha_burguer_api/app/view_models/order_view_model.dart';

class OrderService {
  final _orderRepository = OrderRepository();
  final _userRepository = UserRepository();
  final _productRepository = ProdutcRepositorty();
  final _gerencianetPix = GerencianetPix();

  Future<QrCodeGerencianetModel> createOrder(OrderViewModel order) async {
    final orderId = await _orderRepository.save(order);
    return await _createBilling(orderId, order);
  }

  Future<QrCodeGerencianetModel> _createBilling(
      int orderId, OrderViewModel order) async {
    final user = await _userRepository.findByID(order.userId);
    double totalValue = 0.0;
    for (final item in order.items) {
      final product = await _productRepository.findById(item.productId);
      totalValue += item.quantity * product.price;
    }
    final cpf = order.cpf;
    final value = totalValue;
    final name = user.name;
    final billing =
        await _gerencianetPix.genereteBilling(value, cpf, name, orderId);

    await _orderRepository.updateTransactionId(orderId, billing.transactionId);

    return _gerencianetPix.getQrCode(billing.locationId);
  }
}
