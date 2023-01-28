import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart' show load;
import 'package:shelf_static/shelf_static.dart';
import 'package:vakinha_burguer_api/app/modules/auth/auth_controller.dart';
import 'package:vakinha_burguer_api/app/modules/order/order_controller.dart';
import 'package:vakinha_burguer_api/app/modules/product/product_controller.dart';
import 'package:vakinha_burguer_api/app/modules/webhooks/gerencianet_webhook_controller.dart';

final staticFiles = createStaticHandler('images/', listDirectories: true);
// Configure routes.
final _router = Router()
  ..mount('/images/', staticFiles)
  ..mount('/auth/', AuthController().router)
  ..mount('/products/', ProductController().router)
  ..mount('/gerencianet/webhook/', GerencianetWebhookController().router)
  ..mount('/order/', OrderController().router);

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = '0.0.0.0';

  load();

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
