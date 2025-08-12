import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/blog.dart';

class BlogProvider with ChangeNotifier {
  final List<Blog> _blogs = [
    Blog(
      id: '1',
      title: 'Top 5 Coffee Tables for Small Living Rooms',
      excerpt:
          'Find the best space-saving coffee tables that combine style and function.',
      content: '''
Choosing the right coffee table can make a big difference in a small space. Here are our top picks:

1. Nesting Tables: Great for flexibility — stack when not in use.
2. Lift-top Tables: Hidden storage and multi-use surfaces.
3. Glass Tables: Create the illusion of more space.
4. Foldable or Extendable Tables: Ideal for guests.
5. Minimalist Wooden Tables: Clean design, lightweight feel.

Always consider proportions, color, and functionality when selecting a coffee table.
''',
      imageUrl: 'assets/images/blog1.jpg',
      date: '3 days ago',
      readTime: '4 min read',
      author: 'Emily Carter',
      tags: ['Furniture', 'Small Spaces', 'Coffee Table'],
    ),
    Blog(
      id: '2',
      title: 'Eco-Friendly Furniture Choices in 2025',
      excerpt: 'Discover sustainable options for a greener home.',
      content: '''
As environmental awareness grows, many homeowners seek furniture that's both stylish and sustainable.

- Bamboo and rattan are top renewable materials.
- Recycled wood and metal reduce waste.
- Low-VOC finishes protect indoor air quality.
- Support local artisans and small eco-friendly businesses.

Making conscious choices helps both your home and the planet.
''',
      imageUrl: 'assets/images/blog2.jpg',
      date: '5 days ago',
      readTime: '6 min read',
      author: 'Liam Patel',
      tags: ['Eco-Friendly', 'Sustainability', 'Green Living'],
    ),
    Blog(
      id: '3',
      title: 'Decorating with Color Psychology',
      excerpt: 'Learn how different colors affect mood and atmosphere in your home.',
      content: '''
Colors can deeply influence how we feel in a space. Here's a guide:

- Blue: Calming, great for bedrooms and bathrooms.
- Yellow: Uplifting, ideal for kitchens and entryways.
- Green: Balancing, perfect for living rooms and home offices.
- Red: Energetic, use in moderation in dining spaces.
- Neutral tones: Offer flexibility and timelessness.

Use color strategically to enhance comfort and emotional well-being.
''',
      imageUrl: 'assets/images/blog3.jpg',
      date: '1 week ago',
      readTime: '7 min read',
      author: 'Nora Kim',
      tags: ['Interior Design', 'Colors', 'Mood'],
    ),


  ];

  String? _selectedTag;

  List<Blog> get blogs {
    if (_selectedTag == null) {
      return [..._blogs];
    }
    return _blogs.where((blog) => blog.tags.contains(_selectedTag)).toList();
  }

  String? get selectedTag=> _selectedTag;
  void selectTag(String? tag){
    if(_selectedTag == tag){
      _selectedTag = null;
    } else {
      _selectedTag = tag;
    }
    notifyListeners();
  }

  // void toggleTag(String? tag) {
  //   if (_selectedTag == tag) {
  //     _selectedTag = null;
  //   } else {
  //     _selectedTag = tag;
  //   }
  //   notifyListeners();
  // }

  Blog findById(String id) {
    return _blogs.firstWhere(
          (blog) => blog.id == id,
      orElse: () => throw Exception('Blog not found'),
    );
  }

  List<Blog> findByTag(String tag) {
    return _blogs.where((blog) => blog.tags.contains(tag)).toList();
  }

  List<String> get allTags {
    final Set<String> tags = {};
    for (var blog in _blogs) {
      tags.addAll(blog.tags);
    }
    return tags.toList()..sort();
  }
}
