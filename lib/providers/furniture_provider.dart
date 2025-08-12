import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/furniture.dart';

class FurnitureProvider with ChangeNotifier{
  final List<Furniture> items = [

    Furniture(
      id: '1',
      name: 'Wing Chair',
      category: 'Chair',
      price: 199.0,
      imageUrl: 'assets/images/6.png',
      images: [
        'assets/images/6.png',
        'assets/images/6.png',
        'assets/images/6.png',
      ],
      description: 'A comfortable wing chair with wooden frame and soft cushioning.',
      colors: ['#FFCDD2', '#F8BBD0', '#E1BEE7'],
      isFavorite: true,
      specialOfferIds: ['summer_sale'],
    ),
    Furniture(
      id: '2',
      name: 'Modern Sofa',
      category: 'Sofa',
      price: 349.0,
      imageUrl: 'assets/images/7.png',
      images: [
        'assets/images/7.png',
        'assets/images/7.png',
        'assets/images/7.png',
      ],
      description: 'A stylish modern sofa designed for comfort and elegance.',
      colors: ['#B2EBF2', '#80DEEA', '#4DD0E1'],
      isFavorite: false,
      specialOfferIds: ['new_arrival'],
    ),
    Furniture(
      id: '3',
      name: 'Dining Table',
      category: 'Table',
      price: 450.0,
      imageUrl: 'assets/images/8.png',
      images: [
        'assets/images/8.png',
        'assets/images/8.png',
        'assets/images/8.png',
      ],
      description: 'A large dining table perfect for family meals and gatherings.',
      colors: ['#C8E6C9', '#A5D6A7', '#81C784'],
      isFavorite: true,
      specialOfferIds: ['discount_week'],
    ),
    Furniture(
      id: '4',
      name: 'King Bed',
      category: 'Bed',
      price: 599.0,
      imageUrl: 'assets/images/9.png',
      images: [
        'assets/images/9.png',
        'assets/images/9.png',
        'assets/images/9.png',
      ],
      description: 'A spacious king-size bed with luxurious cushioning.',
      colors: ['#D1C4E9', '#B39DDB', '#9575CD'],
      isFavorite: false,
      specialOfferIds: ['clearance'],
    ),
    Furniture(
      id: '5',
      name: 'Office Chair',
      category: 'Chair',
      price: 149.0,
      imageUrl: 'assets/images/6.png',
      images: [
        'assets/images/6.png',
        'assets/images/6.png',
        'assets/images/6.png',
      ],
      description: 'An ergonomic office chair for maximum productivity.',
      colors: ['#FFE082', '#FFD54F', '#FFCA28'],
      isFavorite: false,
      specialOfferIds: ['back_to_work'],
    ),
    Furniture(
      id: '6',
      name: 'Bookshelf',
      category: 'Storage',
      price: 189.0,
      imageUrl: 'assets/images/6.png',
      images: [
        'assets/images/7.png',
        'assets/images/7.png',
        'assets/images/7.png',
      ],
      description: 'A modern bookshelf to organize your books and decor.',
      colors: ['#B0BEC5', '#90A4AE', '#78909C'],
      isFavorite: true,
      specialOfferIds: ['storage_sale'],
    ),
    Furniture(
      id: '7',
      name: 'Coffee Table',
      category: 'Table',
      price: 129.0,
      imageUrl: 'assets/images/8.png',
      images: [
        'assets/images/8.png',
        'assets/images/8.png',
        'assets/images/8.png',
      ],
      description: 'A sleek coffee table for your living room.',
      colors: ['#FFE0B2', '#FFCC80', '#FFB74D'],
      isFavorite: false,
      specialOfferIds: ['living_essentials'],
    ),
    Furniture(
      id: '8',
      name: 'TV Stand',
      category: 'Storage',
      price: 219.0,
      imageUrl: 'assets/images/9.png',
      images: [
        'assets/images/9.png',
        'assets/images/9.png',
        'assets/images/9.png',
      ],
      description: 'A sturdy TV stand with multiple storage compartments.',
      colors: ['#DCEDC8', '#C5E1A5', '#AED581'],
      isFavorite: true,
      specialOfferIds: ['media_sale'],
    ),
    Furniture(
      id: '9',
      name: 'Recliner Chair',
      category: 'Chair',
      price: 279.0,
      imageUrl: 'assets/images/6.png',
      images: [
        'assets/images/6.png',
        'assets/images/6.png',
        'assets/images/6.png',
      ],
      description: 'A soft recliner chair for relaxation and comfort.',
      colors: ['#FFAB91', '#FF8A65', '#FF7043'],
      isFavorite: false,
      specialOfferIds: ['comfort_zone'],
    ),
    Furniture(
      id: '10',
      name: 'Nightstand',
      category: 'Table',
      price: 99.0,
      imageUrl: 'assets/images/7.png',
      images: [
        'assets/images/7.png',
        'assets/images/7.png',
        'assets/images/7.png',
      ],
      description: 'A compact nightstand with drawer and shelf.',
      colors: ['#CFD8DC', '#B0BEC5', '#90A4AE'],
      isFavorite: false,
      specialOfferIds: ['bedroom_essentials'],
    ),
    Furniture(
      id: '11',
      name: 'Wardrobe',
      category: 'Storage',
      price: 499.0,
      imageUrl: 'assets/images/8.png',
      images: [
        'assets/images/8.png',
        'assets/images/8.png',
        'assets/images/8.png',
      ],
      description: 'A spacious wardrobe with modern sliding doors.',
      colors: ['#FFF59D', '#FFF176', '#FFEE58'],
      isFavorite: true,
      specialOfferIds: ['new_arrival'],
    ),
    Furniture(
      id: '12',
      name: 'Accent Chair',
      category: 'Chair',
      price: 229.0,
      imageUrl: 'assets/images/9.png',
      images: [
        'assets/images/9.png',
        'assets/images/9.png',
        'assets/images/9.png',
      ],
      description: 'A fashionable accent chair for stylish homes.',
      colors: ['#E0F2F1', '#B2DFDB', '#80CBC4'],
      isFavorite: true,
      specialOfferIds: ['decor_special'],
    ),
    Furniture(
      id: '13',
      name: 'Bunk Bed',
      category: 'Bed',
      price: 549.0,
      imageUrl: 'assets/images/6.png',
      images: [
        'assets/images/6.png',
        'assets/images/6.png',
        'assets/images/6.png',
      ],
      description: 'A functional bunk bed ideal for kids and space saving.',
      colors: ['#F0F4C3', '#E6EE9C', '#DCE775'],
      isFavorite: false,
      specialOfferIds: ['kids_zone'],
    ),
    Furniture(
      id: '14',
      name: 'Loveseat',
      category: 'Sofa',
      price: 399.0,
      imageUrl: 'assets/images/7.png',
      images: [
        'assets/images/7.png',
        'assets/images/7.png',
        'assets/images/7.png',
      ],
      description: 'A cozy loveseat perfect for small spaces.',
      colors: ['#F8BBD0', '#F48FB1', '#F06292'],
      isFavorite: true,
      specialOfferIds: ['romantic_collection'],
    ),
    Furniture(
      id: '15',
      name: 'Reading Table',
      category: 'Table',
      price: 169.0,
      imageUrl: 'assets/images/8.png',
      images: [
        'assets/images/8.png',
        'assets/images/8.png',
        'assets/images/8.png',
      ],
      description: 'A wooden reading table with minimalist design.',
      colors: ['#D7CCC8', '#BCAAA4', '#A1887F'],
      isFavorite: false,
      specialOfferIds: ['study_time'],
    ),
  ];


  String? _selectedCategory;
  String _searchQuery = '';

  List<Furniture> get featuredItems => items
      .where((item) =>
  item.price >= 599.0 ||
      item.isFavorite ||
      item.category == 'Sofa' ||
      item.category == 'Bed')
      .take(5)
      .toList();

  List<Furniture> getItems({int? limit}) {
    final filteredItems = items.where((item) {
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory == 'All' ||
          item.category == _selectedCategory;

      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    if (limit != null) {
      return filteredItems.take(limit).toList();
    }

    return filteredItems;
  }

  List<String> get categories {
    final allCategories = <String>{'All'};
    for (var item in items) {
      allCategories.add(item.category);
    }
    return allCategories.toList()..sort();
  }

  List<Furniture> getItemsByCategory(String category) {
    return items.where((item) => item.category == category).toList();
  }

  String? get selectedCategory => _selectedCategory;

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      items[index].isFavorite = !items[index].isFavorite;
      notifyListeners();
    }
  }
}