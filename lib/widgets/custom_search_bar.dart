import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/furniture_provider.dart';
import 'package:furniture_shop_app/screens/search/search_screen.dart';
import 'package:provider/provider.dart';
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Provider.of<FurnitureProvider>(context, listen: false)
            .setSearchQuery('');
        
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> const SearchScreen(),),);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:  Icon(
                Icons.search_rounded,
                color: Colors.yellow.shade800,
                size: 20,
              ),
            ),
          const   SizedBox(width: 16),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Search',
                      style:  TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Find your favorite furniture',
                      style:  TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
            ),
            Container(
              padding:const  EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child:  Icon(
                Icons.tune_rounded,
                color: Colors.yellow.shade50,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
