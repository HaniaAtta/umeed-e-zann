class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String category; // 'coding', 'digital_marketing', 'wordpress'
  final String level; // 'beginner', 'intermediate', 'advanced'
  final String duration; // e.g., "2 hours"
  final String imageUrl;
  final double rating;
  final int totalStudents;
  final List<CourseVideo> videos;
  final List<Quiz> quizzes;
  final String? certificateAvailable;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.category,
    required this.level,
    required this.duration,
    required this.imageUrl,
    required this.rating,
    required this.totalStudents,
    required this.videos,
    required this.quizzes,
    this.certificateAvailable,
  });

  String get categoryDisplayName {
    switch (category) {
      case 'coding':
        return 'Coding & Development';
      case 'digital_marketing':
        return 'Digital Marketing';
      case 'wordpress':
        return 'WordPress & Web Design';
      case 'crochet':
        return 'Crochet & Handmade';
      case 'knitting':
        return 'Knitting & Textiles';
      default:
        return category;
    }
  }

  String get levelDisplayName {
    switch (level) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return level;
    }
  }
}

class CourseVideo {
  final String id;
  final String title;
  final String description;
  final String youtubeUrl;
  final String youtubeVideoId; // Extracted from URL
  final String duration; // e.g., "15:30"
  final int order;

  CourseVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeUrl,
    required this.youtubeVideoId,
    required this.duration,
    required this.order,
  });
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int passingScore; // Percentage

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    this.passingScore = 70,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}

class CourseProgress {
  final String courseId;
  final List<String> completedVideoIds;
  final Map<String, QuizResult> quizResults; // quizId -> QuizResult
  final double overallProgress; // 0.0 to 1.0

  CourseProgress({
    required this.courseId,
    required this.completedVideoIds,
    required this.quizResults,
    required this.overallProgress,
  });
}

class QuizResult {
  final String quizId;
  final int score; // Percentage
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;
  final bool passed;

  QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
    required this.passed,
  });
}
