import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/create.dart';
import '../models/edit.dart';
import '../models/cart.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductElement> _products = [];
  bool _isLoading = false;

  void _addToCart(ProductElement product) {
   final cartModel = Provider.of<ShoppingCartModel>(context, listen: false);
cartModel.addProductToCart(product);
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
     final response = await http.get(Uri.parse('http://localhost:3000/product'));


      if (response.statusCode == 200) {
        final List<dynamic> productList = jsonDecode(response.body);
        setState(() {
          _products = productList.map((data) => ProductElement.fromJson(data)).toList();
        });
      } else {
        print('Failed to load products: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _navigateToCreateProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateProductPage(createProduct: (product) {
        setState(() {
          _products.add(product);
        });
      })),
    );
  }

  Future<void> _deleteProduct(String id) async { 
    final response = await http.delete(Uri.parse('http://localhost:3000/product/$id'));


    if (response.statusCode == 200) {
      setState(() {
        _products.removeWhere((product) => product.id == id); 
      });
    } else {
      print('Failed to delete product: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.cyan,
          elevation: 0,
          titleSpacing: 0,
          leading: BackButton(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.add, size: 30),
                onPressed: _navigateToCreateProduct,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShoppingCartPage()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Explore Your New Style',
              style: TextStyle(
                fontSize: 35,
                fontFamily: ' Pacifico',
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final editedProduct = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: _products[index],
                                navigateToEditPage: (editedProduct) {
                                  setState(() {
                                    _products[index] = editedProduct;
                                  });
                                },
                                addToCart: _addToCart,
                                deleteProduct: _deleteProduct, 
                              ),
                            ),
                          );

                          if (editedProduct != null) {
                            setState(() {
                              _products[_products.indexWhere ((p) => p.id == editedProduct.id)] = editedProduct;
                            });
                          }
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  _products[index].imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
 Text(
                                      _products[index].name,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text('Price: \$${_products[index].price.toString()}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final ProductElement product;
  final Function(ProductElement) navigateToEditPage;
  final Function(ProductElement) addToCart;
  final Function(String) deleteProduct; 

  ProductDetailPage({
    required this.product,
    required this.navigateToEditPage,
    required this.addToCart,
    required this.deleteProduct, 
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductElement _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final editedProduct = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(
                    product: _product,
                    editProduct: (editedProduct) {
                      setState(() {
                        _product = editedProduct;
                      });
                      widget.navigateToEditPage(editedProduct);
                    },
                    deleteProduct: widget.deleteProduct, 
                  ),
                ),
              );

              if (editedProduct != null) {
                setState(() {
                  _product = editedProduct;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(_product.imageUrl, fit: BoxFit.cover),
            SizedBox(height: 16.0),
            Text(
              _product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Price: \$${_product.price.toString()}'),
            SizedBox(height: 8.0),
            Text('Color: ${_product.color}'),
            SizedBox(height: 8.0),
            Text('Description: ${_product.description}'),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.addToCart(_product);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingCartPage()),
                  );
                },
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
   final cartModel = Provider.of<ShoppingCartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: cartModel.cartItems.isEmpty
          ? Center(
              child: Text('Your cart is empty'),
            )
          : ListView.builder(
              itemCount: cartModel.cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartModel.cartItems[index].name),
                  subtitle: Text('Price: \$${cartModel.cartItems[index].price.toString()}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      cartModel.removeProductFromCart(cartModel.cartItems[index]);
                    },
                  ),
                );
              },
            ),
    );
  }
}