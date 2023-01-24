import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vakinha_burguer_api/app/service/order_service.dart';
import 'package:vakinha_burguer_api/app/view_models/order_view_model.dart';

part 'order_controller.g.dart';

class OrderController {
  final _orderService = OrderService();

  @Route.post('/')
  Future<Response> register(Request request) async {
    final orderVM = OrderViewModel.fromJson(await request.readAsString());
    final order = await _orderService.createOrder(orderVM);
    return Response.ok(jsonEncode({'Menssagem': 'Criado com sucesso!'}));
  }

  Router get router => _$OrderControllerRouter(this);
}
