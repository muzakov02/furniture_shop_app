import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/blog.dart';
import 'package:furniture_shop_app/screens/blog/blog_detail_screen.dart';
import 'package:furniture_shop_app/screens/blog/widgets/blog_image_with_shimmer.dart';
import 'package:furniture_shop_app/widgets/animated_list_item.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final int index;

  const BlogCard({
    super.key,
    required this.blog,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedListItem(
      index: index,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  BlogDetailScreen(
                title: blog.title,
                imageUrl: blog.imageUrl,
                date: blog.date,
                readTime: blog.readTime,
                blogId: blog.id,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child){
                return FadeTransition(opacity: animation, child: child,);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'blog_${blog.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BlogImageWithShimmer(
                      imageUrl: blog.imageUrl,
                      blogId: blog.id,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          blog.date,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          blog.readTime,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      blog.title,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      blog.excerpt,
                      style:
                          TextStyle(color: Colors.grey.shade600, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Read More',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.yellow,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
