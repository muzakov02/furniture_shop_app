import 'package:flutter/material.dart';
import 'package:furniture_shop_app/widgets/shimmer_loading.dart';
class BlogImageWithShimmer extends StatefulWidget {
  final String imageUrl;
  final String blogId;
  const BlogImageWithShimmer({
    super.key,
    required this.imageUrl,
    required this.blogId,
  });

  @override
  State<BlogImageWithShimmer> createState() => _BlogImageWithShimmerState();
}

class _BlogImageWithShimmerState extends State<BlogImageWithShimmer> {

  ImageProvider?  _imageProvider;
  bool _isLoading = true;
  bool  _hasError = false;

  @override
  void initState() {
    super.initState();
    updateImageProvider();
  }

  @override
  void didUpdateWidget(covariant BlogImageWithShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.imageUrl != widget.imageUrl){
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      updateImageProvider();
    }
  }

  void updateImageProvider(){
    _imageProvider = AssetImage(widget.imageUrl);
    loadImage();
  }

  void loadImage(){
    if(_imageProvider == null) return;

    final ImageStream stream = _imageProvider!.resolve(ImageConfiguration.empty);
    stream.addListener(
      ImageStreamListener(
          (ImageInfo image , bool synchronoursCall){
            if(mounted && _isLoading){
              setState(() {
                _isLoading = false;
              });
            }
          },
        onError: (dynamic exception , StackTrace? stackTrace){
            if(mounted && !_hasError){
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            }
        }
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey.shade200,
        child: const  Icon(
          Icons.image,
          size: 50,
          color: Colors.grey,
        ),
      );
    }
    return Stack(
fit: StackFit.expand,
      children: [
        ShimmerLoading(
          isLoading: _isLoading,
          child: Container(color: Colors.white),
        ),
        if(_imageProvider != null)
          Image(
              image: _imageProvider!,
          fit: BoxFit.cover,
            key: ValueKey('${widget.blogId}_${widget.imageUrl}'),
          ),
      ],
    );
  }
}
