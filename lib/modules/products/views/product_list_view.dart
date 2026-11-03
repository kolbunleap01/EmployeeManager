import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/product_controller.dart';

class ProductListView extends GetView<ProductController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const LoadingWidget(message: 'Loading products...');
        }
        final error = controller.errorMessage.value;
        if (error != null && controller.products.isEmpty) {
          return AppErrorWidget(
            message: error,
            onRetry: controller.loadProducts,
          );
        }
        if (controller.products.isEmpty) {
          return const EmptyWidget(
            title: 'No products found',
            message: 'There are no products available right now.',
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refreshProducts,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: controller.products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final product = controller.products[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 118,
                      height: 138,
                      child: CachedNetworkImage(
                        imageUrl: product.thumbnail,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        errorWidget: (_, _, _) => const ColoredBox(
                          color: Color(0xFFE2E8F0),
                          child: Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.category.toUpperCase(),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFF59E0B),
                                  size: 18,
                                ),
                                const SizedBox(width: 3),
                                Text(product.rating.toStringAsFixed(1)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
