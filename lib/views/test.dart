// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
class Category {
  final String title;
  final String icon;
  final Color bgColor;

  Category({required this.title, required this.icon, required this.bgColor});
}

class FlowerProduct {
  final String name;
  final double price;
  final String image;

  FlowerProduct({
    required this.name,
    required this.price,
    required this.image,
  });
}

// Providers
final categoriesProvider = StateProvider<List<Category>>((ref) => [
      Category(
        title: 'Birthday',
        icon: '🎂',
        bgColor: Colors.pink.shade100,
      ),
      Category(
        title: 'Anniversary',
        icon: '💑',
        bgColor: Colors.orange.shade100,
      ),
      Category(
        title: 'Congrats',
        icon: '🎉',
        bgColor: Colors.blue.shade100,
      ),
      Category(
        title: 'New Baby',
        icon: '👶',
        bgColor: Colors.pink.shade100,
      ),
      Category(
        title: 'Well Wishes',
        icon: '💐',
        bgColor: Colors.yellow.shade100,
      ),
      Category(
        title: 'Graduation',
        icon: '🎓',
        bgColor: Colors.purple.shade100,
      ),
    ]);

final popularBouquetsProvider = StateProvider<List<FlowerProduct>>((ref) => [
      FlowerProduct(
        name: 'Rose',
        price: 15.99,
        image: 'assets/images/bouquet/1.png',
      ),
      FlowerProduct(
        name: 'Tulip',
        price: 18.99,
        image: 'assets/images/bouquet/2.png',
      ),
      FlowerProduct(
        name: 'Carnation',
        price: 16.99,
        image: 'assets/images/bouquet/3.png',
      ),
    ]);
