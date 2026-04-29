// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Umeed e Zann';

  @override
  String get home => 'Home';

  @override
  String get welcome => 'Welcome';

  @override
  String welcomeUser(String userName) {
    return 'Welcome, $userName';
  }

  @override
  String get searchServices => 'Search services, resources...';

  @override
  String get sos => 'SOS';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get todaysHighlights => 'Today\'s Highlights';

  @override
  String get recentMessages => 'Recent Messages';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get startConversation => 'Start a conversation with someone';

  @override
  String get continueText => 'Continue';

  @override
  String get newChat => 'New Chat';

  @override
  String get viewAll => 'View All';

  @override
  String get safetyShield => 'Safety Shield';

  @override
  String get wellnessHub => 'Wellness Hub';

  @override
  String get growthAcademy => 'Growth Academy';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get legalAid => 'Legal Aid';

  @override
  String get community => 'Community';

  @override
  String get mentalSanctuary => 'Mental Sanctuary';

  @override
  String get cycleTracker => 'Cycle Tracker';

  @override
  String get maternityWing => 'Maternity Wing';

  @override
  String get teleHealth => 'Tele-Health';

  @override
  String get familyPlanning => 'Family Planning';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get logSymptoms => 'Log Symptoms';

  @override
  String get searchDoctors => 'Search doctors...';

  @override
  String get cramps => 'Cramps';

  @override
  String get headache => 'Headache';

  @override
  String get energetic => 'Energetic';

  @override
  String get bloating => 'Bloating';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get view => 'View';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get submit => 'Submit';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get trySearching =>
      'Try searching for: Safety, Wellness, Growth, Marketplace, Legal, or Community';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get exploreNewCourses => 'Explore new courses and skills';

  @override
  String get safetyReminder => 'Safety Reminder';

  @override
  String get addTrustedContacts => 'Add trusted contacts for SOS alerts';

  @override
  String get shareLocation => 'Share Your Location';

  @override
  String get safetyTip => 'Safety Tip';

  @override
  String get upcomingAppointment => 'Upcoming Appointment';

  @override
  String cycleDay(int day) {
    return 'Cycle Day $day';
  }

  @override
  String takeCare(int day) {
    return 'Day $day of your period - Take care!';
  }

  @override
  String fertileWindow(int day) {
    return 'Day $day - Fertile window approaching';
  }

  @override
  String cycleOnTrack(int day) {
    return 'Day $day - Your cycle is on track';
  }

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String inDays(int days) {
    return 'In $days days';
  }

  @override
  String conversations(int count) {
    return '$count conversation';
  }

  @override
  String conversationsPlural(int count) {
    return '$count conversations';
  }

  @override
  String get language => 'Language';

  @override
  String get profile => 'Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get location => 'Location';

  @override
  String get notSet => 'Not set';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get profileUpdateFailed => 'Failed to update profile';

  @override
  String get imageUploaded => 'Profile picture updated';

  @override
  String get imageUploadFailed => 'Failed to upload image';

  @override
  String get validEmailError => 'Please enter a valid email address';

  @override
  String get pickImageError => 'Failed to pick image';

  @override
  String get safetyShieldTitle => 'Your Safety Shield';

  @override
  String get safetyShieldDesc => 'Immediate response features to keep you safe';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get oneTouchSos => 'One-Touch SOS';

  @override
  String get oneTouchSosDesc =>
      'Instantly send live location, audio recording, and help message';

  @override
  String get liveTracking => 'Live Tracking';

  @override
  String get liveTrackingDesc =>
      'Allow friends/family to track your real-time movement';

  @override
  String get shakeToAlert => 'Shake to Alert';

  @override
  String get shakeToAlertDesc => 'Trigger SOS discreetly by shaking your phone';

  @override
  String get fakeCallGenerator => 'Fake Call Generator';

  @override
  String get fakeCallDesc =>
      'Generate a realistic incoming call to help you exit uncomfortable social situations safely and naturally.';

  @override
  String get manageTrustedContacts => 'Manage Trusted Contacts';

  @override
  String get manageTrustedContactsDesc =>
      'Add or remove contacts who will receive your SOS alerts';

  @override
  String get documentVault => 'Document Vault';

  @override
  String get uploadDocument => 'Upload Document';

  @override
  String get secureStorageDesc => 'Secure storage for legal documents';

  @override
  String get yourDocuments => 'Your Documents';

  @override
  String get noDocumentsYet => 'No documents yet';

  @override
  String get uploadFirstDoc => 'Upload your first document to get started';

  @override
  String filesCount(int count) {
    return '$count files';
  }

  @override
  String get unknownDate => 'Unknown date';

  @override
  String get uploadingDoc => 'Uploading document...';

  @override
  String get docUploadSuccess => 'Document uploaded successfully!';

  @override
  String get docUploadFailed => 'Failed to upload document';

  @override
  String get loginToUpload => 'Please log in to upload documents';

  @override
  String get sosActivationInfo => 'What happens when you activate SOS?';

  @override
  String get liveLocationShared => 'Your live location is shared';

  @override
  String get audioRecordingStarted => 'Audio recording starts automatically';

  @override
  String get helpMessageSent =>
      'Help message sent to trusted contacts & police';

  @override
  String get tapToActivateSos => 'Tap the button above to activate SOS';

  @override
  String sosCountdownText(int count) {
    return 'SOS will activate in $count seconds...';
  }

  @override
  String get sosAlertSent =>
      'SOS Alert Sent! Trusted contacts have been notified.';

  @override
  String get locationServicesDisabled =>
      'Location services are disabled. Please enable location services.';

  @override
  String get locationPermissionsRequired =>
      'Location permissions are required for SOS alerts.';

  @override
  String get locationPermissionsDeniedForever =>
      'Location permissions are permanently denied. Please enable in settings.';

  @override
  String get errorSendingSos => 'Error sending SOS alert';

  @override
  String get testAlert => 'Test Alert';

  @override
  String get testAlertSent => 'Test alert sent to trusted contacts';

  @override
  String get locationShared => 'Location shared';

  @override
  String get errorOpeningDoc => 'Could not open document URL';

  @override
  String get searchDocs => 'Search documents...';

  @override
  String get searchCourses => 'Search courses...';

  @override
  String get allCourses => 'All Courses';

  @override
  String get coding => 'Coding';

  @override
  String get marketing => 'Marketing';

  @override
  String get wordpress => 'WordPress';

  @override
  String get crochet => 'Crochet';

  @override
  String get knitting => 'Knitting';

  @override
  String get noCoursesFound => 'No courses found';

  @override
  String get courseProgress => 'Course Progress';

  @override
  String videosCount(Object count) {
    return '$count videos';
  }

  @override
  String get courseVideos => 'Course Videos';

  @override
  String get quickRecapQuizzes => 'Quick Recap Quizzes';

  @override
  String scoreText(Object correct, Object score, Object total) {
    return 'Score: $score% ($correct/$total)';
  }

  @override
  String get errorOpeningVideo =>
      'Could not open video. Please check your internet connection or install YouTube app.';

  @override
  String errorOpeningVideoGeneral(Object error) {
    return 'Error opening video: $error';
  }

  @override
  String get quizResults => 'Quiz Results';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get keepLearning => 'Keep Learning!';

  @override
  String quizScoreSummary(Object correct, Object total) {
    return 'You got $correct out of $total questions correct';
  }

  @override
  String passingScoreText(Object score) {
    return 'Passing Score: $score%';
  }

  @override
  String get backToCourse => 'Back to Course';

  @override
  String questionProgress(Object current, Object total) {
    return 'Question $current of $total';
  }

  @override
  String get finishQuiz => 'Finish Quiz';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get previous => 'Previous';

  @override
  String get certificates => 'Certificates';

  @override
  String get noCertificatesYet => 'No certificates yet';

  @override
  String get completeCoursesToEarn => 'Complete courses to earn certificates';

  @override
  String get browseCourses => 'Browse Courses';

  @override
  String get certOfCompletion => 'Certificate of Completion';

  @override
  String get readyForCert => 'Ready for Certificate';

  @override
  String certNumber(Object number) {
    return 'Cert #: $number';
  }

  @override
  String instructorLabel(Object instructor) {
    return 'Instructor: $instructor';
  }

  @override
  String issuedLabel(Object date) {
    return 'Issued: $date';
  }

  @override
  String completedLabel(Object date) {
    return 'Completed: $date';
  }

  @override
  String get viewCertificate => 'View Certificate';

  @override
  String get generateCertificate => 'Generate Certificate';

  @override
  String get certGeneratedSuccess => 'Certificate generated successfully';

  @override
  String get errorOpeningCert => 'Error opening certificate';

  @override
  String get myProgress => 'My Progress';

  @override
  String get all => 'All';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get noCoursesStarted => 'No courses started yet';

  @override
  String get noCoursesInProgress => 'No courses in progress';

  @override
  String get noCompletedCourses => 'No completed courses';

  @override
  String get startLearningExplore => 'Start learning by exploring courses';

  @override
  String get bookmarkedCoursesTitle => 'Bookmarked Courses';

  @override
  String get noBookmarkedCourses => 'No bookmarked courses';

  @override
  String get bookmarkToAccessQuickly =>
      'Bookmark courses to access them quickly';

  @override
  String get financialLiteracy => 'Financial Literacy';

  @override
  String get empowerFinancialKnowledge =>
      'Empower yourself with financial knowledge';

  @override
  String get keyTopics => 'Key Topics';

  @override
  String get budgetingSaving => 'Budgeting & Saving';

  @override
  String get budgetingDesc => 'Learn to manage money effectively';

  @override
  String get bankingCredit => 'Banking & Credit';

  @override
  String get bankingDesc => 'Understanding accounts and credit scores';

  @override
  String get investingBasics => 'Investing Basics';

  @override
  String get investingDesc => 'Grow your wealth for the future';

  @override
  String get financialSecurity => 'Financial Security';

  @override
  String get securityDesc => 'Protect yourself from fraud';

  @override
  String get entrepreneurship => 'Entrepreneurship';

  @override
  String get entrepreneurshipDesc => 'Starting your own business';

  @override
  String get taxPlanning => 'Tax Planning';

  @override
  String get taxDesc => 'Understanding tax obligations';

  @override
  String get resources => 'Resources';

  @override
  String get financialCalculators => 'Financial Calculators';

  @override
  String get calculatorsDesc => 'Tools for planning';

  @override
  String get videoTutorials => 'Video Tutorials';

  @override
  String get tutorialsDesc => 'Visual learning guides';

  @override
  String get articlesGuides => 'Articles & Guides';

  @override
  String get articlesDesc => 'In-depth reading materials';

  @override
  String get moreContentComingSoon => 'More content coming soon!';

  @override
  String get keyLearningPoints => 'Key Learning Points';

  @override
  String get understandFundamentals => 'Understand the fundamentals';

  @override
  String get learnPracticalApps => 'Learn practical applications';

  @override
  String get getActionableTips => 'Get actionable tips';

  @override
  String get accessRealWorldExamples => 'Access real-world examples';

  @override
  String get startLearning => 'Start Learning';

  @override
  String detailedContentComingSoon(String title) {
    return 'Detailed content for $title coming soon!';
  }

  @override
  String featureComingSoon(String title) {
    return 'The feature $title is coming soon!';
  }

  @override
  String get close => 'Close';

  @override
  String get access => 'Access';

  @override
  String get codingCategory => 'Coding';

  @override
  String get marketingCategory => 'Digital Marketing';

  @override
  String get wordpressCategory => 'WordPress';

  @override
  String get crochetCategory => 'Crochet';

  @override
  String get knittingCategory => 'Knitting';

  @override
  String get beginnerLevel => 'Beginner';

  @override
  String get intermediateLevel => 'Intermediate';

  @override
  String get advancedLevel => 'Advanced';

  @override
  String get shareLocationDesc =>
      'Allow trusted contacts to track your real-time location during commutes or when you feel unsafe.';

  @override
  String get trackingDuration => 'Tracking Duration';

  @override
  String get fifteenMin => '15 minutes';

  @override
  String get thirtyMin => '30 minutes';

  @override
  String get oneHour => '1 hour';

  @override
  String get untilStop => 'Until I stop';

  @override
  String get liveTrackingActive => 'Live Tracking Active';

  @override
  String get trackingNotActive => 'Tracking Not Active';

  @override
  String get locationSharedDesc =>
      'Your location is being shared with trusted contacts';

  @override
  String get stopTracking => 'Stop Tracking';

  @override
  String get startLiveTracking => 'Start Live Tracking';

  @override
  String get onlyTrustedContactsView =>
      'Only your trusted contacts can view your location';

  @override
  String get addTrustedContactsFirst => 'Please add trusted contacts first';

  @override
  String get locationPermissionRequired =>
      'Location permissions are required for live tracking.';

  @override
  String get locationPermissionDeniedForever =>
      'Location permissions are permanently denied. Please enable in settings.';

  @override
  String get trackingStarted => 'Live tracking started';

  @override
  String errorStartingTracking(Object error) {
    return 'Error starting tracking: $error';
  }

  @override
  String get trackingStopped => 'Live tracking stopped';

  @override
  String errorStoppingTracking(Object error) {
    return 'Error stopping tracking: $error';
  }

  @override
  String get discreetSosActivation => 'Discreet SOS Activation';

  @override
  String get discreetSosDesc =>
      'Shake your phone to trigger SOS alerts without drawing attention. Perfect for situations where you need help discreetly.';

  @override
  String get shakeAlertEnabledMsg =>
      'Enabled - Shake your phone to trigger SOS';

  @override
  String get shakeAlertDisabledMsg => 'Disabled - Turn on to activate';

  @override
  String get sensitivity => 'Sensitivity';

  @override
  String get adjustSensitivityDesc =>
      'Adjust how sensitive the shake detection is';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get veryLow => 'Very Low';

  @override
  String get veryHigh => 'Very High';

  @override
  String get testShakeDetection => 'Test Shake Detection';

  @override
  String get howItWorks => 'How it works';

  @override
  String get enableShakeAlert => 'Enable Shake to Alert';

  @override
  String get shakePhoneHelp => 'Shake your phone when you need help';

  @override
  String get sosAlertSentAuto => 'SOS alert will be sent automatically';

  @override
  String get shakeAlertEnabledSnack => 'Shake to Alert enabled';

  @override
  String get shakeAlertDisabledSnack => 'Shake to Alert disabled';

  @override
  String get sosAlertTriggeredByShake =>
      'SOS Alert triggered by shake detection';

  @override
  String get sosAlertSentTrustedNotified =>
      'SOS Alert Sent! Trusted contacts have been notified.';

  @override
  String errorSendingSosAlert(Object error) {
    return 'Error sending SOS alert: $error';
  }

  @override
  String get exitUncomfortableSituations => 'Exit Uncomfortable Situations';

  @override
  String get selectCaller => 'Select Caller';

  @override
  String get mom => 'Mom';

  @override
  String get dad => 'Dad';

  @override
  String get bestFriend => 'Best Friend';

  @override
  String get boss => 'Boss';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get incomingCall => 'Incoming Call';

  @override
  String get end => 'End';

  @override
  String get readyToGenerateCall => 'Ready to Generate Call';

  @override
  String get tapToStartFakeCall => 'Tap the button below to start a fake call';

  @override
  String get generateFakeCall => 'Generate Fake Call';

  @override
  String get endCall => 'End Call';

  @override
  String get tips => 'Tips';

  @override
  String get tipAnswerNaturally =>
      'Answer the call naturally and excuse yourself';

  @override
  String get tipRealisticScreen =>
      'The call will look realistic on your screen';

  @override
  String get tipEndAnytime => 'You can end the call anytime';

  @override
  String get trustedContactsTitle => 'Trusted Contacts';

  @override
  String get addTrustedContact => 'Add Trusted Contact';

  @override
  String get name => 'Name';

  @override
  String get enterContactName => 'Enter contact name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get relation => 'Relation';

  @override
  String get familyFriendHint => 'Family, Friend, etc.';

  @override
  String get contactAddedSuccess => 'Contact added successfully';

  @override
  String get deleteContact => 'Delete Contact';

  @override
  String deleteContactConfirm(Object name) {
    return 'Are you sure you want to remove $name from your trusted contacts?';
  }

  @override
  String get contactRemoved => 'Contact removed';

  @override
  String get trustedContactsDesc =>
      'These contacts will receive your SOS alerts';

  @override
  String get noTrustedContacts => 'No trusted contacts yet';

  @override
  String get addContactsToReceiveSos =>
      'Add contacts to receive your SOS alerts';

  @override
  String get contactLabel => 'Contact';

  @override
  String get sellItem => 'Sell Item';

  @override
  String get searchProducts => 'Search products or services...';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get handmade => 'Handmade';

  @override
  String get clothing => 'Clothing';

  @override
  String get accessories => 'Accessories';

  @override
  String get beauty => 'Beauty';

  @override
  String get homeDecor => 'Home Decor';

  @override
  String get services => 'Services';

  @override
  String get exploreWellness =>
      'Explore our wellness features designed just for you';

  @override
  String get cycleTrackerDesc =>
      'Track your menstrual cycle, log symptoms, and get personalized insights';

  @override
  String get maternityWingDesc =>
      'Pregnancy tracking, milestones, and post-partum support for mothers';

  @override
  String get mentalSanctuaryDesc =>
      'Meditation, journaling, and mental wellness tools for your peace of mind';

  @override
  String get teleHealthDesc =>
      'Connect with trusted gynecologists and psychologists from home';

  @override
  String get familyPlanningDesc =>
      'Learn about contraception methods and make informed decisions';

  @override
  String get welcomeGreeting => 'Welcome';

  @override
  String get familyLaw => 'Family Law';

  @override
  String get propertyRights => 'Property Rights';

  @override
  String get inheritance => 'Inheritance';

  @override
  String get laborRights => 'Labor Rights';

  @override
  String get criminalLaw => 'Criminal Law';

  @override
  String get cyberSecurity => 'Cyber Security';

  @override
  String get legalRightsWiki => 'Legal Rights Wiki';

  @override
  String get knowYourRights => 'Know Your Rights';

  @override
  String get legalHeroDesc =>
      'Comprehensive guides to protect and empower yourself';

  @override
  String articlesCount(int count) {
    return '$count articles';
  }

  @override
  String get sosAlertMessageContent =>
      'Emergency SOS Alert - User needs immediate assistance';

  @override
  String get sosTriggeredByShake => 'SOS Triggered by Shake';

  @override
  String get sosAlertSentShort => 'SOS Alert Sent';

  @override
  String get newListing => 'New Listing';

  @override
  String get product => 'Product';

  @override
  String get service => 'Service';

  @override
  String get imagesMax5 => 'Images (Max 5)';

  @override
  String get titleLabel => 'Title';

  @override
  String get enterTitleHint => 'Enter product/service title';

  @override
  String get categoryLabel => 'Category';

  @override
  String get priceLabel => 'Price';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get describeProductHint => 'Describe your product or service...';

  @override
  String get listingCreatedSuccess => 'Listing created successfully!';

  @override
  String get publishListing => 'Publish Listing';

  @override
  String get maxImagesAllowed => 'Maximum 5 images allowed';

  @override
  String errorPickingImage(Object error) {
    return 'Error picking image: $error';
  }

  @override
  String get addImage => 'Add Image';

  @override
  String get retry => 'Retry';

  @override
  String get voiceAssistant => 'Voice Assistant';

  @override
  String get transcribed => 'Transcribed:';

  @override
  String get legalAssistantResponse => 'Legal Assistant Response';

  @override
  String get gettingLegalAdvice => 'Getting legal advice...';

  @override
  String get processing => 'Processing...';

  @override
  String get microphonePermissionRequired =>
      'Microphone permission is required';

  @override
  String speechRecognitionError(Object error) {
    return 'Speech recognition error: $error';
  }

  @override
  String get speechNotAvailable =>
      'Speech recognition is not available on this device';

  @override
  String get checkPermissions =>
      'Speech recognition not available. Please check permissions.';
}
