import 'package:vakinha_burguer_api/app/repositories/order_repository.dart';
import 'package:vakinha_burguer_api/app/view_models/order_view_model.dart';

class OrderService {
  final _orderRepository = OrderRepository();

  Future<dynamic> createOrder(OrderViewModel order) async {
    final ordderId = _orderRepository.save(order);
    
  }
}
