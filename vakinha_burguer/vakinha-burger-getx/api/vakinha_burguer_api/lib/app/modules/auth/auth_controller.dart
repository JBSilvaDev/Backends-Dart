import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vakinha_burguer_api/app/core/exception/email_already_registered.dart';
import 'package:vakinha_burguer_api/app/core/exception/user_notfound_exception.dart';
import 'package:vakinha_burguer_api/app/entities/user.dart';
import 'package:vakinha_burguer_api/app/repositories/user_repository.dart';

part 'auth_controller.g.dart';

class AuthController {
  
  final _userRepository = UserRepository();

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final jsonRQ = jsonDecode(await request.readAsString());
      final user =
          await _userRepository.login(jsonRQ['email'], jsonRQ['password']);
      return Response.ok(user.toJson(), headers: {
        'content-type': 'application/json',
      });
    } on UserNotfoundException catch (e, s) {
      print(e);
      print(s);
      return Response(403, headers: {
        'content-type': 'application/json',
      });
    }catch(e, s){
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.post('/register')
  Future<Response> register(Request request) async {
    try {
      final userRq = User.fromJson(await request.readAsString());
      await _userRepository.save(userRq);

      return Response(200, headers: {
        'content-type': 'application/json',
      });
    } on EmailAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response(400,
          body: jsonEncode(
            {'error': 'E-mail ja utilizado'},
          ),
          headers: {
            'content-type': 'application/json',
          });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
