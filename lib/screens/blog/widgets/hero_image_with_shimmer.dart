import 'package:flutter/material.dart';
import 'package:furniture_shop_app/widgets/shimmer_loading.dart';

class HeroImageWithShimmer extends StatefulWidget {
  final String imageUrl;

  const HeroImageWithShimmer({
    super.key,
    required this.imageUrl,
  });

  @override
  State<HeroImageWithShimmer> createState() => _HeroImageWithShimmerState();
}

class _HeroImageWithShimmerState extends State<HeroImageWithShimmer> {
  late final ImageProvider _imageProvider;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _imageProvider = AssetImage(widget.imageUrl);
    _loadImage();
  }

  void _loadImage() {
    final ImageStream stream = _imageProvider.resolve(ImageConfiguration.empty);
    stream.addListener(
      ImageStreamListener((ImageInfo image, bool synchronousCall) {
        if (mounted && _isLoading) {
          setState(() {
            _isLoading = false;
          });
        }
      }, onError: (exception, stackTrace) {
        if (mounted && !_hasError) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_hasError) {
      return Container(
        color: Colors.grey.shade100,
        child: const Icon(Icons.image, size: 50, color: Colors.grey,),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        ShimmerLoading(
    isLoading: _isLoading,
            child: Container(
              color: Colors.white,
            ),
           ),
        Image(
            image: _imageProvider,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
