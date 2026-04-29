import '../../../../data/models/course_model.dart';

class CoursesData {
  static List<Course> getAllCourses() {
    return [
      // Health & Wellness
      Course(
        id: 'prenatal_care_mastery',
        title: 'Safe Motherhood: Comprehensive Prenatal Care',
        description: 'A complete guide for expectant mothers covering nutrition, exercise, warning signs, and emotional well-being throughout pregnancy.',
        instructor: 'Dr. Sarah Ahmed (OBGYN)',
        category: 'health',
        level: 'beginner',
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1531983412531-1f49a365ffed?w=800', // Motherhood/Health
        rating: 4.9,
        totalStudents: 15400,
        videos: [
          CourseVideo(
            id: 'prenatal_nutrition',
            title: 'Eating for Two: Essential Nutrition',
            description: 'Learn about the vitamins, minerals, and caloric intake needed for a healthy pregnancy.',
            youtubeUrl: 'https://www.youtube.com/watch?v=kY6V68Y7X_c',
            youtubeVideoId: 'kY6V68Y7X_c',
            duration: '15:20',
            order: 1,
          ),
          CourseVideo(
            id: 'warning_signs',
            title: 'Critical Warning Signs in Pregnancy',
            description: 'Understanding when to seek immediate medical attention for your safety.',
            youtubeUrl: 'https://www.youtube.com/watch?v=F07pT77x86s',
            youtubeVideoId: 'F07pT77x86s',
            duration: '10:45',
            order: 2,
          ),
        ],
        quizzes: [
          Quiz(
            id: 'prenatal_test',
            title: 'Prenatal Knowledge Check',
            description: 'Test your understanding of safe pregnancy practices.',
            questions: [
              QuizQuestion(
                id: 'q1',
                question: 'Which nutrient is most critical in early pregnancy to prevent birth defects?',
                options: ['Vitamin C', 'Folic Acid', 'Calcium', 'Potassium'],
                correctAnswerIndex: 1,
                explanation: 'Folic acid helps prevent neural tube defects in the baby.',
              ),
              QuizQuestion(
                id: 'q2',
                question: 'When should you immediately contact a doctor?',
                options: [
                  'Mild morning nausea',
                  'A small craving for fruit',
                  'Heavy bleeding or severe abdominal pain',
                  'Feeling tired in the evening'
                ],
                correctAnswerIndex: 2,
                explanation: 'Heavy bleeding can indicate serious complications.',
              ),
            ],
          ),
        ],
        certificateAvailable: 'Yes',
      ),

      // Vocational Training
      Course(
        id: 'handicraft_business',
        title: 'Empowered Artisan: Starting Your Business',
        description: 'Learn how to transform your handmade skills into a sustainable source of income and financial independence.',
        instructor: 'Zainab Qazi',
        category: 'vocational',
        level: 'beginner',
        duration: '3.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=800', // Artisan/Workshop
        rating: 4.8,
        totalStudents: 8200,
        videos: [
          CourseVideo(
            id: 'pricing_strategy',
            title: 'Pricing Your Products for Profit',
            description: 'Calculating costs and setting prices that value your time and expertise.',
            youtubeUrl: 'https://www.youtube.com/watch?v=Yp69I_rQ0A4',
            youtubeVideoId: 'Yp69I_rQ0A4',
            duration: '12:30',
            order: 1,
          ),
          CourseVideo(
            id: 'marketing_basics',
            title: 'Marketing on a Zero Budget',
            description: 'How to use social media to reach customers without spending money.',
            youtubeUrl: 'https://www.youtube.com/watch?v=hd_H_X7_B70',
            youtubeVideoId: 'hd_H_X7_B70',
            duration: '18:15',
            order: 2,
          ),
        ],
        quizzes: [
          Quiz(
            id: 'artisan_quiz',
            title: 'Business Basics Quiz',
            description: 'Test your knowledge on starting a micro-business.',
            questions: [
              QuizQuestion(
                id: 'q1',
                question: 'What is "Profit"?',
                options: [
                  'Total money earned',
                  'Money left after subtracting all costs',
                  'The cost of materials',
                  'The price of the item'
                ],
                correctAnswerIndex: 1,
                explanation: 'Profit is what remains after you pay for materials, time, and overhead.',
              ),
            ],
          ),
        ],
        certificateAvailable: 'Yes',
      ),

      // Legal Awareness
      Course(
        id: 'rights_awareness',
        title: 'Knowing Your Rights: A Legal Guide',
        description: 'Essential information regarding property laws, family rights, and legal protection available to women.',
        instructor: 'Advocate Maryam Ishaq',
        category: 'legal',
        level: 'intermediate',
        duration: '5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1505664194779-8beaceb93744?w=800', // Justice/Law
        rating: 4.7,
        totalStudents: 12100,
        videos: [
          CourseVideo(
            id: 'property_laws',
            title: 'Inheritance and Property Rights',
            description: 'Understanding legal entitlements according to current national laws.',
            youtubeUrl: 'https://www.youtube.com/watch?v=3S5e3_Wp49Q',
            youtubeVideoId: '3S5e3_Wp49Q',
            duration: '22:40',
            order: 1,
          ),
        ],
        quizzes: [
          Quiz(
            id: 'legal_quiz',
            title: 'Rights Awareness Quiz',
            description: 'Confirm your understanding of legal protections.',
            questions: [
              QuizQuestion(
                id: 'q1',
                question: 'Which legal document secures your right to marriage conditions?',
                options: ['CNIC', 'Nikahnama', 'B-Form', 'Passport'],
                correctAnswerIndex: 1,
                explanation: 'The Nikahnama is the primary legal document governing marriage rights.',
              ),
            ],
          ),
        ],
        certificateAvailable: 'Yes',
      ),

      // Child Development
      Course(
        id: 'infant_nutrition',
        title: 'Bright Starts: Infant Health & Nutrition',
        description: 'Best practices for breastfeeding, introduction of solids, and monitoring developmental milestones in early childhood.',
        instructor: 'Dr. Amina Yusuf',
        category: 'health',
        level: 'beginner',
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1510154221590-ff63e90a136f?w=800', // Baby/Feeding
        rating: 4.9,
        totalStudents: 9800,
        videos: [
          CourseVideo(
            id: 'breastfeeding_basics',
            title: 'Mastering the Basics of Breastfeeding',
            description: 'Techniques, schedules, and overcoming common challenges.',
            youtubeUrl: 'https://www.youtube.com/watch?v=vVj_Q7MPr9I',
            youtubeVideoId: 'vVj_Q7MPr9I',
            duration: '14:50',
            order: 1,
          ),
        ],
        quizzes: [
          Quiz(
            id: 'infant_quiz',
            title: 'Healthy Beginnings Quiz',
            description: 'Check your knowledge on infant care.',
            questions: [
              QuizQuestion(
                id: 'q1',
                question: 'What is the recommended age to start introducing solid foods?',
                options: ['2 months', '4 months', '6 months', '12 months'],
                correctAnswerIndex: 2,
                explanation: 'WHO recommends exclusive breastfeeding for 6 months before introducing solids.',
              ),
            ],
          ),
        ],
        certificateAvailable: 'Yes',
      ),
      // Marketing Category
      Course(
        id: 'mrkt-1',
        title: 'Digital Marketing for Business',
        description: 'Master social media and online sales to grow your small business.',
        instructor: 'Sarah Jenkins',
        category: 'digital_marketing',
        level: 'beginner',
        duration: '3h 15m',
        imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=500',
        rating: 4.8,
        totalStudents: 1250,
        videos: [],
        quizzes: [],
      ),
      // Leadership Category
      Course(
        id: 'lead-1',
        title: 'Women in Leadership',
        description: 'Build confidence and communication skills to lead successfully.',
        instructor: 'Emma Wilson',
        category: 'leadership',
        level: 'intermediate',
        duration: '2h 45m',
        imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500',
        rating: 4.9,
        totalStudents: 850,
        videos: [],
        quizzes: [],
      ),
      // Health Category
      Course(
        id: 'hlth-1',
        title: 'Women\'s Maternal Health',
        description: 'Complete guide to reproductive health and prenatal care.',
        instructor: 'Dr. Maria Garcia',
        category: 'health',
        level: 'beginner',
        duration: '4h 20m',
        imageUrl: 'https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?w=500',
        rating: 4.7,
        totalStudents: 2100,
        videos: [],
        quizzes: [],
      ),
    ];
  }

  static List<Course> getCoursesByCategory(String category) {
    if (category.toLowerCase() == 'all') {
      return getAllCourses();
    }
    return getAllCourses()
        .where((course) => course.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  static Course? getCourseById(String id) {
    try {
      return getAllCourses().firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }
}
