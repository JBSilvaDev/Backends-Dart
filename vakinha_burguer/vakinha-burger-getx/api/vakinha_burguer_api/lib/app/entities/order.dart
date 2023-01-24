// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:vakinha_burguer_api/app/entities/order_ittem.dart';
import 'package:vakinha_burguer_api/app/entities/user.dart';

class Order {
  final int id;
  final User user;
  final String? transactional;
  final String? cpf;
  final String deliveryAddress;
  final String status;
  final List<OrderIttem> items;
  Order({
    required this.id,
    required this.user,
    this.transactional,
    this.cpf,
    required this.deliveryAddress,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'transactional': transactional,
      'cpf': cpf,
      'deliveryAddress': deliveryAddress,
      'status': status,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      transactional: map['transactional'] != null ? map['transactional'] as String : null,
      cpf: map['cpf'] != null ? map['cpf'] as String : null,
      deliveryAddress: map['deliveryAddress'] as String,
      status: map['status'] as String,
      items: List<OrderIttem>.from((map['items'] as List<int>).map<OrderIttem>((x) => OrderIttem.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
