import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  TextEditingController _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);
  var _isInit = true;
  var _isLoading = false;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snackBar() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            _editedProduct.id.isEmpty
                ? Text('product ${_editedProduct.title} has been added')
                : Text('product ${_editedProduct.title} has been updated'),
            const FittedBox(
              child: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageFocusNode.dispose();
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        _editedProduct = ModalRoute.of(context)?.settings.arguments as Product;
        print(_editedProduct.id);
      }
      _imageController = TextEditingController(text: _editedProduct.imageUrl);
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isEmpty) {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        _snackBar();
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
      Navigator.of(context).pop();
      _snackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
        title: const Text('Edit product'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      focusNode: _titleFocusNode,
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter valid title';
                        }
                        return null;
                      },
                      onSaved: (title) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: title ?? '',
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.price.toString(),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please enter valid price';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onSaved: (price) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(price ?? '0'),
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter description';
                        }
                        if (value.length < 10) {
                          return 'please enter description bigger than 10 characters';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      focusNode: _descriptionFocusNode,
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      onSaved: (description) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: description ?? '',
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Card(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: _imageController.text.isEmpty
                                ? const Center(
                                    child: Text('Enter Url'),
                                  )
                                : Image.network(_imageController.text),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image Url',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageController,
                            focusNode: _imageFocusNode,
                            onSaved: (imageUrl) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: imageUrl ?? '',
                                  price: _editedProduct.price,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter image url';
                              }
                              if ((!value.startsWith('https') ||
                                      !value.startsWith('http')) &&
                                  (!value.endsWith('.jpg') ||
                                      !value.endsWith('.png') ||
                                      !value.endsWith('.jpeg'))) {
                                return 'please enter valid url.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
