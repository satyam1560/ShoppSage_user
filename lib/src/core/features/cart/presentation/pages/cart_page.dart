import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../payment/presentation/widgets/add_delivery_details.dart';
import '../../data/repositories/display_cart_repo.dart';
import '../bloc/cart_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DisplayCartRepo displayCartRepo = DisplayCartRepo();
  User currentUserId = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context)
        .add(DisplayCartProductEvent(userId: currentUserId.uid));
  }

  void removeCartItems({required String productId, required String userId}) {
    BlocProvider.of<CartBloc>(context)
        .add(RemoveProductFromCartEvent(productId: productId, userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    BlocConsumer<CartBloc, CartState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state.cartStatus ==
                            DisplayCartProductStatus.initial) {
                          return const Center(
                            child: Text('No items Added To Cart'),
                          );
                        } else if (state.cartStatus ==
                            DisplayCartProductStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state.cartStatus ==
                            DisplayCartProductStatus.success) {
                          final cartProduct = state.cartProducts;
                          // print('cartProduct $cartProduct');

                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: cartProduct!.length,
                                itemBuilder: (context, index) {
                                  var productcart = cartProduct[index];

                                  return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    key: UniqueKey(),
                                    onDismissed: (direction) {
                                      // Remove item from cart here
                                      BlocProvider.of<CartBloc>(context).add(
                                          RemoveProductFromCartEvent(
                                              productId: productcart.productId!,
                                              userId: currentUserId.uid));

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${productcart.title} removed from cart'),
                                        ),
                                      );
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Card(
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            productcart.imageUrl ?? '',
                                            filterQuality: FilterQuality.low,
                                          ),
                                        ),
                                        title: Text(
                                          productcart.title ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          '₹ ${productcart.price}',
                                        ),
                                        trailing: Text(
                                            'Qty. ${productcart.quantity}'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Price:\n₹ ${state.totalPrice}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: TSizes.sm,
                                            vertical: TSizes.buttonHeight),
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                            ),
                                            child: AddDeliveryDetails(
                                                totalCheckoutPrice:
                                                    state.totalPrice,
                                                productCart: cartProduct,
                                                userId: currentUserId.uid),
                                          ),
                                        );
                                      },
                                      child: const Text('Proceed To Checkout'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Handle error state
                          return const Center(
                              child: Text('No Products found in cart'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
