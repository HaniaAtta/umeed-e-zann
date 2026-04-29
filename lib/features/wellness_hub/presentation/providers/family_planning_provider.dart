import 'package:flutter/foundation.dart';
import '../../../../data/services/auth_service.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/entities/quiz_answers.dart';
import '../../domain/entities/contraceptive_method.dart';
import '../../domain/repositories/family_planning_repository.dart';
import '../../data/repositories/family_planning_repository_impl.dart';
import '../../data/datasources/family_planning_remote_datasource.dart';
import '../../domain/services/contraception_matcher.dart';
import '../../domain/usecases/match_contraceptive_usecase.dart';

/// Provider for Family Planning (Contraception Quiz) feature
class FamilyPlanningProvider with ChangeNotifier {
  final FamilyPlanningRepository _repository;
  final ContraceptionMatcher _matcher;
  final MatchContraceptiveUseCase _matchUseCase;
  final AuthService _authService = AuthService();

  FamilyPlanningProvider()
      : _repository = FamilyPlanningRepositoryImpl(FamilyPlanningRemoteDataSource()),
        _matcher = ContraceptionMatcher(),
        _matchUseCase = MatchContraceptiveUseCase();

  List<QuizResult> _quizResults = [];
  QuizResult? _latestResult;
  bool _isLoading = false;
  String? _error;

  List<QuizResult> get quizResults => _quizResults;
  QuizResult? get latestResult => _latestResult;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get current user ID
  String? get _userId => _authService.currentUser?.uid;

  /// Load quiz results
  Future<void> loadQuizResults() async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      _quizResults = await _repository.getQuizResults(_userId!);
      _latestResult = await _repository.getLatestQuizResult(_userId!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Match user answers with contraception methods
  QuizResult matchContraceptionMethod(Map<String, dynamic> userAnswers) {
    return _matcher.matchMethod(userAnswers);
  }

  /// Match contraceptive method using use case (returns ContraceptiveMethod)
  ContraceptiveMethod matchContraceptive(QuizAnswers answers) {
    return _matchUseCase.execute(answers);
  }

  /// Save quiz result with ContraceptiveMethod
  Future<void> saveQuizResult(QuizAnswers answers, ContraceptiveMethod method) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      // Convert to QuizResult for storage
      final result = _matcher.matchMethod(answers.toMap());
      await _repository.saveQuizResult(_userId!, result);
      _latestResult = result;
      await loadQuizResults(); // Reload to update list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save quiz result
  Future<void> saveQuizResultFromModel (QuizResult result) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _repository.saveQuizResult(_userId!, result);
      _latestResult = result;
      await loadQuizResults(); // Reload to update list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Submit quiz and save result
  Future<QuizResult> submitQuiz(Map<String, dynamic> userAnswers) async {
    _setLoading(true);
    _error = null;

    try {
      // Match method based on answers
      final result = _matcher.matchMethod(userAnswers);
      
      // Save to database if user is logged in
      if (_userId != null) {
        await _repository.saveQuizResult(_userId!, result);
        _latestResult = result;
        await loadQuizResults();
      }

      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete quiz result
  Future<void> deleteQuizResult(String resultId) async {
    if (_userId == null) return;

    _setLoading(true);
    _error = null;

    try {
      await _repository.deleteQuizResult(_userId!, resultId);
      _quizResults.removeWhere((result) => result.recommendedMethod == resultId);
      if (_latestResult?.recommendedMethod == resultId) {
        _latestResult = _quizResults.isNotEmpty ? _quizResults.first : null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

