// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:vakinha_burguer_api/app/entities/product.dart';

class OrderIttem {
  final int id;
  final int quantity;
  final Product product;
  OrderIttem({
    required this.id,
    required this.quantity,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'product': product.toMap(),
    };
  }

  factory OrderIttem.fromMap(Map<String, dynamic> map) {
    return OrderIttem(
      id: map['id'] as int,
      quantity: map['quantity'] as int,
      product: Product.fromMap(map['product'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderIttem.fromJson(String source) => OrderIttem.fromMap(json.decode(source) as Map<String, dynamic>);
}
