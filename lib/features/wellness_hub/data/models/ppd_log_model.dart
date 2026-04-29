import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/ppd_log.dart';

/// Data Transfer Object for PPDLog
class PPDLogModel extends PPDLog {
  PPDLogModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.score,
    required super.mood,
    required super.answers,
    super.notes,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'score': score,
      'mood': mood,
      'answers': answers,
      'notes': notes,
    };
  }

  /// Create from Firestore document
  factory PPDLogModel.fromJson(Map<String, dynamic> json) {
    return PPDLogModel(
      id: json['id'] as String? ?? json['id'] ?? '',
      userId: json['userId'] as String,
      date: (json['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      score: json['score'] as int? ?? 0,
      mood: json['mood'] as String? ?? 'Neutral',
      answers: Map<String, int>.from(json['answers'] as Map? ?? {}),
      notes: json['notes'] as String?,
    );
  }

  /// Create from Firestore document snapshot
  factory PPDLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PPDLogModel.fromJson({...data, 'id': doc.id});
  }

  /// Convert domain entity to model
  factory PPDLogModel.fromEntity(PPDLog log) {
    return PPDLogModel(
      id: log.id,
      userId: log.userId,
      date: log.date,
      score: log.score,
      mood: log.mood,
      answers: log.answers,
      notes: log.notes,
    );
  }
}

