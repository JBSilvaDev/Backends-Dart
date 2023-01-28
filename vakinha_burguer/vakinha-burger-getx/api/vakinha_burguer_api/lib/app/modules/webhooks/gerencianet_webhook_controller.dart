import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vakinha_burguer_api/app/modules/webhooks/view_models/gerencianet_callback_view_model.dart';
import 'package:vakinha_burguer_api/app/service/order_service.dart';

import '../../core/gerencianet/pix/gerencianet_pix.dart';

part 'gerencianet_webhook_controller.g.dart';

class GerencianetWebhookController {
  final _orderService = OrderService();

    @Route.post('/register')
  Future<Response> register (Request request) async {
    await GerencianetPix().registerWebHook();
    return Response.ok(jsonEncode({}));
  }

  @Route.post('/')
  Future<Response> webhookConfig(Request request) async {
    return Response(200, headers: {'content-type': 'application/json'});
  }

  @Route.post('/pix')
  Future<Response> webhookPaymentCallback(Request request) async {
    try {
      final callback =
          GerencianetCallbackViewModel.fromJson(await request.readAsString());
      await _orderService
          .confirmePayment(callback.pix.map((p) => p.transactionId));

      return Response.ok(jsonEncode({}),
          headers: {'content-type': 'application/json'});
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$GerencianetWebhookControllerRouter(this);
}
