import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bal.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bal'),
    Locale('en'),
    Locale('pa'),
    Locale('sd'),
    Locale('tr'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Umeed e Zann'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}'**
  String welcomeUser(String userName);

  /// No description provided for @searchServices.
  ///
  /// In en, this message translates to:
  /// **'Search services, resources...'**
  String get searchServices;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @todaysHighlights.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Highlights'**
  String get todaysHighlights;

  /// No description provided for @recentMessages.
  ///
  /// In en, this message translates to:
  /// **'Recent Messages'**
  String get recentMessages;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @startConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with someone'**
  String get startConversation;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @safetyShield.
  ///
  /// In en, this message translates to:
  /// **'Safety Shield'**
  String get safetyShield;

  /// No description provided for @wellnessHub.
  ///
  /// In en, this message translates to:
  /// **'Wellness Hub'**
  String get wellnessHub;

  /// No description provided for @growthAcademy.
  ///
  /// In en, this message translates to:
  /// **'Growth Academy'**
  String get growthAcademy;

  /// No description provided for @marketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// No description provided for @legalAid.
  ///
  /// In en, this message translates to:
  /// **'Legal Aid'**
  String get legalAid;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @mentalSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Mental Sanctuary'**
  String get mentalSanctuary;

  /// No description provided for @cycleTracker.
  ///
  /// In en, this message translates to:
  /// **'Cycle Tracker'**
  String get cycleTracker;

  /// No description provided for @maternityWing.
  ///
  /// In en, this message translates to:
  /// **'Maternity Wing'**
  String get maternityWing;

  /// No description provided for @teleHealth.
  ///
  /// In en, this message translates to:
  /// **'Tele-Health'**
  String get teleHealth;

  /// No description provided for @familyPlanning.
  ///
  /// In en, this message translates to:
  /// **'Family Planning'**
  String get familyPlanning;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @logSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Log Symptoms'**
  String get logSymptoms;

  /// No description provided for @searchDoctors.
  ///
  /// In en, this message translates to:
  /// **'Search doctors...'**
  String get searchDoctors;

  /// No description provided for @cramps.
  ///
  /// In en, this message translates to:
  /// **'Cramps'**
  String get cramps;

  /// No description provided for @headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get headache;

  /// No description provided for @energetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get energetic;

  /// No description provided for @bloating.
  ///
  /// In en, this message translates to:
  /// **'Bloating'**
  String get bloating;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @trySearching.
  ///
  /// In en, this message translates to:
  /// **'Try searching for: Safety, Wellness, Growth, Marketplace, Legal, or Community'**
  String get trySearching;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// No description provided for @exploreNewCourses.
  ///
  /// In en, this message translates to:
  /// **'Explore new courses and skills'**
  String get exploreNewCourses;

  /// No description provided for @safetyReminder.
  ///
  /// In en, this message translates to:
  /// **'Safety Reminder'**
  String get safetyReminder;

  /// No description provided for @addTrustedContacts.
  ///
  /// In en, this message translates to:
  /// **'Add trusted contacts for SOS alerts'**
  String get addTrustedContacts;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share Your Location'**
  String get shareLocation;

  /// No description provided for @safetyTip.
  ///
  /// In en, this message translates to:
  /// **'Safety Tip'**
  String get safetyTip;

  /// No description provided for @upcomingAppointment.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointment'**
  String get upcomingAppointment;

  /// No description provided for @cycleDay.
  ///
  /// In en, this message translates to:
  /// **'Cycle Day {day}'**
  String cycleDay(int day);

  /// No description provided for @takeCare.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of your period - Take care!'**
  String takeCare(int day);

  /// No description provided for @fertileWindow.
  ///
  /// In en, this message translates to:
  /// **'Day {day} - Fertile window approaching'**
  String fertileWindow(int day);

  /// No description provided for @cycleOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Day {day} - Your cycle is on track'**
  String cycleOnTrack(int day);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String inDays(int days);

  /// No description provided for @conversations.
  ///
  /// In en, this message translates to:
  /// **'{count} conversation'**
  String conversations(int count);

  /// No description provided for @conversationsPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} conversations'**
  String conversationsPlural(int count);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailed;

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated'**
  String get imageUploaded;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get imageUploadFailed;

  /// No description provided for @validEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmailError;

  /// No description provided for @pickImageError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get pickImageError;

  /// No description provided for @safetyShieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Safety Shield'**
  String get safetyShieldTitle;

  /// No description provided for @safetyShieldDesc.
  ///
  /// In en, this message translates to:
  /// **'Immediate response features to keep you safe'**
  String get safetyShieldDesc;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @oneTouchSos.
  ///
  /// In en, this message translates to:
  /// **'One-Touch SOS'**
  String get oneTouchSos;

  /// No description provided for @oneTouchSosDesc.
  ///
  /// In en, this message translates to:
  /// **'Instantly send live location, audio recording, and help message'**
  String get oneTouchSosDesc;

  /// No description provided for @liveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTracking;

  /// No description provided for @liveTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow friends/family to track your real-time movement'**
  String get liveTrackingDesc;

  /// No description provided for @shakeToAlert.
  ///
  /// In en, this message translates to:
  /// **'Shake to Alert'**
  String get shakeToAlert;

  /// No description provided for @shakeToAlertDesc.
  ///
  /// In en, this message translates to:
  /// **'Trigger SOS discreetly by shaking your phone'**
  String get shakeToAlertDesc;

  /// No description provided for @fakeCallGenerator.
  ///
  /// In en, this message translates to:
  /// **'Fake Call Generator'**
  String get fakeCallGenerator;

  /// No description provided for @fakeCallDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate a realistic incoming call to help you exit uncomfortable social situations safely and naturally.'**
  String get fakeCallDesc;

  /// No description provided for @manageTrustedContacts.
  ///
  /// In en, this message translates to:
  /// **'Manage Trusted Contacts'**
  String get manageTrustedContacts;

  /// No description provided for @manageTrustedContactsDesc.
  ///
  /// In en, this message translates to:
  /// **'Add or remove contacts who will receive your SOS alerts'**
  String get manageTrustedContactsDesc;

  /// No description provided for @documentVault.
  ///
  /// In en, this message translates to:
  /// **'Document Vault'**
  String get documentVault;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @secureStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure storage for legal documents'**
  String get secureStorageDesc;

  /// No description provided for @yourDocuments.
  ///
  /// In en, this message translates to:
  /// **'Your Documents'**
  String get yourDocuments;

  /// No description provided for @noDocumentsYet.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get noDocumentsYet;

  /// No description provided for @uploadFirstDoc.
  ///
  /// In en, this message translates to:
  /// **'Upload your first document to get started'**
  String get uploadFirstDoc;

  /// No description provided for @filesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} files'**
  String filesCount(int count);

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get unknownDate;

  /// No description provided for @uploadingDoc.
  ///
  /// In en, this message translates to:
  /// **'Uploading document...'**
  String get uploadingDoc;

  /// No description provided for @docUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully!'**
  String get docUploadSuccess;

  /// No description provided for @docUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload document'**
  String get docUploadFailed;

  /// No description provided for @loginToUpload.
  ///
  /// In en, this message translates to:
  /// **'Please log in to upload documents'**
  String get loginToUpload;

  /// No description provided for @sosActivationInfo.
  ///
  /// In en, this message translates to:
  /// **'What happens when you activate SOS?'**
  String get sosActivationInfo;

  /// No description provided for @liveLocationShared.
  ///
  /// In en, this message translates to:
  /// **'Your live location is shared'**
  String get liveLocationShared;

  /// No description provided for @audioRecordingStarted.
  ///
  /// In en, this message translates to:
  /// **'Audio recording starts automatically'**
  String get audioRecordingStarted;

  /// No description provided for @helpMessageSent.
  ///
  /// In en, this message translates to:
  /// **'Help message sent to trusted contacts & police'**
  String get helpMessageSent;

  /// No description provided for @tapToActivateSos.
  ///
  /// In en, this message translates to:
  /// **'Tap the button above to activate SOS'**
  String get tapToActivateSos;

  /// No description provided for @sosCountdownText.
  ///
  /// In en, this message translates to:
  /// **'SOS will activate in {count} seconds...'**
  String sosCountdownText(int count);

  /// No description provided for @sosAlertSent.
  ///
  /// In en, this message translates to:
  /// **'SOS Alert Sent! Trusted contacts have been notified.'**
  String get sosAlertSent;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable location services.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are required for SOS alerts.'**
  String get locationPermissionsRequired;

  /// No description provided for @locationPermissionsDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied. Please enable in settings.'**
  String get locationPermissionsDeniedForever;

  /// No description provided for @errorSendingSos.
  ///
  /// In en, this message translates to:
  /// **'Error sending SOS alert'**
  String get errorSendingSos;

  /// No description provided for @testAlert.
  ///
  /// In en, this message translates to:
  /// **'Test Alert'**
  String get testAlert;

  /// No description provided for @testAlertSent.
  ///
  /// In en, this message translates to:
  /// **'Test alert sent to trusted contacts'**
  String get testAlertSent;

  /// No description provided for @locationShared.
  ///
  /// In en, this message translates to:
  /// **'Location shared'**
  String get locationShared;

  /// No description provided for @errorOpeningDoc.
  ///
  /// In en, this message translates to:
  /// **'Could not open document URL'**
  String get errorOpeningDoc;

  /// No description provided for @searchDocs.
  ///
  /// In en, this message translates to:
  /// **'Search documents...'**
  String get searchDocs;

  /// No description provided for @searchCourses.
  ///
  /// In en, this message translates to:
  /// **'Search courses...'**
  String get searchCourses;

  /// No description provided for @allCourses.
  ///
  /// In en, this message translates to:
  /// **'All Courses'**
  String get allCourses;

  /// No description provided for @coding.
  ///
  /// In en, this message translates to:
  /// **'Coding'**
  String get coding;

  /// No description provided for @marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketing;

  /// No description provided for @wordpress.
  ///
  /// In en, this message translates to:
  /// **'WordPress'**
  String get wordpress;

  /// No description provided for @crochet.
  ///
  /// In en, this message translates to:
  /// **'Crochet'**
  String get crochet;

  /// No description provided for @knitting.
  ///
  /// In en, this message translates to:
  /// **'Knitting'**
  String get knitting;

  /// No description provided for @noCoursesFound.
  ///
  /// In en, this message translates to:
  /// **'No courses found'**
  String get noCoursesFound;

  /// No description provided for @courseProgress.
  ///
  /// In en, this message translates to:
  /// **'Course Progress'**
  String get courseProgress;

  /// No description provided for @videosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} videos'**
  String videosCount(Object count);

  /// No description provided for @courseVideos.
  ///
  /// In en, this message translates to:
  /// **'Course Videos'**
  String get courseVideos;

  /// No description provided for @quickRecapQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Quick Recap Quizzes'**
  String get quickRecapQuizzes;

  /// No description provided for @scoreText.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}% ({correct}/{total})'**
  String scoreText(Object correct, Object score, Object total);

  /// No description provided for @errorOpeningVideo.
  ///
  /// In en, this message translates to:
  /// **'Could not open video. Please check your internet connection or install YouTube app.'**
  String get errorOpeningVideo;

  /// No description provided for @errorOpeningVideoGeneral.
  ///
  /// In en, this message translates to:
  /// **'Error opening video: {error}'**
  String errorOpeningVideoGeneral(Object error);

  /// No description provided for @quizResults.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResults;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @keepLearning.
  ///
  /// In en, this message translates to:
  /// **'Keep Learning!'**
  String get keepLearning;

  /// No description provided for @quizScoreSummary.
  ///
  /// In en, this message translates to:
  /// **'You got {correct} out of {total} questions correct'**
  String quizScoreSummary(Object correct, Object total);

  /// No description provided for @passingScoreText.
  ///
  /// In en, this message translates to:
  /// **'Passing Score: {score}%'**
  String passingScoreText(Object score);

  /// No description provided for @backToCourse.
  ///
  /// In en, this message translates to:
  /// **'Back to Course'**
  String get backToCourse;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionProgress(Object current, Object total);

  /// No description provided for @finishQuiz.
  ///
  /// In en, this message translates to:
  /// **'Finish Quiz'**
  String get finishQuiz;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificates;

  /// No description provided for @noCertificatesYet.
  ///
  /// In en, this message translates to:
  /// **'No certificates yet'**
  String get noCertificatesYet;

  /// No description provided for @completeCoursesToEarn.
  ///
  /// In en, this message translates to:
  /// **'Complete courses to earn certificates'**
  String get completeCoursesToEarn;

  /// No description provided for @browseCourses.
  ///
  /// In en, this message translates to:
  /// **'Browse Courses'**
  String get browseCourses;

  /// No description provided for @certOfCompletion.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Completion'**
  String get certOfCompletion;

  /// No description provided for @readyForCert.
  ///
  /// In en, this message translates to:
  /// **'Ready for Certificate'**
  String get readyForCert;

  /// No description provided for @certNumber.
  ///
  /// In en, this message translates to:
  /// **'Cert #: {number}'**
  String certNumber(Object number);

  /// No description provided for @instructorLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructor: {instructor}'**
  String instructorLabel(Object instructor);

  /// No description provided for @issuedLabel.
  ///
  /// In en, this message translates to:
  /// **'Issued: {date}'**
  String issuedLabel(Object date);

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed: {date}'**
  String completedLabel(Object date);

  /// No description provided for @viewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get viewCertificate;

  /// No description provided for @generateCertificate.
  ///
  /// In en, this message translates to:
  /// **'Generate Certificate'**
  String get generateCertificate;

  /// No description provided for @certGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Certificate generated successfully'**
  String get certGeneratedSuccess;

  /// No description provided for @errorOpeningCert.
  ///
  /// In en, this message translates to:
  /// **'Error opening certificate'**
  String get errorOpeningCert;

  /// No description provided for @myProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get myProgress;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noCoursesStarted.
  ///
  /// In en, this message translates to:
  /// **'No courses started yet'**
  String get noCoursesStarted;

  /// No description provided for @noCoursesInProgress.
  ///
  /// In en, this message translates to:
  /// **'No courses in progress'**
  String get noCoursesInProgress;

  /// No description provided for @noCompletedCourses.
  ///
  /// In en, this message translates to:
  /// **'No completed courses'**
  String get noCompletedCourses;

  /// No description provided for @startLearningExplore.
  ///
  /// In en, this message translates to:
  /// **'Start learning by exploring courses'**
  String get startLearningExplore;

  /// No description provided for @bookmarkedCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Courses'**
  String get bookmarkedCoursesTitle;

  /// No description provided for @noBookmarkedCourses.
  ///
  /// In en, this message translates to:
  /// **'No bookmarked courses'**
  String get noBookmarkedCourses;

  /// No description provided for @bookmarkToAccessQuickly.
  ///
  /// In en, this message translates to:
  /// **'Bookmark courses to access them quickly'**
  String get bookmarkToAccessQuickly;

  /// No description provided for @financialLiteracy.
  ///
  /// In en, this message translates to:
  /// **'Financial Literacy'**
  String get financialLiteracy;

  /// No description provided for @empowerFinancialKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Empower yourself with financial knowledge'**
  String get empowerFinancialKnowledge;

  /// No description provided for @keyTopics.
  ///
  /// In en, this message translates to:
  /// **'Key Topics'**
  String get keyTopics;

  /// No description provided for @budgetingSaving.
  ///
  /// In en, this message translates to:
  /// **'Budgeting & Saving'**
  String get budgetingSaving;

  /// No description provided for @budgetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn to manage money effectively'**
  String get budgetingDesc;

  /// No description provided for @bankingCredit.
  ///
  /// In en, this message translates to:
  /// **'Banking & Credit'**
  String get bankingCredit;

  /// No description provided for @bankingDesc.
  ///
  /// In en, this message translates to:
  /// **'Understanding accounts and credit scores'**
  String get bankingDesc;

  /// No description provided for @investingBasics.
  ///
  /// In en, this message translates to:
  /// **'Investing Basics'**
  String get investingBasics;

  /// No description provided for @investingDesc.
  ///
  /// In en, this message translates to:
  /// **'Grow your wealth for the future'**
  String get investingDesc;

  /// No description provided for @financialSecurity.
  ///
  /// In en, this message translates to:
  /// **'Financial Security'**
  String get financialSecurity;

  /// No description provided for @securityDesc.
  ///
  /// In en, this message translates to:
  /// **'Protect yourself from fraud'**
  String get securityDesc;

  /// No description provided for @entrepreneurship.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurship'**
  String get entrepreneurship;

  /// No description provided for @entrepreneurshipDesc.
  ///
  /// In en, this message translates to:
  /// **'Starting your own business'**
  String get entrepreneurshipDesc;

  /// No description provided for @taxPlanning.
  ///
  /// In en, this message translates to:
  /// **'Tax Planning'**
  String get taxPlanning;

  /// No description provided for @taxDesc.
  ///
  /// In en, this message translates to:
  /// **'Understanding tax obligations'**
  String get taxDesc;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @financialCalculators.
  ///
  /// In en, this message translates to:
  /// **'Financial Calculators'**
  String get financialCalculators;

  /// No description provided for @calculatorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Tools for planning'**
  String get calculatorsDesc;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get videoTutorials;

  /// No description provided for @tutorialsDesc.
  ///
  /// In en, this message translates to:
  /// **'Visual learning guides'**
  String get tutorialsDesc;

  /// No description provided for @articlesGuides.
  ///
  /// In en, this message translates to:
  /// **'Articles & Guides'**
  String get articlesGuides;

  /// No description provided for @articlesDesc.
  ///
  /// In en, this message translates to:
  /// **'In-depth reading materials'**
  String get articlesDesc;

  /// No description provided for @moreContentComingSoon.
  ///
  /// In en, this message translates to:
  /// **'More content coming soon!'**
  String get moreContentComingSoon;

  /// No description provided for @keyLearningPoints.
  ///
  /// In en, this message translates to:
  /// **'Key Learning Points'**
  String get keyLearningPoints;

  /// No description provided for @understandFundamentals.
  ///
  /// In en, this message translates to:
  /// **'Understand the fundamentals'**
  String get understandFundamentals;

  /// No description provided for @learnPracticalApps.
  ///
  /// In en, this message translates to:
  /// **'Learn practical applications'**
  String get learnPracticalApps;

  /// No description provided for @getActionableTips.
  ///
  /// In en, this message translates to:
  /// **'Get actionable tips'**
  String get getActionableTips;

  /// No description provided for @accessRealWorldExamples.
  ///
  /// In en, this message translates to:
  /// **'Access real-world examples'**
  String get accessRealWorldExamples;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @detailedContentComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Detailed content for {title} coming soon!'**
  String detailedContentComingSoon(String title);

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'The feature {title} is coming soon!'**
  String featureComingSoon(String title);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @access.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get access;

  /// No description provided for @codingCategory.
  ///
  /// In en, this message translates to:
  /// **'Coding'**
  String get codingCategory;

  /// No description provided for @marketingCategory.
  ///
  /// In en, this message translates to:
  /// **'Digital Marketing'**
  String get marketingCategory;

  /// No description provided for @wordpressCategory.
  ///
  /// In en, this message translates to:
  /// **'WordPress'**
  String get wordpressCategory;

  /// No description provided for @crochetCategory.
  ///
  /// In en, this message translates to:
  /// **'Crochet'**
  String get crochetCategory;

  /// No description provided for @knittingCategory.
  ///
  /// In en, this message translates to:
  /// **'Knitting'**
  String get knittingCategory;

  /// No description provided for @beginnerLevel.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginnerLevel;

  /// No description provided for @intermediateLevel.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediateLevel;

  /// No description provided for @advancedLevel.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedLevel;

  /// No description provided for @shareLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow trusted contacts to track your real-time location during commutes or when you feel unsafe.'**
  String get shareLocationDesc;

  /// No description provided for @trackingDuration.
  ///
  /// In en, this message translates to:
  /// **'Tracking Duration'**
  String get trackingDuration;

  /// No description provided for @fifteenMin.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get fifteenMin;

  /// No description provided for @thirtyMin.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get thirtyMin;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get oneHour;

  /// No description provided for @untilStop.
  ///
  /// In en, this message translates to:
  /// **'Until I stop'**
  String get untilStop;

  /// No description provided for @liveTrackingActive.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking Active'**
  String get liveTrackingActive;

  /// No description provided for @trackingNotActive.
  ///
  /// In en, this message translates to:
  /// **'Tracking Not Active'**
  String get trackingNotActive;

  /// No description provided for @locationSharedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your location is being shared with trusted contacts'**
  String get locationSharedDesc;

  /// No description provided for @stopTracking.
  ///
  /// In en, this message translates to:
  /// **'Stop Tracking'**
  String get stopTracking;

  /// No description provided for @startLiveTracking.
  ///
  /// In en, this message translates to:
  /// **'Start Live Tracking'**
  String get startLiveTracking;

  /// No description provided for @onlyTrustedContactsView.
  ///
  /// In en, this message translates to:
  /// **'Only your trusted contacts can view your location'**
  String get onlyTrustedContactsView;

  /// No description provided for @addTrustedContactsFirst.
  ///
  /// In en, this message translates to:
  /// **'Please add trusted contacts first'**
  String get addTrustedContactsFirst;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are required for live tracking.'**
  String get locationPermissionRequired;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied. Please enable in settings.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @trackingStarted.
  ///
  /// In en, this message translates to:
  /// **'Live tracking started'**
  String get trackingStarted;

  /// No description provided for @errorStartingTracking.
  ///
  /// In en, this message translates to:
  /// **'Error starting tracking: {error}'**
  String errorStartingTracking(Object error);

  /// No description provided for @trackingStopped.
  ///
  /// In en, this message translates to:
  /// **'Live tracking stopped'**
  String get trackingStopped;

  /// No description provided for @errorStoppingTracking.
  ///
  /// In en, this message translates to:
  /// **'Error stopping tracking: {error}'**
  String errorStoppingTracking(Object error);

  /// No description provided for @discreetSosActivation.
  ///
  /// In en, this message translates to:
  /// **'Discreet SOS Activation'**
  String get discreetSosActivation;

  /// No description provided for @discreetSosDesc.
  ///
  /// In en, this message translates to:
  /// **'Shake your phone to trigger SOS alerts without drawing attention. Perfect for situations where you need help discreetly.'**
  String get discreetSosDesc;

  /// No description provided for @shakeAlertEnabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Enabled - Shake your phone to trigger SOS'**
  String get shakeAlertEnabledMsg;

  /// No description provided for @shakeAlertDisabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Disabled - Turn on to activate'**
  String get shakeAlertDisabledMsg;

  /// No description provided for @sensitivity.
  ///
  /// In en, this message translates to:
  /// **'Sensitivity'**
  String get sensitivity;

  /// No description provided for @adjustSensitivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust how sensitive the shake detection is'**
  String get adjustSensitivityDesc;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @veryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low'**
  String get veryLow;

  /// No description provided for @veryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get veryHigh;

  /// No description provided for @testShakeDetection.
  ///
  /// In en, this message translates to:
  /// **'Test Shake Detection'**
  String get testShakeDetection;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @enableShakeAlert.
  ///
  /// In en, this message translates to:
  /// **'Enable Shake to Alert'**
  String get enableShakeAlert;

  /// No description provided for @shakePhoneHelp.
  ///
  /// In en, this message translates to:
  /// **'Shake your phone when you need help'**
  String get shakePhoneHelp;

  /// No description provided for @sosAlertSentAuto.
  ///
  /// In en, this message translates to:
  /// **'SOS alert will be sent automatically'**
  String get sosAlertSentAuto;

  /// No description provided for @shakeAlertEnabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Shake to Alert enabled'**
  String get shakeAlertEnabledSnack;

  /// No description provided for @shakeAlertDisabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Shake to Alert disabled'**
  String get shakeAlertDisabledSnack;

  /// No description provided for @sosAlertTriggeredByShake.
  ///
  /// In en, this message translates to:
  /// **'SOS Alert triggered by shake detection'**
  String get sosAlertTriggeredByShake;

  /// No description provided for @sosAlertSentTrustedNotified.
  ///
  /// In en, this message translates to:
  /// **'SOS Alert Sent! Trusted contacts have been notified.'**
  String get sosAlertSentTrustedNotified;

  /// No description provided for @errorSendingSosAlert.
  ///
  /// In en, this message translates to:
  /// **'Error sending SOS alert: {error}'**
  String errorSendingSosAlert(Object error);

  /// No description provided for @exitUncomfortableSituations.
  ///
  /// In en, this message translates to:
  /// **'Exit Uncomfortable Situations'**
  String get exitUncomfortableSituations;

  /// No description provided for @selectCaller.
  ///
  /// In en, this message translates to:
  /// **'Select Caller'**
  String get selectCaller;

  /// No description provided for @mom.
  ///
  /// In en, this message translates to:
  /// **'Mom'**
  String get mom;

  /// No description provided for @dad.
  ///
  /// In en, this message translates to:
  /// **'Dad'**
  String get dad;

  /// No description provided for @bestFriend.
  ///
  /// In en, this message translates to:
  /// **'Best Friend'**
  String get bestFriend;

  /// No description provided for @boss.
  ///
  /// In en, this message translates to:
  /// **'Boss'**
  String get boss;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @incomingCall.
  ///
  /// In en, this message translates to:
  /// **'Incoming Call'**
  String get incomingCall;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @readyToGenerateCall.
  ///
  /// In en, this message translates to:
  /// **'Ready to Generate Call'**
  String get readyToGenerateCall;

  /// No description provided for @tapToStartFakeCall.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to start a fake call'**
  String get tapToStartFakeCall;

  /// No description provided for @generateFakeCall.
  ///
  /// In en, this message translates to:
  /// **'Generate Fake Call'**
  String get generateFakeCall;

  /// No description provided for @endCall.
  ///
  /// In en, this message translates to:
  /// **'End Call'**
  String get endCall;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @tipAnswerNaturally.
  ///
  /// In en, this message translates to:
  /// **'Answer the call naturally and excuse yourself'**
  String get tipAnswerNaturally;

  /// No description provided for @tipRealisticScreen.
  ///
  /// In en, this message translates to:
  /// **'The call will look realistic on your screen'**
  String get tipRealisticScreen;

  /// No description provided for @tipEndAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can end the call anytime'**
  String get tipEndAnytime;

  /// No description provided for @trustedContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trusted Contacts'**
  String get trustedContactsTitle;

  /// No description provided for @addTrustedContact.
  ///
  /// In en, this message translates to:
  /// **'Add Trusted Contact'**
  String get addTrustedContact;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter contact name'**
  String get enterContactName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @relation.
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get relation;

  /// No description provided for @familyFriendHint.
  ///
  /// In en, this message translates to:
  /// **'Family, Friend, etc.'**
  String get familyFriendHint;

  /// No description provided for @contactAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Contact added successfully'**
  String get contactAddedSuccess;

  /// No description provided for @deleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete Contact'**
  String get deleteContact;

  /// No description provided for @deleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from your trusted contacts?'**
  String deleteContactConfirm(Object name);

  /// No description provided for @contactRemoved.
  ///
  /// In en, this message translates to:
  /// **'Contact removed'**
  String get contactRemoved;

  /// No description provided for @trustedContactsDesc.
  ///
  /// In en, this message translates to:
  /// **'These contacts will receive your SOS alerts'**
  String get trustedContactsDesc;

  /// No description provided for @noTrustedContacts.
  ///
  /// In en, this message translates to:
  /// **'No trusted contacts yet'**
  String get noTrustedContacts;

  /// No description provided for @addContactsToReceiveSos.
  ///
  /// In en, this message translates to:
  /// **'Add contacts to receive your SOS alerts'**
  String get addContactsToReceiveSos;

  /// No description provided for @contactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactLabel;

  /// No description provided for @sellItem.
  ///
  /// In en, this message translates to:
  /// **'Sell Item'**
  String get sellItem;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products or services...'**
  String get searchProducts;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @handmade.
  ///
  /// In en, this message translates to:
  /// **'Handmade'**
  String get handmade;

  /// No description provided for @clothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get clothing;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @beauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get beauty;

  /// No description provided for @homeDecor.
  ///
  /// In en, this message translates to:
  /// **'Home Decor'**
  String get homeDecor;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @exploreWellness.
  ///
  /// In en, this message translates to:
  /// **'Explore our wellness features designed just for you'**
  String get exploreWellness;

  /// No description provided for @cycleTrackerDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your menstrual cycle, log symptoms, and get personalized insights'**
  String get cycleTrackerDesc;

  /// No description provided for @maternityWingDesc.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy tracking, milestones, and post-partum support for mothers'**
  String get maternityWingDesc;

  /// No description provided for @mentalSanctuaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Meditation, journaling, and mental wellness tools for your peace of mind'**
  String get mentalSanctuaryDesc;

  /// No description provided for @teleHealthDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect with trusted gynecologists and psychologists from home'**
  String get teleHealthDesc;

  /// No description provided for @familyPlanningDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn about contraception methods and make informed decisions'**
  String get familyPlanningDesc;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeGreeting;

  /// No description provided for @familyLaw.
  ///
  /// In en, this message translates to:
  /// **'Family Law'**
  String get familyLaw;

  /// No description provided for @propertyRights.
  ///
  /// In en, this message translates to:
  /// **'Property Rights'**
  String get propertyRights;

  /// No description provided for @inheritance.
  ///
  /// In en, this message translates to:
  /// **'Inheritance'**
  String get inheritance;

  /// No description provided for @laborRights.
  ///
  /// In en, this message translates to:
  /// **'Labor Rights'**
  String get laborRights;

  /// No description provided for @criminalLaw.
  ///
  /// In en, this message translates to:
  /// **'Criminal Law'**
  String get criminalLaw;

  /// No description provided for @cyberSecurity.
  ///
  /// In en, this message translates to:
  /// **'Cyber Security'**
  String get cyberSecurity;

  /// No description provided for @legalRightsWiki.
  ///
  /// In en, this message translates to:
  /// **'Legal Rights Wiki'**
  String get legalRightsWiki;

  /// No description provided for @knowYourRights.
  ///
  /// In en, this message translates to:
  /// **'Know Your Rights'**
  String get knowYourRights;

  /// No description provided for @legalHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive guides to protect and empower yourself'**
  String get legalHeroDesc;

  /// No description provided for @articlesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} articles'**
  String articlesCount(int count);

  /// No description provided for @sosAlertMessageContent.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS Alert - User needs immediate assistance'**
  String get sosAlertMessageContent;

  /// No description provided for @sosTriggeredByShake.
  ///
  /// In en, this message translates to:
  /// **'SOS Triggered by Shake'**
  String get sosTriggeredByShake;

  /// No description provided for @sosAlertSentShort.
  ///
  /// In en, this message translates to:
  /// **'SOS Alert Sent'**
  String get sosAlertSentShort;

  /// No description provided for @newListing.
  ///
  /// In en, this message translates to:
  /// **'New Listing'**
  String get newListing;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @imagesMax5.
  ///
  /// In en, this message translates to:
  /// **'Images (Max 5)'**
  String get imagesMax5;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @enterTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product/service title'**
  String get enterTitleHint;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @describeProductHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your product or service...'**
  String get describeProductHint;

  /// No description provided for @listingCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing created successfully!'**
  String get listingCreatedSuccess;

  /// No description provided for @publishListing.
  ///
  /// In en, this message translates to:
  /// **'Publish Listing'**
  String get publishListing;

  /// No description provided for @maxImagesAllowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 images allowed'**
  String get maxImagesAllowed;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(Object error);

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @voiceAssistant.
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant'**
  String get voiceAssistant;

  /// No description provided for @transcribed.
  ///
  /// In en, this message translates to:
  /// **'Transcribed:'**
  String get transcribed;

  /// No description provided for @legalAssistantResponse.
  ///
  /// In en, this message translates to:
  /// **'Legal Assistant Response'**
  String get legalAssistantResponse;

  /// No description provided for @gettingLegalAdvice.
  ///
  /// In en, this message translates to:
  /// **'Getting legal advice...'**
  String get gettingLegalAdvice;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required'**
  String get microphonePermissionRequired;

  /// No description provided for @speechRecognitionError.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition error: {error}'**
  String speechRecognitionError(Object error);

  /// No description provided for @speechNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device'**
  String get speechNotAvailable;

  /// No description provided for @checkPermissions.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition not available. Please check permissions.'**
  String get checkPermissions;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bal',
    'en',
    'pa',
    'sd',
    'tr',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bal':
      return AppLocalizationsBal();
    case 'en':
      return AppLocalizationsEn();
    case 'pa':
      return AppLocalizationsPa();
    case 'sd':
      return AppLocalizationsSd();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
