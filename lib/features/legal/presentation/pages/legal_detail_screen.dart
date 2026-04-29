// lib/modules/legal/screens/legal_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../contents/colors.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets_shared/side_drawer.dart';

class LegalDetailScreen extends StatefulWidget {
  final String categoryTitle;

  const LegalDetailScreen({super.key, required this.categoryTitle});

  @override
  State<LegalDetailScreen> createState() => _LegalDetailScreenState();
}

class _LegalDetailScreenState extends State<LegalDetailScreen>
    with TickerProviderStateMixin {
  String _selectedLanguage = 'English';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  FlutterTts? _flutterTts;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    
    // Set completion handler
    _flutterTts!.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
    
    // Set error handler
    _flutterTts!.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('TTS Error: $msg'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    });

    // Check availability and set initial language
    await _setTtsLanguage();
    
    // Set parameters
    await _flutterTts!.setSpeechRate(0.4); // Slower for better clarity
    await _flutterTts!.setPitch(1.0);
    await _flutterTts!.setVolume(1.0);
  }

  Future<void> _setTtsLanguage() async {
    if (_flutterTts == null) return;
    
    try {
      final languages = await _flutterTts!.getLanguages;
      debugPrint('System TTS languages: $languages');
      
      String targetCode;
      List<String> fallbacks;

      switch (_selectedLanguage) {
        case 'Urdu':
          targetCode = 'ur-PK';
          fallbacks = ['ur', 'ur_PK', 'ur_IN', 'hi-IN', 'hi_IN', 'hi'];
          break;
        case 'Pakistani Punjabi':
          targetCode = 'pa-PK';
          fallbacks = ['pa-PK', 'pa_PK', 'pa-IN', 'pa_IN', 'pa', 'ur-PK', 'ur'];
          break;
        case 'English':
        default:
          targetCode = 'en-US';
          fallbacks = ['en-US', 'en_US', 'en-GB', 'en_GB', 'en'];
      }

      // Check if target is available
      bool isTargetSupported = await _flutterTts!.isLanguageAvailable(targetCode);
      
      if (isTargetSupported) {
        await _flutterTts!.setLanguage(targetCode);
        debugPrint('TTS direct set: $targetCode');
      } else {
        bool foundFallback = false;
        for (String code in fallbacks) {
          if (await _flutterTts!.isLanguageAvailable(code)) {
            await _flutterTts!.setLanguage(code);
            foundFallback = true;
            debugPrint('TTS fallback set: $code for $_selectedLanguage');
            break;
          }
        }
        
        if (!foundFallback) {
          await _flutterTts!.setLanguage('en-US');
          debugPrint('TTS total fallback to en-US');
        }
      }
    } catch (e) {
      debugPrint('Error setting TTS language: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_flutterTts == null) return;

    if (_isPlaying) {
      await _stopTts();
    } else {
      // Ensure language is set before speaking
      await _setTtsLanguage();
      
      final articleData = _getArticleData(widget.categoryTitle, _selectedLanguage);
      final fullText = _getFullArticleText(articleData);
      
      if (fullText.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No content available to read'),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        return;
      }
      
      try {
        await _flutterTts!.speak(fullText);
        setState(() {
          _isPlaying = true;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error reading text: $e'),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _stopTts() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  String _getFullArticleText(Map<String, dynamic> articleData) {
    final title = articleData['title'] as String;
    final sections = articleData['sections'] as List;
    
    StringBuffer fullText = StringBuffer();
    fullText.writeln(title);
    fullText.writeln();
    
    for (var section in sections) {
      fullText.writeln(section['heading'] as String);
      fullText.writeln();
      fullText.writeln(section['content'] as String);
      fullText.writeln();
    }
    
    return fullText.toString();
  }

  @override
  void dispose() {
    _stopTts();
    _flutterTts = null;
    _fadeController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getArticleData(String category, String language) {
    final articles = _getAllArticles();
    final categoryData = articles[category] ?? articles['Family Law']!;
    
    if (language == 'English') {
      return categoryData['english'] as Map<String, dynamic>;
    } else if (language == 'Urdu') {
      return categoryData['urdu'] as Map<String, dynamic>;
    } else {
      return categoryData['pakistani_punjabi'] as Map<String, dynamic>;
    }
  }

  Map<String, Map<String, dynamic>> _getAllArticles() {
    return {
      'Family Law': {
        'icon': Icons.family_restroom_rounded,
        'color': AppColors.accentPurple,
        'english': {
          'title': 'Understanding Your Rights in Family Matters',
          'sections': [
            {
              'heading': 'Marriage Rights',
              'content':
                  'Every woman has the right to enter into marriage with free and full consent. The legal age for marriage is 18 years. You have the right to choose your spouse and cannot be forced into marriage against your will. Forced marriages are illegal and can be challenged in court. You also have the right to negotiate your marriage contract (nikahnama) and include conditions that protect your rights, such as the right to work, education, and divorce.',
            },
            {
              'heading': 'Divorce Rights',
              'content':
                  'Women have the right to seek divorce through Khula (judicial divorce) or Talaq-e-Tafweez (delegated right). The process involves filing a petition in family court with valid reasons. You are entitled to maintenance (nafaqa) during the iddat period. Additionally, you have the right to receive your dower (mahr) as specified in your marriage contract. The court can also order interim maintenance during the divorce proceedings. If you face domestic violence, you can seek immediate protection orders.',
            },
            {
              'heading': 'Custody Rights',
              'content':
                  'Under Islamic law, mothers typically have custody of children until they reach the age of 7 for boys and puberty for girls. However, the court considers the best interests of the child in all custody decisions.',
            },
            {
              'heading': 'Maintenance Rights',
              'content':
                  'You have the right to maintenance from your husband during marriage and after divorce during the iddat period. This includes food, clothing, housing, and medical expenses. The amount is determined based on the husband\'s financial capacity.',
            },
          ],
        },
        'urdu': {
          'title': 'خاندانی معاملات میں آپ کے حقوق',
          'sections': [
            {
              'heading': 'شادی کے حقوق',
              'content':
                  'ہر عورت کو آزادانہ اور مکمل رضامندی کے ساتھ شادی کرنے کا حق ہے۔ شادی کی قانونی عمر 18 سال ہے۔ آپ کو اپنا جیون ساتھی منتخب کرنے کا حق ہے اور آپ کو زبردستی شادی پر مجبور نہیں کیا جا سکتا۔',
            },
            {
              'heading': 'طلاق کے حقوق',
              'content':
                  'خواتین کو خلع (عدالتی طلاق) یا طلاق تفویض (تفویض شدہ حق) کے ذریعے طلاق حاصل کرنے کا حق ہے۔ اس عمل میں خاندانی عدالت میں درست وجوہات کے ساتھ درخواست دائر کرنا شامل ہے۔ آپ عدت کی مدت کے دوران نفقہ (نانا) کی حقدار ہیں۔',
            },
            {
              'heading': 'تحفظ کے حقوق',
              'content':
                  'اسلامی قانون کے تحت، مائیں عام طور پر بچوں کی تحفظ رکھتی ہیں جب تک کہ لڑکوں کی عمر 7 سال اور لڑکیوں کی بلوغت نہ ہو جائے۔ تاہم، عدالت تمام تحفظ کے فیصلوں میں بچے کی بہترین دلچسپی پر غور کرتی ہے۔',
            },
            {
              'heading': 'نانا کے حقوق',
              'content':
                  'آپ کو شادی کے دوران اور طلاق کے بعد عدت کی مدت کے دوران اپنے شوہر سے نانا کا حق ہے۔ اس میں کھانا، کپڑے، رہائش، اور طبی اخراجات شامل ہیں۔ رقم شوہر کی مالی صلاحیت کی بنیاد پر طے کی جاتی ہے۔',
            },
          ],
        },
        'pakistani_punjabi': {
          'title': 'خاندانی معاملات وچ تہاڈے حقوق',
          'sections': [
            {
              'heading': 'شادی دے حقوق',
              'content':
                  'ہر عورت نوں آزادانہ تے مکمل رضامندی نال شادی کرن دا حق اے۔ شادی دی قانونی عمر 18 سال اے۔ تہانوں اپنا جیون ساتھی چنن دا حق اے تے تہانوں زبردستی شادی لئی مجبور نئیں کیتا جا سکدا۔ تہانوں اپنے شوہر دی مرضی دے بغیر وی شادی کرن دا حق اے۔',
            },
            {
              'heading': 'طلاق دے حقوق',
              'content':
                  'عورتاں نوں خلع (عدالتی طلاق) یا طلاق تفویض (تفویض شدہ حق) دے ذریعے طلاق لین دا حق اے۔ اس عمل وچ خاندانی عدالت وچ درست وجوہات نال درخواست دائر کرنا شامل اے۔ تسیں عدت دی مدت دوران نفقہ (نانا) دی حقدار ہو۔ طلاق دے بعد تہانوں اپنے بچےآں دی دیکھ بھال دا حق وی اے۔',
            },
            {
              'heading': 'تحفظ دے حقوق',
              'content':
                  'اسلامی قانون دے تحت، مائاں عام طور تے بچےآں دی تحفظ رکھدیاں نیں جدوں تک لڑکےآں دی عمر 7 سال تے لڑکیاں دی بلوغت نئیں ہو جاندی۔ پر، عدالت تمام تحفظ دے فیصلےآں وچ بچے دی بہترین دلچسپی نوں دھیان وچ رکھدی اے۔ ماء نوں بچےآں دی پرورش تے تعلیم دا حق اے۔',
            },
            {
              'heading': 'نانا دے حقوق',
              'content':
                  'تہانوں شادی دوران تے طلاق توں بعد عدت دی مدت دوران اپنے شوہر توں نانا دا حق اے۔ اس وچ کھانا، کپڑے، رہائش، تے طبی اخراجات شامل نیں۔ رقم شوہر دی مالی صلاحیت دے بنیاد تے طے کیتی جاندی اے۔ شوہر نوں اپنی بیوی دی ضروریات پوری کرنا لازمی اے۔',
            },
          ],
        },
      },
      'Property Rights': {
        'icon': Icons.home_work_rounded,
        'color': AppColors.accentPink,
        'english': {
          'title': 'Property and Land Ownership Rights',
          'sections': [
            {
              'heading': 'Inheritance Rights',
              'content':
                  'Under Islamic law, women are entitled to inherit property. A daughter receives half the share of a son, but this is still a guaranteed right. You cannot be denied your inheritance share.',
            },
            {
              'heading': 'Property Registration',
              'content':
                  'All property transactions must be registered in your name if you are the owner. Ensure all documents are properly attested and registered with the relevant land revenue department.',
            },
            {
              'heading': 'Joint Property Rights',
              'content':
                  'In case of joint property, you have equal rights to use and enjoy the property. You cannot be evicted without due legal process, even if you are not the primary owner.',
            },
          ],
        },
        'urdu': {
          'title': 'جائیداد اور زمین کی ملکیت کے حقوق',
          'sections': [
            {
              'heading': 'وراثت کے حقوق',
              'content':
                  'اسلامی قانون کے تحت، خواتین جائیداد وراثت میں لینے کی حقدار ہیں۔ بیٹی بیٹے کے حصے کا آدھا حصہ حاصل کرتی ہے، لیکن یہ اب بھی ایک ضمانت شدہ حق ہے۔ آپ کو آپ کے وراثت کے حصے سے انکار نہیں کیا جا سکتا۔',
            },
            {
              'heading': 'جائیداد کی رجسٹریشن',
              'content':
                  'اگر آپ مالک ہیں تو تمام جائیداد کے لین دین کو آپ کے نام پر رجسٹر کیا جانا چاہیے۔ یقینی بنائیں کہ تمام دستاویزات مناسب طریقے سے تصدیق شدہ ہیں اور متعلقہ زمینی محصولات محکمہ میں رجسٹرڈ ہیں۔',
            },
            {
              'heading': 'مشترکہ جائیداد کے حقوق',
              'content':
                  'مشترکہ جائیداد کی صورت میں، آپ کو جائیداد استعمال کرنے اور لطف اندوز ہونے کے برابر حقوق حاصل ہیں۔ آپ کو مناسب قانونی عمل کے بغیر بے دخل نہیں کیا جا سکتا، چاہے آپ بنیادی مالک نہ بھی ہوں۔',
            },
          ],
        },
        'pakistani_punjabi': {
          'title': 'جائیداد تے زمین دی ملکیت دے حقوق',
          'sections': [
            {
              'heading': 'وراثت دے حقوق',
              'content':
                  'اسلامی قانون دے تحت، عورتاں جائیداد وراثت وچ لین دی حقدار نیں۔ دھی پتر دے حصے دا ادھا حصہ حاصل کردی اے، پر ایہ ہن وی اک گارنٹیڈ حق اے۔ تہانوں تہاڈے وراثت دے حصے توں انکار نئیں کیتا جا سکدا۔ تہانوں اپنے وراثت دے حق توں محروم نئیں کیتا جا سکدا۔',
            },
            {
              'heading': 'جائیداد دی رجسٹریشن',
              'content':
                  'ساریاں جائیداد لین دین نوں تہاڈے ناں تے رجسٹر کیتا جانا چاہیدا اے جے تساں مالک ہو۔ یقینی بناؤ کہ سارے دستاویزات ٹھیک طریقے نال تصدیق شدہ نیں تے متعلقہ زمینی محصولات محکمہ وچ رجسٹرڈ نیں۔ رجسٹریشن دے بغیر کوئی لین دین قانونی طور تے درست نئیں۔',
            },
            {
              'heading': 'سانجھی جائیداد دے حقوق',
              'content':
                  'سانجھی جائیداد دے معاملے وچ، تہانوں جائیداد استعمال کرن تے لطف اندوز ہون دے برابر حقوق نیں۔ تہانوں مناسب قانونی عمل دے بغیر بے دخل نئیں کیتا جا سکدا، چاہے تساں بنیادی مالک نہ وی ہو۔ تہانوں جائیداد وچ اپنا حصہ استعمال کرن دا حق اے۔',
            },
          ],
        },
      },
      'Inheritance': {
        'icon': Icons.account_balance_rounded,
        'color': AppColors.mediumPurple,
        'english': {
          'title': 'Understanding Inheritance Laws',
          'sections': [
            {
              'heading': 'Legal Heirs',
              'content':
                  'Under Islamic law, certain relatives are entitled to fixed shares (Quranic heirs) while others receive residual shares. Daughters, wives, mothers, and sisters all have specific inheritance rights.',
            },
            {
              'heading': 'Your Share',
              'content':
                  'As a daughter, you receive half the share of a son. As a wife, you receive 1/8 if there are children, or 1/4 if there are no children. These shares are mandatory and cannot be denied.',
            },
            {
              'heading': 'Will and Testament',
              'content':
                  'You have the right to make a will for up to 1/3 of your property. The remaining 2/3 must be distributed according to Islamic inheritance laws. A will must be properly witnessed and registered.',
            },
          ],
        },
        'urdu': {
          'title': 'وراثت کے قوانین کو سمجھنا',
          'sections': [
            {
              'heading': 'قانونی وارث',
              'content':
                  'اسلامی قانون کے تحت، کچھ رشتہ داروں کو مقررہ حصے (قرآنی وارث) کا حق حاصل ہے جبکہ دوسرے باقی حصے حاصل کرتے ہیں۔ بیٹیاں، بیویاں، مائیں، اور بہنیں سب کے وراثت کے مخصوص حقوق ہیں۔',
            },
            {
              'heading': 'آپ کا حصہ',
              'content':
                  'بیٹی کے طور پر، آپ بیٹے کے حصے کا آدھا حصہ حاصل کرتی ہیں۔ بیوی کے طور پر، اگر بچے ہیں تو آپ 1/8 حصہ حاصل کرتی ہیں، یا اگر بچے نہیں ہیں تو 1/4۔ یہ حصے لازمی ہیں اور انکار نہیں کیا جا سکتا۔',
            },
            {
              'heading': 'وصیت نامہ',
              'content':
                  'آپ کو اپنی جائیداد کے 1/3 تک وصیت کرنے کا حق ہے۔ باقی 2/3 کو اسلامی وراثت کے قوانین کے مطابق تقسیم کیا جانا چاہیے۔ وصیت نامہ کو مناسب طریقے سے گواہ بنایا اور رجسٹر کیا جانا چاہیے۔',
            },
          ],
        },
        'pakistani_punjabi': {
          'title': 'وراثت دے قوانین نوں سمجھنا',
          'sections': [
            {
              'heading': 'قانونی وارث',
              'content':
                  'اسلامی قانون دے تحت، کجھ رشتہ داراں نوں مقررہ حصے (قرآنی وارث) دا حق اے جدوں کہ دوجے باقی حصے حاصل کردے نیں۔ دھیاں، پتنیاں، مائاں، تے بھیناں ساریاں دے وراثت دے خاص حقوق نیں۔ ہر رشتہ دار دا وراثت وچ مخصوص حصہ مقرر اے۔',
            },
            {
              'heading': 'تہاڈا حصہ',
              'content':
                  'دھی وجوں، تساں پتر دے حصے دا ادھا حصہ حاصل کردے او۔ پتنی وجوں، جے بچے نیں تاں تساں 1/8 حصہ حاصل کردے او، یا جے بچے نئیں نیں تاں 1/4۔ ایہ حصے لازمی نیں تے انکار نئیں کیتا جا سکدا۔ تہانوں اپنے حصے توں محروم نئیں کیتا جا سکدا۔',
            },
            {
              'heading': 'وصیت نامہ',
              'content':
                  'تہانوں اپنی جائیداد دے 1/3 تک وصیت کرن دا حق اے۔ باقی 2/3 نوں اسلامی وراثت دے قوانین دے مطابق تقسیم کیتا جانا چاہیدا اے۔ وصیت نامہ نوں مناسب طریقے نال گواہ بنایا تے رجسٹر کیتا جانا چاہیدا اے۔ وصیت وچ تبدیلی وی ممکن اے۔',
            },
          ],
        },
      },
      'Labor Rights': {
        'icon': Icons.work_rounded,
        'color': AppColors.lightPink,
        'english': {
          'title': 'Workplace Rights and Protections',
          'sections': [
            {
              'heading': 'Equal Pay',
              'content':
                  'You have the right to equal pay for equal work. Gender-based pay discrimination is illegal. If you perform the same job as a male colleague, you must receive the same compensation.',
            },
            {
              'heading': 'Maternity Leave',
              'content':
                  'Female employees are entitled to paid maternity leave. The duration varies by organization but typically ranges from 90 to 120 days. You cannot be terminated during maternity leave.',
            },
            {
              'heading': 'Workplace Harassment',
              'content':
                  'You have the right to a safe workplace free from harassment. Sexual harassment is a criminal offense. Report any incidents to your HR department or the relevant authorities immediately.',
            },
            {
              'heading': 'Working Hours',
              'content':
                  'Standard working hours are 8 hours per day or 48 hours per week. Overtime must be compensated. You have the right to breaks and cannot be forced to work excessive hours.',
            },
          ],
        },
        'urdu': {
          'title': 'کام کی جگہ کے حقوق اور تحفظ',
          'sections': [
            {
              'heading': 'مساوی تنخواہ',
              'content':
                  'آپ کو برابر کام کے لیے برابر تنخواہ کا حق ہے۔ جنس کی بنیاد پر تنخواہ کی امتیازی سلوک غیر قانونی ہے۔ اگر آپ ایک مرد ساتھی کی طرح کام کرتی ہیں، تو آپ کو ایک جیسی معاوضہ ملنا چاہیے۔',
            },
            {
              'heading': 'زچگی کی چھٹی',
              'content':
                  'خواتین ملازمین کو تنخواہ کے ساتھ زچگی کی چھٹی کا حق ہے۔ مدت تنظیم کے لحاظ سے مختلف ہوتی ہے لیکن عام طور پر 90 سے 120 دن تک ہوتی ہے۔ آپ کو زچگی کی چھٹی کے دوران برطرف نہیں کیا جا سکتا۔',
            },
            {
              'heading': 'کام کی جگہ پر ہراساں کرنا',
              'content':
                  'آپ کو ہراساں کرنے سے پاک محفوظ کام کی جگہ کا حق ہے۔ جنسی ہراساں کرنا ایک مجرمانہ جرم ہے۔ کسی بھی واقعے کی فوری طور پر اپنے HR محکمہ یا متعلقہ حکام کو رپورٹ کریں۔',
            },
            {
              'heading': 'کام کے اوقات',
              'content':
                  'معیاری کام کے اوقات دن میں 8 گھنٹے یا ہفتے میں 48 گھنٹے ہیں۔ اضافی وقت کی معاوضہ دی جانی چاہیے۔ آپ کو بریک کا حق ہے اور آپ کو ضرورت سے زیادہ گھنٹے کام کرنے پر مجبور نہیں کیا جا سکتا۔',
            },
          ],
        },
        'pakistani_punjabi': {
          'title': 'کم دی جگہ دے حقوق تے حفاظت',
          'sections': [
            {
              'heading': 'برابر تنخواہ',
              'content':
                  'تہانوں برابر کم لئی برابر تنخواہ دا حق اے۔ جنس دی بنیاد تے تنخواہ دا امتیازی سلوک غیر قانونی اے۔ جے تساں اک مرد ساتھی وانگ کم کردے او، تاں تساں نوں اکو جیہا معاوضہ ملنا چاہیدا اے۔ امتیازی سلوک دے خلاف شکایت درج کرا سکدے او۔',
            },
            {
              'heading': 'زچگی دی چھٹی',
              'content':
                  'عورت ملازمین نوں تنخواہ نال زچگی دی چھٹی دا حق اے۔ مدت تنظیم دے لحاظ نال مختلف ہوندی اے پر عام طور تے 90 توں 120 دن تک ہوندی اے۔ تساں نوں زچگی دی چھٹی دوران برطرف نئیں کیتا جا سکدا۔ چھٹی دوران تنخواہ جاری رہندی اے۔',
            },
            {
              'heading': 'کم دی جگہ تے ہراساں کرنا',
              'content':
                  'تہانوں ہراساں کرن توں پاک محفوظ کم دی جگہ دا حق اے۔ جنسی ہراساں کرنا اک مجرمانہ جرم اے۔ کسے وی واقعے دی فوری طور تے اپنے HR محکمہ یا متعلقہ حکام نوں رپورٹ کرو۔ ثبوت محفوظ رکھو تے فوری کارروائی کرواؤ۔',
            },
            {
              'heading': 'کم دے اوقات',
              'content':
                  'معیاری کم دے اوقات دن وچ 8 گھنٹے یا ہفتے وچ 48 گھنٹے نیں۔ اضافی وقت دا معاوضہ دتا جانا چاہیدا اے۔ تہانوں بریک دا حق اے تے تہانوں ضرورت توں زیادہ گھنٹے کم کرن لئی مجبور نئیں کیتا جا سکدا۔ آرام دے وقفے لازمی نیں۔',
            },
          ],
        },
      },
      'Criminal Law': {
        'icon': Icons.gavel_rounded,
        'color': AppColors.primaryDark,
        'english': {
          'title': 'Your Rights in Criminal Cases',
          'sections': [
            {
              'heading': 'Right to Legal Representation',
              'content':
                  'You have the right to legal counsel at all stages of criminal proceedings. If you cannot afford a lawyer, you may be entitled to free legal aid through various government programs.',
            },
            {
              'heading': 'Protection from Violence',
              'content':
                  'Domestic violence, assault, and harassment are criminal offenses. You can file a complaint with the police, who are legally obligated to register your complaint and investigate.',
            },
            {
              'heading': 'Witness Protection',
              'content':
                  'If you are a witness in a criminal case, you have the right to protection. The court can order protection measures to ensure your safety during and after the trial.',
            },
          ],
        },
        'urdu': {
          'title': 'فوجداری مقدمات میں آپ کے حقوق',
          'sections': [
            {
              'heading': 'قانونی نمائندگی کا حق',
              'content':
                  'آپ کو فوجداری کارروائیوں کے تمام مراحل میں قانونی مشورے کا حق ہے۔ اگر آپ وکیل کا خرچ برداشت نہیں کر سکتے، تو آپ مختلف سرکاری پروگراموں کے ذریعے مفت قانونی امداد کی حقدار ہو سکتی ہیں۔',
            },
            {
              'heading': 'تشدد سے تحفظ',
              'content':
                  'گھریلو تشدد، حملہ، اور ہراساں کرنا مجرمانہ جرائم ہیں۔ آپ پولیس میں شکایت درج کرا سکتی ہیں، جو قانونی طور پر آپ کی شکایت درج کرنے اور تفتیش کرنے کے پابند ہیں۔',
            },
            {
              'heading': 'گواہ کا تحفظ',
              'content':
                  'اگر آپ ایک فوجداری مقدمے میں گواہ ہیں، تو آپ کو تحفظ کا حق ہے۔ عدالت مقدمے کے دوران اور بعد میں آپ کی حفاظت کو یقینی بنانے کے لیے تحفظ کے اقدامات کا حکم دے سکتی ہے۔',
            },
          ],
        },
        'pakistani_punjabi': {
          'title': 'فوجداری معاملات وچ تہاڈے حقوق',
          'sections': [
            {
              'heading': 'قانونی نمائندگی دا حق',
              'content':
                  'تہانوں فوجداری کارروائیاں دے سارے مراحل وچ قانونی مشورے دا حق اے۔ جے تساں وکیل دا خرچ برداشت نئیں کر سکدے، تاں تساں مختلف سرکاری پروگراماں دے ذریعے مفت قانونی امداد دی حقدار ہو سکدے او۔ مفت قانونی امداد دے لئی درخواست دتی جا سکدی اے۔',
            },
            {
              'heading': 'تشدد توں حفاظت',
              'content':
                  'گھریلو تشدد، حملہ، تے ہراساں کرنا مجرمانہ جرائم نیں۔ تساں پولیس وچ شکایت درج کرا سکدے او، جو قانونی طور تے تہاڈی شکایت درج کرن تے تفتیش کرن دے پابند نیں۔ فوری کارروائی کرواؤ تے تحفظ حاصل کرو۔',
            },
            {
              'heading': 'گواہ دی حفاظت',
              'content':
                  'جے تساں اک فوجداری معاملے وچ گواہ او، تاں تہانوں حفاظت دا حق اے۔ عدالت مقدمے دوران تے بعد وچ تہاڈی حفاظت نوں یقینی بنان لئی حفاظت دے اقدامات دا حکم دے سکدی اے۔ گواہی دینا تہاڈا فرض اے پر حفاظت تہاڈا حق اے۔',
            },
          ],
        },
      },
      'Cyber Security': {
        'icon': Icons.security_rounded,
        'color': AppColors.lighterPink,
        'english': {
          'title': 'Digital Rights and Online Safety',
          'sections': [
            {
              'heading': 'Privacy Rights',
              'content':
                  'You have the right to privacy online. Unauthorized access to your personal data, emails, or social media accounts is illegal. Report any privacy violations to the relevant cybercrime authorities.',
            },
            {
              'heading': 'Cyber Harassment',
              'content':
                  'Online harassment, cyberbullying, and revenge porn are criminal offenses. Save all evidence (screenshots, messages) and report to the Federal Investigation Agency (FIA) Cyber Crime Wing.',
            },
            {
              'heading': 'Data Protection',
              'content':
                  'Organizations must protect your personal data. If your data is breached or misused, you can file a complaint. Keep records of all data sharing agreements and privacy policies.',
            },
          ],
        },
        'urdu': {
          'title': 'ڈیجیٹل حقوق اور آن لائن حفاظت',
          'sections': [
            {
              'heading': 'رازداری کے حقوق',
              'content':
                  'آپ کو آن لائن رازداری کا حق ہے۔ آپ کے ذاتی ڈیٹا، ای میلز، یا سوشل میڈیا اکاؤنٹس تک غیر مجاز رسائی غیر قانونی ہے۔ کسی بھی رازداری کی خلاف ورزی کی متعلقہ سائبر کرائم حکام کو رپورٹ کریں۔',
            },
            {
              'heading': 'سائبر ہراساں کرنا',
              'content':
                  'آن لائن ہراساں کرنا، سائبر بلنگ، اور بدلہ پورنوگرافی مجرمانہ جرائم ہیں۔ تمام ثبوت (اسکرین شاٹس، پیغامات) محفوظ کریں اور فیڈرل انویسٹی گیشن ایجنسی (FIA) سائبر کرائم ونگ کو رپورٹ کریں۔',
            },
            {
              'heading': 'ڈیٹا کا تحفظ',
              'content':
                  'تنظیموں کو آپ کے ذاتی ڈیٹا کی حفاظت کرنی چاہیے۔ اگر آپ کا ڈیٹا خلاف ورزی یا غلط استعمال کیا جاتا ہے، تو آپ شکایت درج کرا سکتی ہیں۔ تمام ڈیٹا شیئرنگ معاہدوں اور رازداری کی پالیسیوں کا ریکارڈ رکھیں۔',
            },
          ],
        },
        'pakistani_punjabi': {
          'title': 'ڈیجیٹل حقوق تے آن لائن حفاظت',
          'sections': [
            {
              'heading': 'رازداری دے حقوق',
              'content':
                  'تہانوں آن لائن رازداری دا حق اے۔ تہاڈے ذاتی ڈیٹا، ای میلز، یا سوشل میڈیا اکاؤنٹس تک غیر مجاز رسائی غیر قانونی اے۔ کسے وی رازداری دی خلاف ورزی دی متعلقہ سائبر کرائم حکام نوں رپورٹ کرو۔ اپنے اکاؤنٹس محفوظ رکھو۔',
            },
            {
              'heading': 'سائبر ہراساں کرنا',
              'content':
                  'آن لائن ہراساں کرنا، سائبر بلنگ، تے بدلہ پورنوگرافی مجرمانہ جرائم نیں۔ سارے ثبوت (اسکرین شاٹس، پیغامات) محفوظ کرو تے فیڈرل انویسٹی گیشن ایجنسی (FIA) سائبر کرائم ونگ نوں رپورٹ کرو۔ فوری کارروائی کرواؤ۔',
            },
            {
              'heading': 'ڈیٹا دی حفاظت',
              'content':
                  'تنظیماں نوں تہاڈے ذاتی ڈیٹا دی حفاظت کرنی چاہیدی اے۔ جے تہاڈا ڈیٹا خلاف ورزی یا غلط استعمال کیتا جاندا اے، تاں تساں شکایت درج کرا سکدے او۔ سارے ڈیٹا شیئرنگ معاہدےآں تے رازداری دی پالیسیاں دا ریکارڈ رکھو۔',
            },
          ],
        },
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = _getAllArticles()[widget.categoryTitle] ??
        _getAllArticles()['Family Law']!;
    final articleData = _getArticleData(widget.categoryTitle, _selectedLanguage);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideDrawer(currentModule: 'legal'),
      appBar: CustomAppBar(
        title: widget.categoryTitle,
        showLogo: true,
        showBackButton: true,
        backgroundColor: null, // Use default lighter gradient for consistency
      ),
      body: CustomScrollView(
        slivers: [

          // Language Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive(24),
                vertical: context.responsive(16),
              ),
              child: Container(
                padding: EdgeInsets.all(context.responsive(4)),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(context.responsive(16)),
                  border: Border.all(
                    color: AppColors.accentPurple.withValues(alpha: 0.2),
                    width: context.responsive(1.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentPurple.withValues(alpha: 0.1),
                      blurRadius: context.responsive(10),
                      offset: Offset(0, context.responsive(2)),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['English', 'Urdu', 'Pakistani Punjabi'].map((lang) {
                    final isSelected = _selectedLanguage == lang;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await _stopTts();
                          
                          setState(() {
                            _selectedLanguage = lang;
                            _fadeController.reset();
                            _fadeController.forward();
                          });
                          
                          // Update TTS language
                          await _setTtsLanguage();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: context.responsive(10),
                            horizontal: context.responsive(4),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentPurple
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(context.responsive(12)),
                          ),
                          child: Text(
                            lang,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall1(context).copyWith(
                              fontSize: lang.length > 10
                                  ? context.responsive(10)
                                  : context.responsive(11),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryDark.withValues(alpha: 0.7),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Audio Help Text
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive(24),
                vertical: context.responsive(8),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsive(12),
                  vertical: context.responsive(8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.responsive(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.volume_up_rounded,
                      size: context.responsive(16),
                      color: AppColors.accentPurple,
                    ),
                    SizedBox(width: context.responsive(8)),
                    Flexible(
                      child: Text(
                        _selectedLanguage == 'English'
                            ? 'Tap the speaker icon to listen to this article'
                            : _selectedLanguage == 'Urdu'
                                ? 'اس مضمون کو سننے کے لیے سپیکر آئیکن پر کلک کریں'
                                : 'ایسے مضمون نوں سنن لئی سپیکر آئیکن تے کلک کرو',
                        style: AppTextStyles.caption1(context).copyWith(
                          fontSize: context.responsive(11),
                          color: AppColors.accentPurple,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.all(context.responsive(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with Audio Play Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            articleData['title'] as String,
                            style: _selectedLanguage == 'English'
                                ? AppTextStyles.heading1(context).copyWith(
                                    fontSize: context.responsive(28),
                                    fontWeight: FontWeight.w900,
                                    height: 1.2,
                                  )
                                : AppTextStyles.urduHeading1(context).copyWith(
                                    fontSize: context.responsive(28),
                                    fontWeight: FontWeight.w900,
                                    height: 1.5,
                                  ),
                          ),
                        ),
                        SizedBox(width: context.responsive(12)),
                        // Audio Control Button
                        Container(
                          decoration: BoxDecoration(
                            color: _isPlaying
                                ? AppColors.accentPink
                                : AppColors.accentPurple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isPlaying
                                  ? AppColors.accentPink
                                  : AppColors.accentPurple,
                              width: context.responsive(2),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isPlaying
                                  ? Icons.stop_rounded
                                  : Icons.volume_up_rounded,
                              color: _isPlaying
                                  ? AppColors.white
                                  : AppColors.accentPurple,
                              size: context.responsive(24),
                            ),
                            onPressed: _togglePlayPause,
                            tooltip: _isPlaying
                                ? (_selectedLanguage == 'English'
                                    ? 'Stop'
                                    : _selectedLanguage == 'Urdu'
                                        ? 'روکیں'
                                        : 'روکو')
                                : (_selectedLanguage == 'English'
                                    ? 'Listen to Article'
                                    : _selectedLanguage == 'Urdu'
                                        ? 'مضمون سنیں'
                                        : 'مضمون سُنو'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.responsive(24)),

                    // Article Sections with staggered animations
                    ...((articleData['sections'] as List).asMap().entries.map((entry) {
                      final index = entry.key;
                      final section = entry.value;
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        curve: Curves.easeOut,
                        builder: (BuildContext context, double value, Widget? child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _buildSection(
                                context: context,
                                heading: section['heading'] as String,
                                content: section['content'] as String,
                                color: categoryData['color'] as Color,
                                language: _selectedLanguage,
                              ),
                            ),
                          );
                        },
                      );
                    })),

                    SizedBox(height: context.responsive(32)),

                    // Important Notice Card
                    Container(
                      padding: EdgeInsets.all(context.responsive(20)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.lighterPink.withValues(alpha: 0.3),
                            AppColors.lightPink.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(context.responsive(20)),
                        border: Border.all(
                          color: AppColors.accentPink.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.accentPink,
                            size: context.responsive(24),
                          ),
                          SizedBox(width: context.responsive(12)),
                          Expanded(
                            child: Text(
                              _selectedLanguage == 'English'
                                  ? 'This information is for educational purposes only. For specific legal advice, please consult with a qualified lawyer.'
                                  : _selectedLanguage == 'Urdu'
                                      ? 'یہ معلومات صرف تعلیمی مقاصد کے لیے ہے۔ مخصوص قانونی مشورے کے لیے، براہ کرم ایک مستند وکیل سے مشورہ کریں۔'
                                      : 'ایہ معلومات صرف تعلیمی مقاصد لئی اے۔ خاص قانونی صلاح لئی، کرم اک مستند وکیل نال صلاح لو۔',
                              style: AppTextStyles.bodySmall1(context).copyWith(
                                fontSize: context.responsive(13),
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryDark.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.responsive(32)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String heading,
    required String content,
    required Color color,
    required String language,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsive(24)),
      padding: EdgeInsets.all(context.responsive(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsive(20)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: context.responsive(15),
            offset: Offset(0, context.responsive(5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: context.responsive(4),
                height: context.responsive(24),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(context.responsive(2)),
                ),
              ),
              SizedBox(width: context.responsive(12)),
              Expanded(
                child: Text(
                  heading,
                  style: language == 'English'
                      ? AppTextStyles.heading4(context).copyWith(
                          fontSize: context.responsive(20),
                          fontWeight: FontWeight.w700,
                        )
                      : AppTextStyles.urduHeading4(context).copyWith(
                          fontSize: context.responsive(20),
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
              // Section-specific play button (plays only this section)
              SizedBox(width: context.responsive(8)),
              GestureDetector(
                onTap: () async {
                  if (_flutterTts != null) {
                    final messenger = ScaffoldMessenger.of(context);
                    await _stopTts();
                    await _setTtsLanguage();
                    final sectionText = '$heading. $content';
                    try {
                      await _flutterTts!.speak(sectionText);
                      if (mounted) {
                        setState(() {
                          _isPlaying = true;
                        });
                      }
                    } catch (e) {
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Error reading: $e'),
                            backgroundColor: AppColors.dangerColor,
                          ),
                        );
                      }
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(context.responsive(8)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.volume_up_rounded,
                    size: context.responsive(18),
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsive(16)),
          Text(
            content,
            style: language == 'English'
                ? AppTextStyles.bodyMedium1(context).copyWith(
                    fontSize: context.responsive(15),
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryDark.withValues(alpha: 0.8),
                    height: 1.6,
                  )
                : AppTextStyles.urduBodyMedium1(context).copyWith(
                    fontSize: context.responsive(15),
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryDark.withValues(alpha: 0.8),
                    height: 1.8,
                  ),
          ),
        ],
      ),
    );
  }
}
