import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';
import 'package:vakinha_burguer_api/app/core/gerencianet/gerencianet_rest_client.dart';
import 'package:vakinha_burguer_api/app/core/gerencianet/pix/models/billing_gerencianet_model.dart';
import 'package:vakinha_burguer_api/app/core/gerencianet/pix/models/qr_code_gerencianet_model.dart';

class GerencianetPix {
  Future<BillingGerencianetModel> genereteBilling(
      double value, String? cpf, String? name, int orderId) async {
    try {
      final gerencianetRestClient = GerencianetRestClient();
      final billingData = {
        "calendario": {"expiracao": 3600},
        'devedor': {
          "cpf": cpf,
          "nome": name,
        },
        'valor': {
          "original": '$value',
        },
        "chave": env['gerencianetChavePix'],
        'solicitacaoPagador': 'pedido de numero $orderId no vakinha burger',
        'infoAdicionais': [
          {'nome': 'orderId', 'valor': '$orderId'}
        ]
      };

      final billingResponse = await gerencianetRestClient.auth().post(
            '/v2/cob',
            data: billingData,
          );
      final billingResponseData = billingResponse.data;
      return BillingGerencianetModel(
          transactionId: billingResponseData['txid'],
          locationId: billingResponseData['loc']['id']);
    } on DioError catch (e, s) {
      log('Erro no pagamento', error: e.response, stackTrace: s);
      rethrow;
    }
  }

  Future<QrCodeGerencianetModel> getQrCode(int locationId) async {
    try {
  final gerencianetPix = GerencianetRestClient();
  final qrResponse =
      await gerencianetPix.auth().get('/v2/loc/$locationId/qrcode');
  final qrCodeResponseData = qrResponse.data;
  return QrCodeGerencianetModel(
      image: qrCodeResponseData['imagemQrCode'],
      code: qrCodeResponseData['qrcode']);
} on DioError catch (e, s) {
      log('Erro no QrCode', error: e.response, stackTrace: s);
      rethrow;
}
  }
}
