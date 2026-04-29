// lib/modules/legal/screens/voice_assistant_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../../contents/colors.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../contents/textstyles.dart';
import '../../../../core/extensions/extensions.dart';
import '../viewmodels/legal_provider.dart';
import '../../../../core/services/locale_service.dart';
import 'package:umeed_e_zann/l10n/app_localizations.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen>
    with TickerProviderStateMixin {
  bool _isListening = false;
  String? _transcribedText;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;
  String _currentWords = '';
  String _selectedLanguage = 'Urdu'; // Default to Urdu
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _waveController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWithGlobalLocale();
      _initializeSpeech();
    });
  }

  void _syncWithGlobalLocale() {
    final localeService = Provider.of<LocaleService>(context, listen: false);
    final currentLang = localeService.locale.languageCode;
    
    setState(() {
      if (currentLang == 'ur') {
        _selectedLanguage = 'Urdu';
      } else if (currentLang == 'pa') {
        _selectedLanguage = 'Punjabi';
      } else {
        _selectedLanguage = 'English';
      }
    });
  }

  Future<void> _initializeSpeech() async {
    // Request microphone permission
    final micPermission = await Permission.microphone.status;
    if (!micPermission.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        if (!mounted) return;
        setState(() {
          _speechAvailable = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.microphonePermissionRequired),
            backgroundColor: AppColors.dangerColor,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
    }

    // Get available languages
    final languages = await _speech.locales();
    debugPrint('Available languages: ${languages.map((l) => '${l.localeId} - ${l.name}').join(', ')}');

    bool available = await _speech.initialize(
      onError: (val) {
        if (mounted) {
          setState(() {
            _isListening = false;
            _speechAvailable = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech recognition error: $val'),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
      },
      onStatus: (val) {
        if (mounted) {
          if (val == 'done' || val == 'notListening') {
            setState(() {
              _isListening = false;
            });
            _pulseController.stop();
            _waveController.stop();
            _pulseController.reset();
            _waveController.reset();
          }
        }
      },
    );
    if (mounted) {
      setState(() {
        _speechAvailable = available;
      });
      
      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.speechNotAvailable),
            backgroundColor: AppColors.dangerColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _speech.stop();
    super.dispose();
  }

  String _getLocaleId() {
    // Robust locale mapping for regional languages
    switch (_selectedLanguage) {
      case 'Urdu':
        // Try precise PK first, then generic
        return 'ur_PK'; 
      case 'Punjabi':
        // Punjabi is often tricky on Android/iOS (pa-PK, pa-IN, or just pa)
        return 'pa_PK';
      default:
        return 'en_US';
    }
  }

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      final micPermission = await Permission.microphone.status;
      if (!micPermission.isGranted) {
        final result = await Permission.microphone.request();
        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Microphone permission is required'),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
          return;
        }
        await _initializeSpeech();
        if (!_speechAvailable) {
          return;
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speech recognition not available. Please check permissions.'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
        return;
      }
    }

    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        if (_currentWords.isNotEmpty) {
          _transcribedText = _currentWords;
          _currentWords = '';
          // Process the transcribed text
          _processTranscription(_transcribedText!);
        }
      });
      _pulseController.stop();
      _waveController.stop();
      _pulseController.reset();
      _waveController.reset();
    } else {
      setState(() {
        _isListening = true;
        _transcribedText = null;
        _currentWords = '';
      });
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
      
      final localeId = _getLocaleId();
      debugPrint('Using locale: $localeId for language: $_selectedLanguage');
      
      _speech.listen(
        onResult: (val) {
          if (mounted) {
            setState(() {
              _currentWords = val.recognizedWords;
              if (val.finalResult) {
                _transcribedText = val.recognizedWords;
                _isListening = false;
                _pulseController.stop();
                _waveController.stop();
                _pulseController.reset();
                _waveController.reset();
                // Process the transcribed text
                _processTranscription(_transcribedText!);
              }
            });
          }
        },
        localeId: localeId,
        listenOptions: stt.SpeechListenOptions(
          cancelOnError: false,
          partialResults: true,
        ),
      );
    }
  }

  Future<void> _processTranscription(String text) async {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      final provider = Provider.of<LegalProvider>(context, listen: false);
      final response = await provider.sendChatbotMessage(text);
      
      if (!mounted) return;
      
      if (response != null) {
        // Show response in a dialog or snackbar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Legal Assistant Response'),
            content: SingleChildScrollView(
              child: Text(response),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${provider.error}'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing: $e'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.voiceAssistant,
        showLogo: true,
        showBackButton: true,
        backgroundColor: null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Language Selection
            Container(
              padding: EdgeInsets.all(context.responsive(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['Urdu', 'Punjabi', 'English'].map((lang) {
                  final isSelected = _selectedLanguage == lang;
                  return GestureDetector(
                    onTap: () {
                      if (_isListening) {
                        _speech.stop();
                        setState(() {
                          _isListening = false;
                          _selectedLanguage = lang;
                        });
                        _pulseController.stop();
                        _waveController.stop();
                      } else {
                        setState(() {
                          _selectedLanguage = lang;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: context.responsive(8)),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive(16),
                        vertical: context.responsive(8),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accentPurple
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(context.responsive(20)),
                      ),
                      child: Text(
                        lang,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          color: isSelected ? AppColors.white : AppColors.primaryDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(context.responsive(32)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Status Text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _isProcessing
                              ? AppLocalizations.of(context)!.processing
                              : _isListening
                                  ? (_selectedLanguage == 'Urdu'
                                      ? 'سن رہا ہے...'
                                      : _selectedLanguage == 'Punjabi'
                                          ? 'سن رہیا اے...'
                                          : 'Listening...')
                                  : (_selectedLanguage == 'Urdu'
                                      ? 'بات کرنے کے لیے دبائیں'
                                      : _selectedLanguage == 'Punjabi'
                                          ? 'بولن لئی دباؤ'
                                          : 'Tap to Speak'),
                          key: ValueKey('$_isListening$_isProcessing'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium1(context).copyWith(
                            color: _isListening || _isProcessing
                                ? AppColors.accentPink
                                : AppColors.primaryDark.withValues(alpha: 0.7),
                            fontSize: context.responsive(32),
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: context.responsive(8)),
                      Text(
                        _isProcessing
                            ? AppLocalizations.of(context)!.gettingLegalAdvice
                            : _isListening
                                ? 'Listening...'
                                : 'Tap to Speak',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium1(context).copyWith(
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 60),

                      // Animated Microphone Button
                      GestureDetector(
                        onTap: _isProcessing ? null : _toggleListening,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: (_isListening || _isProcessing) ? _scaleAnimation.value : 1.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer wave rings
                                  if (_isListening)
                                    ...List.generate(3, (index) {
                                      return AnimatedBuilder(
                                        animation: _waveController,
                                        builder: (context, child) {
                                          return Container(
                                            width: context.responsive(200) + (index * context.responsive(40)) +
                                                (_waveAnimation.value * context.responsive(30)),
                                            height: context.responsive(200) + (index * context.responsive(40)) +
                                                (_waveAnimation.value * context.responsive(30)),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.accentPink
                                                    .withValues(alpha:
                                                        0.3 - (index * 0.1)),
                                                width: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  // Main button
                                  Container(
                                    width: context.responsive(180),
                                    height: context.responsive(180),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: (_isListening || _isProcessing)
                                            ? [AppColors.accentPink, AppColors.lightPink]
                                            : [AppColors.accentPurple, AppColors.mediumPurple],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: ((_isListening || _isProcessing)
                                                  ? AppColors.accentPink
                                                  : AppColors.accentPurple)
                                              .withValues(alpha: 0.4),
                                          blurRadius: 30,
                                          spreadRadius: (_isListening || _isProcessing) ? 10 : 5,
                                        ),
                                      ],
                                    ),
                                    child: _isProcessing
                                        ? Padding(
                                            padding: EdgeInsets.all(context.responsive(20)),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                            ),
                                          )
                                        : Icon(
                                            _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                                            color: AppColors.white,
                                            size: context.responsive(80),
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: context.responsive(60)),

                      // Transcribed Text Display
                      if (_transcribedText != null) ...[
                        Container(
                          padding: EdgeInsets.all(context.responsive(20)),
                          margin: EdgeInsets.symmetric(horizontal: context.responsive(20)),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(context.responsive(20)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark.withValues(alpha: 0.1),
                                blurRadius: context.responsive(15),
                                offset: Offset(0, context.responsive(5)),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.transcribed,
                                style: AppTextStyles.bodySmall1(context).copyWith(
                                  fontSize: context.responsive(12),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark.withValues(alpha: 0.6),
                                ),
                              ),
                              SizedBox(height: context.responsive(8)),
                              Text(
                                _transcribedText!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMedium1(context).copyWith(
                                  fontSize: context.responsive(18),
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.responsive(20)),
                      ],

                      // Instructions
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsive(24),
                          vertical: context.responsive(16),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lighterPink.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(context.responsive(16)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.accentPink,
                              size: context.responsive(20),
                            ),
                            SizedBox(width: context.responsive(12)),
                            Flexible(
                              child: Text(
                                _selectedLanguage == 'Urdu'
                                    ? 'بہترین نتائج کے لیے اردو میں واضح بولیں'
                                    : _selectedLanguage == 'Punjabi'
                                        ? 'بہتر نتیجے لئی پنجابی وچ صاف بولو'
                                        : 'Speak clearly for best results',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySmall1(context).copyWith(
                                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                                  fontSize: context.responsive(13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
