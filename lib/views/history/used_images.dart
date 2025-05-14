import 'package:flutter/material.dart';
import 'dart:io';

class UsedImages extends StatefulWidget {
  const UsedImages({
    Key? key,
  }) : super(key: key);

  @override
  _UsedImagesState createState() => _UsedImagesState();
}

class _UsedImagesState extends State<UsedImages> {
  List<String> imagePaths = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsedImages();
  }

  Future<void> _loadUsedImages() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      imagePaths = [
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',
        'C:/Users/HP/Desktop/Adsıaz.jpg',

        // Add more image paths as needed
      ];
      isLoading = false;
    });
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
        return GestureDetector(
          onTap: () {
            _onImageSelected(imagePath);
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
            child: FutureBuilder<bool>(
              future: File(imagePath).exists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final fileExists = snapshot.data ?? false;

                if (fileExists) {
                  return Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorImage();
                    },
                  );
                } else {
                  return _buildErrorImage();
                }
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

  void _onImageSelected(String imagePath) {
    // You can navigate back with the selected image or show a detail view
    print('Selected image: $imagePath');

    // Example: Navigate back with result
    // Navigator.of(context).pop(imagePath);

    // Or show image details
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageDetailView(imagePath: imagePath),
      ),
    );
  }
}

// Simple image detail view
class _ImageDetailView extends StatelessWidget {
  final String imagePath;

  const _ImageDetailView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resim Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implement delete functionality
              _showDeleteConfirmation(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Use this image for material detection
              Navigator.of(context).pop(imagePath);
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Resim yüklenemedi',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resmi Sil'),
        content: const Text('Bu resmi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete functionality
              _deleteImage(context);
              Navigator.of(context).pop();
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteImage(BuildContext context) {
    // Here you would implement the actual deletion logic
    // 1. Delete file from storage
    // 2. Update saved paths list
    // 3. Navigate back with refresh flag

    print('Deleting image: $imagePath');

    // Example:
    // File(imagePath).delete().then((_) {
    //   // Update storage/preferences to remove this path
    //   Navigator.of(context).pop({'refresh': true});
    // });

    // For now, just navigate back
    Navigator.of(context).pop();
  }
}
