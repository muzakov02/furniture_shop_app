import 'package:flutter/material.dart';
import 'package:furniture_shop_app/providers/blog_provider.dart';
import 'package:furniture_shop_app/screens/blog/widgets/blog_card.dart';
import 'package:provider/provider.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 8,
              right: 8,
              bottom: 8,
            ),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blog',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get inspired with furniture tips & trends',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTagsList(),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BlogProvider>(
              builder: (context, blogProvider, child) {
                final blogs = blogProvider.blogs;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    return BlogCard(
                      blog: blogs[index],
                      index: index,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsList() {
    return Consumer<BlogProvider>(builder: (context, blogProvider, child) {
      final tags = blogProvider.allTags;
      final selectedTag = blogProvider.selectedTag;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular topics',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (selectedTag != null)
                  GestureDetector(
                    onTap: () => blogProvider.selectTag(null),
                    child: const Text(
                      'CLear Filter',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                final isSelected = tag == selectedTag;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == tags.length - 1 ? 16.0 : 8.0,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => blogProvider.selectTag(tag),
                      borderRadius: BorderRadius.circular(17),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.yellow.withValues(alpha: 0.1)
                              : Colors.grey.shade50,
                          border: Border.all(
                              color: isSelected
                                  ? Colors.yellow
                                  : Colors.grey.shade300!,
                              width: 1),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                tag,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.yellow
                                      : Colors.grey.shade700,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Colors.yellow,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
