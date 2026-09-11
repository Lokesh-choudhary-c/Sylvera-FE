import 'package:equatable/equatable.dart';
import '../models/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double cartTotal;
  const CartLoaded(this.items, this.cartTotal);

  @override
  List<Object?> get props => [items, cartTotal];
}

class CartActionInProgress extends CartLoaded {
  const CartActionInProgress(super.items, super.cartTotal);
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}