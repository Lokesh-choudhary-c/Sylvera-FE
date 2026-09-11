import 'package:equatable/equatable.dart';
import '../models/variant_price.dart';

abstract class VariantPriceState extends Equatable {
  const VariantPriceState();

  @override
  List<Object?> get props => [];
}

class VariantPriceInitial extends VariantPriceState {}

class VariantPriceLoading extends VariantPriceState {}

class VariantPriceLoaded extends VariantPriceState {
  final VariantPrice price;
  const VariantPriceLoaded(this.price);

  @override
  List<Object?> get props => [price.variantId, price.calculatedPrice];
}

class VariantPriceError extends VariantPriceState {
  final String message;
  const VariantPriceError(this.message);

  @override
  List<Object?> get props => [message];
}