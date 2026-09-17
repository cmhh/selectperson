import 'package:select_person/select_person.dart';

const version = '0.0.1'; 

void main(List<String> arguments) {
  // 5 age groups, and we only want non-zero selections for the middle 3
  // and we want to drop 10% of dwellings where all people aged [5,24] are [5,11]
  var selector = PersonSelector([0, 1, 3, 2, 0], 0.1);

  // we should should get a value of (-1, 0.0) roughly 1 in every 10 selections
  // 0 and 1 should be a 50-50 split for the rest.
  for (int i = 0; i < 20; i++) {
    print(selector.select([5,6,30,30]));
  }
} 