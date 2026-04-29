import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Upload profile image
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not logged in');

      // Ensure the file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      
      // Upload with metadata
      await ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'userId': userId},
        ),
      );
      
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        // Retry upload
        final userId = currentUserId;
        if (userId == null) throw Exception('User not logged in');
        final ref = _storage.ref().child('profile_images').child('$userId.jpg');
        await ref.putFile(imageFile);
        return await ref.getDownloadURL();
      }
      throw Exception('Failed to upload profile image: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Upload document
  Future<String> uploadDocument(File file, String fileName) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not logged in');

      // Ensure the file exists
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }

      // Sanitize fileName to avoid issues
      final sanitizedFileName = fileName.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
      
      final ref = _storage
          .ref()
          .child('documents')
          .child(userId)
          .child(sanitizedFileName);
      
      // Determine content type
      String? contentType;
      final ext = sanitizedFileName.split('.').last.toLowerCase();
      if (['jpg', 'jpeg'].contains(ext)) {
        contentType = 'image/jpeg';
      } else if (ext == 'png') {
        contentType = 'image/png';
      } else if (ext == 'pdf') {
        contentType = 'application/pdf';
      } else if (['doc', 'docx'].contains(ext)) {
        contentType = 'application/msword';
      }
      
      // Upload with metadata
      await ref.putFile(
        file,
        SettableMetadata(
          contentType: contentType,
          customMetadata: {'userId': userId, 'fileName': sanitizedFileName},
        ),
      );
      
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        // Retry upload
        final userId = currentUserId;
        if (userId == null) throw Exception('User not logged in');
        final sanitizedFileName = fileName.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
        final ref = _storage
            .ref()
            .child('documents')
            .child(userId)
            .child(sanitizedFileName);
        await ref.putFile(file);
        return await ref.getDownloadURL();
      }
      throw Exception('Failed to upload document: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  // Upload product image
  Future<String> uploadProductImage(File imageFile, String productId, int index) async {
    try {
      final ref = _storage
          .ref()
          .child('products')
          .child(productId)
          .child('image_$index.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload product image: $e');
    }
  }

  // Delete file
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}

