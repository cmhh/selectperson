import 'package:select_person/select_person.dart';

const version = '0.0.1'; 

void main(List<String> arguments) {
  PersonSelector selector1 = PersonSelector([0, 1, 3, 2, 0], 0.1);
  PersonSelector selector2 = PersonSelector([0, 1, 3, 2, 0], 0.0);

  // test drop logic ----------------------------------------------------------
  int dropped = 0;
  for (int i = 0; i < 1e5; i++) {
    if (selector1.drop([5])) dropped += 1;
  }

  print("\ntesting drop logic...");
  print("actual: 0.1, estimate: ${dropped / 1e5}"); 

  // test random selection ----------------------------------------------------
  List<double> pi0 = [0.1, 0.2, 0.3, 0.4];
  List<int> selections = [];

  for (int i = 0; i < 1e5; i++) {
    selections.add(PersonSelector.select0(pi0));
  }

  List<double> pi0_ = PersonSelector.bin(selections).map((x) => x / 1e5).toList(); 

  print("\ntesting random selection...");
  print("actual: $pi0, estimate: $pi0_");

  // test person selection ----------------------------------------------------
  //// repeatedly select from a [5-11] - exclusive dwelling
  //// should get (-1, 0.0) 10% of the time.
  //// the rest of the time, should be a 50-50 split of 0s and 1s
  selections = [];
  for (int i = 0; i < 1e6; i++) {
    selections.add(selector1.select([5,6,30,30]).$1);
  }

  print("\ntesting person selection in [5-11]-exclusive dwellings...");
  print("actual: [0.1, 0.45, 0.45], estimate: ${PersonSelector.bin(selections, -1, 1).map((x) => x / 1e6)}");

  selections = [];
  for (int i = 0; i < 1e6; i++) {
    selections.add(selector2.select([5, 5, 12, 12, 18, 18]).$1);
  }

  print("\ntesting person selection...");
  print("actual: ${selector2.pi([5, 5, 12, 12, 18, 18])}");
  print("estimate: ${PersonSelector.bin(selections, 0, 5).map((x) => x / 1e6)}");
} 