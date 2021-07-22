import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/edit_product_page.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductPage.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (_, index) => Column(
              children: [
                UserProductItem(
                  products.items[index].id,
                  products.items[index].title,
                  products.items[index].imageUrl,
                ),
                Divider(thickness: 1),
              ],
            ),
            itemCount: products.items.length,
          ),
        ),
      ),
    );
  }
}
