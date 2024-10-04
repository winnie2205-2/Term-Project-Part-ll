import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class CreateProductPage extends StatefulWidget {
  final Function createProduct;

  CreateProductPage({required this.createProduct});

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Future<String> _getLastProductId() async {
   var url = Uri.parse('http://localhost:3000/product');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var productData = json.decode(response.body) as List<dynamic>;
        
        if (productData.isNotEmpty) {
          
          return productData.map((e) => e['id'] as String).reduce((a, b) => a.compareTo(b) > 0 ? a : b);
        }
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
    return "0"; 
  }

  Future<void> _submitProduct() async {
    var url = Uri.parse('http://localhost:3000/product');

    try {
      print("Adding product to: $url");

      if (_formKey.currentState!.validate()) {
        var price = double.tryParse(_priceController.text); 

        if (price == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid price format")),
          );
          return; 
        }


        String lastId = await _getLastProductId();

        var newProduct = ProductElement(
          id: (int.parse(lastId) + 1).toString(), 
          name: _nameController.text,
          price: price, 
          description: _descriptionController.text,
          color: _colorController.text,
          imageUrl: _imageUrlController.text,
        );

      
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(newProduct.toJson()),
        );

        if (response.statusCode == 201) {
          print("Product added successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product added successfully")),
          );
          widget.createProduct(newProduct);
          Navigator.pop(context, newProduct); 
        } else {
          print("Failed to add product: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add product")),
          );
        }
      }
    } catch (e) {
      print("Error adding product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                controller: _priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Color'),
                controller: _colorController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a color';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                controller: _imageUrlController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _submitProduct(); 
                },
                child: Text('Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
