import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_store/product/block/product_state.dart';

import '../../../helper/exception_handler.dart';
import '../data/repository/product_repository.dart';

part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<GetProductEvent>(
        (GetProductEvent event, Emitter<ProductState> emit) async {
      emit(ProductLoadingState());

      try {
        final products = await productRepository.getProducts();
        if (products.isEmpty) {
          emit(ProductEmptyState());
          print("Product Empty");
        } else {
          emit(ProductLoadedState(products: products));
          print("Product Loaded");
        }
      } catch (e) {
        final message = handleExceptionWithMessage(e);
        emit(ProductLoadingFailedState(errorMessage: message));
        print("Product Loading Failed");
      }
    });
  }
}
