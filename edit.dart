import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../screen/productpage.dart';

class EditProductPage extends StatefulWidget {
  final Function(ProductElement) editProduct; 
  final Function(String) deleteProduct;
  final ProductElement product;

  EditProductPage({
    required this.editProduct, 
    required this.deleteProduct, 
    required this.product,
  });

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _descriptionController.text = widget.product.description;
    _colorController.text = widget.product.color;
    _imageUrlController.text = widget.product.imageUrl;
  }

  Future<void> _submitProduct() async {
    var url = Uri.parse('http://localhost:3000/product/${widget.product.id}');

    try {
      print("Editing product at: $url");

      if (_formKey.currentState!.validate()) {
        
        var price = double.tryParse(_priceController.text);
        if (price == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid price format")),
          );
          return; 
        }

       
        var editedProduct = ProductElement(
          id: widget.product.id, 
          name: _nameController.text.trim(),
          price: price,
          description: _descriptionController.text.trim(),
          color: _colorController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
        );

        var resp = await http.patch(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(editedProduct.toJson()),
        );

        if (resp.statusCode == 200) {
          print("Product edited successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product edited successfully")),
          );
          widget.editProduct(editedProduct); 
          Navigator.pop(context, editedProduct); 
        } else {
          print("Failed to edit product: ${resp.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to edit product: ${resp.body}")),
          );
        }
      }
    } catch (e) {
      print("Error editing product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

Future<void> _deleteProduct() async {
  var url = Uri.parse('http://localhost:3000/product/${widget.product.id}');

  try {
    var resp = await http.delete(url);
    if (resp.statusCode == 200) {
      print("Product deleted successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product deleted successfully")),
      );
      widget.deleteProduct(widget.product.id); 
      Navigator.of(context).pop(); 
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProductPage()), 
      );
    } else {
      print("Failed to delete product: ${resp.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete product: ${resp.body}")),
      );
    }
  } catch (e) {
    print("Error deleting product: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteProduct, 
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProduct,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
