import 'dart:math';

/// Class for making person selections.
class PersonSelector {
  /// Scaling factors to be used to alter selection probabilities
  final List<double> _scalingFactors;
  /// Screening rate for dwellings where the only people aged [5,24] are all [5,11]
  final double _screeningRate;
  /// Random number generator
  final random = Random();

  PersonSelector(List<double> scalingFactors, double screeningRate) :
    assert(scalingFactors.length == 5, 'Scaling vector must have 5 elements.'),
    assert(screeningRate >= 0 && screeningRate <= 1, 'Screening rate must be in [0, 1].'),
    _scalingFactors = scalingFactors,
    _screeningRate = screeningRate;

  /// Make a selection.
  /// 
  /// Given a list of ages, make a selection.
  /// 
  /// Returns the index of the selected person and the probability that was assigned.
  (int, double) select(List<int> ages) {
    if (_drop(ages)) return(-1, 0);

    double c = 0;
    List<double> pr = _pi(ages); 
    double r = random.nextDouble();

    for (int i = 0; i < pr.length; i ++) {
      c += pr[i];
      if (r <= c) return (i, pr[i]);
    }

    return(-1, 0);
  }
  
  /// Decide whether or not to drop a dwelling.
  /// 
  /// For dwellings where all people aged [5,24] are aged [5,11], 
  /// [true] will be returned with probability [_screeningRate].
  bool _drop(List<int> ages) {
    List<int> counts = _bin(ages);
    if (counts[1] > 0 && counts[2] == 0 && counts[3] == 0) {
      if (random.nextDouble() <=  _screeningRate) return true;
    }
    return false;
  }

  /// Calculate selection probabilities
  List<double> _pi(List<int> ages) {
    List<double> counts = _bin(ages).map((x) => x.toDouble()).toList();
    double s = [for (int i = 0; i < counts.length; i++) counts[i] * _scalingFactors[i]].fold(0, (x, el) => x + el);
    List<double> pr = _scalingFactors.map((x) => x / s).toList();
    return ages.map((x) => _ageGroup(x)).map((x) => pr[x - 1]).toList();
  }

  /// Convert single-year age to age group.
  static int _ageGroup(int age) {
    if (age < 0) throw ArgumentError('age must be an integer greater than zero.');

    if (age < 5) {
      return 1;
    } else if (age < 12) {
      return 2;
    } else if (age < 18) {
      return 3;
    } else if (age < 25) {
      return 4;
    } else {
      return 5;
    }
  }

  /// Return counts by age group
  static List<int> _bin(List<int> ages) => 
    ages.fold(
      [0,0,0,0,0], 
      (p, el) => [1,2,3,4,5].map((i) => (_ageGroup(el) == i) ? p[i - 1] + 1 : p[i - 1]).toList()
    );
}
