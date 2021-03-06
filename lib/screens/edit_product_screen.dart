import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/product.dart';
import 'package:untitled1/providers/products_provider.dart';

// this is not the best practice of using Forms in flutter
// but it is just for learning!

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    price: 0.0,
    title: '',
    description: '',
    imageUrl: '',
  );

  var _initialValues = {
    'price': '',
    'title': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initialValues = {
          'price': _editedProduct.price.toString(),
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        // _editedProduct = Product(
        //     id: productId,
        //     isFavorite: loadedProduct.isFavorite,
        //     title: loadedProduct.title,
        //     description: loadedProduct.description,
        //     // imageUrl: loadedProduct.imageUrl,
        //     imageUrl: '',
        //     price: loadedProduct.price);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id == null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      }

    } else {
      try{
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      }catch(error){
        throw error;
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http://') &&
              !_imageUrlController.text.startsWith('https://')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        setState(() {});
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              _saveForm();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      initialValue: _initialValues['title'],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      initialValue: _initialValues['price'],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value).toDouble());
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please enter a valid value.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter a number grater than zero.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      initialValue: _initialValues['description'],
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value.';
                        }
                        if (value.length < 10) {
                          return 'please enter a description grater than 10 characters.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8.0, right: 10.0),
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('ENTER URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, ex, st) {
                                      return Container(
                                        height: 100,
                                        width: 100,
                                        child: Text('ENTER URL'),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'image url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value,
                                  price: _editedProduct.price);
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onChanged: (_) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a value.';
                              }
                              if (!value.startsWith('http://') &&
                                  !value.startsWith('https://')) {
                                return 'please enter a valid url';
                              }
                              if (!_imageUrlController.text.endsWith('.png') &&
                                  !_imageUrlController.text.endsWith('.jpg') &&
                                  !_imageUrlController.text.endsWith('.jpeg')) {
                                return 'please enter a valid url';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
