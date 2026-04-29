/// Use case to get baby size reference (fruit comparison)
class GetBabySizeReference {
  /// Map of week number to fruit/object name
  static const Map<int, String> _babySizeMap = {
    4: 'Poppy Seed',
    5: 'Sesame Seed',
    6: 'Lentil',
    7: 'Blueberry',
    8: 'Kidney Bean',
    9: 'Grape',
    10: 'Kumquat',
    11: 'Fig',
    12: 'Lime',
    13: 'Pea Pod',
    14: 'Lemon',
    15: 'Apple',
    16: 'Avocado',
    17: 'Turnip',
    18: 'Bell Pepper',
    19: 'Tomato',
    20: 'Banana',
    21: 'Carrot',
    22: 'Spaghetti Squash',
    23: 'Mango',
    24: 'Corn',
    25: 'Rutabaga',
    26: 'Scallion',
    27: 'Cauliflower',
    28: 'Eggplant',
    29: 'Butternut Squash',
    30: 'Cabbage',
    31: 'Coconut',
    32: 'Jicama',
    33: 'Pineapple',
    34: 'Cantaloupe',
    35: 'Honeydew Melon',
    36: 'Romaine Lettuce',
    37: 'Swiss Chard',
    38: 'Leek',
    39: 'Mini Watermelon',
    40: 'Pumpkin',
  };

  /// Get fruit/object name for current week
  String execute(int week) {
    // Find closest week
    if (_babySizeMap.containsKey(week)) {
      return _babySizeMap[week]!;
    }
    
    // Find closest lower week
    int closestWeek = week;
    while (closestWeek > 4 && !_babySizeMap.containsKey(closestWeek)) {
      closestWeek--;
    }
    
    return _babySizeMap[closestWeek] ?? 'Tiny Seed';
  }

  /// Get all size references (for UI display)
  static Map<int, String> getAllReferences() => _babySizeMap;
}

