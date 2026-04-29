import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/verification_entity.dart';
import '../models/verification_model.dart';

/// Remote data source for verification operations (Firebase)
abstract class VerificationRemoteDataSource {
  Future<String> submitVerification(VerificationEntity verification);
  Stream<List<VerificationEntity>> getUserVerifications(String userId);
  Future<VerificationEntity?> getVerification(String verificationId);
  Future<void> updateVerificationStatus(String verificationId, String status, {String? notes});
}

class VerificationRemoteDataSourceImpl implements VerificationRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> submitVerification(VerificationEntity verification) async {
    try {
      final verificationData = VerificationModel.fromEntity(verification).toFirestore();
      verificationData.remove('id'); // Remove id as Firestore generates it

      final docRef = await _firestore.collection('verifications').add(verificationData);
      return docRef.id;
    } catch (e) {
      debugPrint('Error submitting verification: $e');
      throw Exception('Failed to submit verification: $e');
    }
  }

  @override
  Stream<List<VerificationEntity>> getUserVerifications(String userId) {
    try {
      return _firestore
          .collection('verifications')
          .where('userId', isEqualTo: userId)
          .orderBy('submittedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return VerificationModel.fromFirestore(doc).toEntity();
        }).toList();
      }).handleError((error) {
        debugPrint('Error getting user verifications: $error');
        return <VerificationEntity>[];
      });
    } catch (e) {
      debugPrint('Error in getUserVerifications stream: $e');
      return Stream.value(<VerificationEntity>[]);
    }
  }

  @override
  Future<VerificationEntity?> getVerification(String verificationId) async {
    try {
      final doc = await _firestore.collection('verifications').doc(verificationId).get();
      if (!doc.exists) return null;
      return VerificationModel.fromFirestore(doc).toEntity();
    } catch (e) {
      debugPrint('Error getting verification: $e');
      throw Exception('Failed to get verification: $e');
    }
  }

  @override
  Future<void> updateVerificationStatus(String verificationId, String status, {String? notes}) async {
    try {
      final updateData = {
        'status': status,
        'reviewedAt': Timestamp.fromDate(DateTime.now()),
      };
      if (notes != null) {
        updateData['reviewNotes'] = notes;
      }
      await _firestore.collection('verifications').doc(verificationId).update(updateData);
    } catch (e) {
      debugPrint('Error updating verification status: $e');
      throw Exception('Failed to update verification status: $e');
    }
  }
}

