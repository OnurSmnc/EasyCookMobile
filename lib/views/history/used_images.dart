import 'package:dio/dio.dart';
import 'package:easycook/core/data/models/usedImages/used_images_request.dart';
import 'package:easycook/core/data/repositories/ingredient_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/utils/bottomNavigationBar.dart';
import 'package:easycook/views/home/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class UsedImages extends StatefulWidget {
  const UsedImages({
    Key? key,
  }) : super(key: key);

  @override
  _UsedImagesState createState() => _UsedImagesState();
}

class _UsedImagesState extends State<UsedImages> {
  List<UsedImageModel> imagePaths = [];
  bool isLoading = true;
  late final IngredientRepository ingredientRepository;

  @override
  void initState() {
    super.initState();
    ingredientRepository = IngredientRepository();
    _loadUsedImages();
  }

  Future<void> _loadUsedImages() async {
    try {
      var response = await ingredientRepository.getUsedImages();
      setState(() {
        imagePaths = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading images: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: AppBar(
            backgroundColor: Colors.orange,
            centerTitle: true,
            title: const Text(
              'Kullanılan Resimler',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            elevation: 0,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : imagePaths.isEmpty
              ? _buildEmptyState()
              : _buildImageGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz resim kullanılmamış',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  static const String baseUrl = 'http://10.0.2.2:5001';

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        final imagePath = imagePaths[index];
        final fullImageUrl = '$baseUrl${imagePath.image}'; // Yol birleştirildi

        return GestureDetector(
          onTap: () {
            _onImageSelected(fullImageUrl);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              fullImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorImage();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[400],
          size: 40,
        ),
      ),
    );
  }

  void _onImageSelected(String imageUrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.check,
                  color: Colors.orange,
                ),
                title: const Text(
                  'Malzeme tespitinde kullan',
                  style: TextStyle(color: Colors.orange),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MainNavigationWrapper(image: imageUrl),
                    ),
                    (route) => false,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                title: const Text('İptal'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _downloadImage(String url) async {
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final tempDir = await getTemporaryDirectory();
        final savePath = '${tempDir.path}/${url.split("/").last}';
        await Dio().download(url, savePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim indirildi: $savePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Depolama izni reddedildi')),
        );
      }
    } catch (e) {
      print("İndirme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resim indirilemedi')),
      );
    }
  }
}

// // Simple image detail view
// class _ImageDetailView extends StatelessWidget {
//   final String imagePath;

//   const _ImageDetailView({required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Resim Detayı'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               // Implement delete functionality
//               _showDeleteConfirmation(context);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: () {
//               // Use this image for material detection
//               Navigator.of(context).pop(imagePath);
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: Image.file(
//             File(imagePath),
//             fit: BoxFit.contain,
//             errorBuilder: (context, error, stackTrace) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.broken_image, size: 80, color: Colors.grey[400]),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Resim yüklenemedi',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Resmi Sil'),
//         content: const Text('Bu resmi silmek istediğinizden emin misiniz?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('İptal'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Implement delete functionality
//               _deleteImage(context);
//               Navigator.of(context).pop();
//             },
//             child: const Text('Sil', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _deleteImage(BuildContext context) {
//     // Here you would implement the actual deletion logic
//     // 1. Delete file from storage
//     // 2. Update saved paths list
//     // 3. Navigate back with refresh flag

//     print('Deleting image: $imagePath');

//     // Example:
//     // File(imagePath).delete().then((_) {
//     //   // Update storage/preferences to remove this path
//     //   Navigator.of(context).pop({'refresh': true});
//     // });

//     // For now, just navigate back
//     Navigator.of(context).pop();
//   }
// }
