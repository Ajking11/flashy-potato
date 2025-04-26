import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

/// A service for handling image loading, caching, and error handling
/// Provides a centralized way to load images with caching functionality
class ImageService {
  static final ImageService _instance = ImageService._internal();
  
  factory ImageService() => _instance;
  
  ImageService._internal();
  
  /// Default image error handler that shows a customizable error widget
  Widget defaultErrorWidget(
    BuildContext context, 
    String? url, 
    dynamic error,
    {String errorMessage = 'Image Error',
     IconData icon = Icons.broken_image,
     double iconSize = 50,
     Color? iconColor,
     double fontSize = 12,
     BoxDecoration? decoration}
  ) {
    // Log error in debug mode
    if (kDebugMode) {
      print('ImageService: Error loading image: $url');
      print('Error details: $error');
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: decoration ?? BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Default loading widget that shows a progress indicator
  Widget defaultLoadingWidget(
    BuildContext context, 
    String? url,
    {double? progress,
     Color progressColor = costaRed}
  ) {
    return Center(
      child: CircularProgressIndicator(
        value: progress,
        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
      ),
    );
  }
  
  /// Load a network image with caching
  Widget loadNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Duration placeholderFadeInDuration = const Duration(milliseconds: 500),
    Widget Function(BuildContext, String, dynamic)? errorWidget,
    Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        progressIndicatorBuilder: progressIndicatorBuilder ?? 
          (context, url, progress) => defaultLoadingWidget(
            context, 
            url,
            progress: progress.progress,
          ),
        errorWidget: errorWidget ?? 
          (context, url, error) => defaultErrorWidget(
            context, 
            url, 
            error,
          ),
        fadeInDuration: placeholderFadeInDuration,
      ),
    );
  }
  
  /// Load an asset image with error handling
  Widget loadAssetImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Widget Function(BuildContext, Object, StackTrace?)? errorWidget,
    int? cacheWidth,
    int? cacheHeight,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: errorWidget ?? 
          (context, error, stackTrace) => defaultErrorWidget(
            context, 
            assetPath, 
            error,
            errorMessage: 'Asset Not Found',
          ),
      ),
    );
  }
  
  /// Handle machine images which could be network or asset images
  Widget loadMachineImage({
    required String? imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String manufacturer = '',
    String model = '',
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    int? cacheWidth,
  }) {
    // Handle Firebase Storage paths (gs://)
    if (imagePath != null && imagePath.startsWith('gs://')) {
      if (kDebugMode) {
        print('ImageService: Firebase Storage path detected. Using placeholder: $imagePath');
      }
      
      // Use a placeholder for Firebase Storage paths
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image,
              size: 40,
              color: costaRed.withAlpha((255 * 0.7).round()),
            ),
            const SizedBox(height: 8),
            Text(
              'Storage URL',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    // If imagePath is null or empty, show placeholder
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.coffee_maker,
              size: 60,
              color: costaRed.withAlpha((255 * 0.7).round()),
            ),
            const SizedBox(height: 8),
            Text(
              '$manufacturer\n$model',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: deepRed,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    // Handle network images
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return loadNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        padding: padding,
      );
    }

    // Handle asset images
    return loadAssetImage(
      assetPath: imagePath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      padding: padding,
    );
  }
}