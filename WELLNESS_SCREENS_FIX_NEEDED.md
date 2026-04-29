# Wellness Screens Need Provider Integration

## Problem
The wellness feature screens exist but are **NOT connected to the backend providers**. They're showing hardcoded/static data instead of real Firebase data.

## Current Status

### ✅ Backend Complete
- All providers are implemented and working
- All Firebase services are ready
- All use cases are complete

### ❌ UI Not Connected
- Cycle Tracker: Shows hardcoded `currentCycleDay = 22`, `currentPhase = 'Luteal Phase'`
- Family Planning: Just shows static cards, no quiz functionality
- Maternity Wing: Shows hardcoded `currentWeek = 24`, `ppdScore = 5`

## What Needs to Be Done

### 1. Cycle Tracker Screen
**File:** `lib/features/wellness_hub/presentation/screens/cycle_tracker_screen.dart`

**Changes Needed:**
- Import `CycleTrackerProvider` and `Provider` package
- Use `Provider.of<CycleTrackerProvider>(context)` to access provider
- Load cycle profile and logs in `initState()`
- Use `provider.getCurrentPhase()` instead of hardcoded phase
- Use `provider.generatePainHeatmapData()` and `provider.generateEnergyHeatmapData()` for heatmaps
- Use `provider.getPhaseRecommendations()` for food/habit tips
- Connect `SymptomLogger` widget to save logs via provider

### 2. Family Planning Screen
**File:** `lib/features/wellness_hub/presentation/screens/family_planning_screen.dart`

**Changes Needed:**
- Import `FamilyPlanningProvider` and `Provider` package
- Create a quiz screen/form to collect user answers
- Use `provider.matchContraceptionMethod(userAnswers)` to get matched method
- Use `provider.saveQuizResult(result)` to save to Firebase
- Show quiz results and recommendations
- Connect "Find what is right for me" button to actual quiz flow

### 3. Maternity Wing Screen
**File:** `lib/features/wellness_hub/presentation/screens/maternity_wing_screen.dart`

**Changes Needed:**
- Import `MaternityWingProvider` and `Provider` package
- Load pregnancy profile in `initState()`
- Use `provider.getCurrentWeek()` instead of hardcoded `currentWeek = 24`
- Use `provider.getBabySizeReference()` for baby size
- Connect appointment management to provider CRUD methods
- Connect PPD screener to `provider.calculatePPDScore()` and `provider.savePPDLog()`
- Show real appointments from Firebase
- Show real PPD logs from Firebase

## Implementation Priority

1. **Cycle Tracker** - Most important, users need to track cycles
2. **Maternity Wing** - Important for pregnant users
3. **Family Planning** - Nice to have, can be added later

## Next Steps

I'll start connecting these screens one by one, beginning with Cycle Tracker as it's the most critical feature.
