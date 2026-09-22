# Overview

A basic entry point is provided which includes some basic testing.  To run:

```bash
dart --enable-asserts run cli/bin/cli.dart
```

The basic interface is:

```dart
import 'package:select_person/select_person.dart';

PersonSelector selector = PersonSelector([0, 1, 3, 2, 0], 0.1);
var (i, pi) = selector1.select([4, 5, 12, 18, 40, 41]);
```

Here, we create a selector where scaling factors are applied to the age groups $[0,4]$, $[5,11]$, $[12, 17]$, $[18,24]$, $[25,)$ of $[0, 1, 3, 2, 0]$, respectively, and no selection is made 10% of the time where the only people aged $[5,24]$ are $[5,11]$.  Selections are made by passing a `List` of single-year ages, and the return value is a tuple holding the index of the selected person and the selection probability. 


# Details

Given a list of single-year ages, we calculate selection probabilities by first converting ages to age groups $[0,4]$, $[5,11]$, $[12,17]$, $[18,24]$, $[25,)$; and then counting the number in each.  For example, $[0,5,5,12,12,18,18,25]$ would be converted to the following age groups: $[1,2,2,3,3,4,4,5]$, and the frequencies would be $[1,2,2,2,1]$.  

Let the counts be represented as $\mathbf{x}'=[x_1, x_2, x_3, x_4, x_5]$, and scaling factors as $mathbf{k}'=[k_1, k_2, k_3, k_4, k_5]$.  Selection probabilities are then calculated for each age group as follows:

$$
\mathbf{\pi} =  \frac{\mathbf{k}}{\mathbf{x}\cdot\mathbf{k}}
$$

Assume counts of $\mathbf{x} = [1,2,2,2,1]$ as above, and let $\mathbf{k}=[0,1,3,2,0]$.  Then:

$$
\mathbf{\pi} = \frac{1}{12}[0,1,3,2,0]' 
$$

Expanding this out, the vector of ages $[0,5,5,12,12,18,18,25]$ would be subjected to an unequal selection with probabilities $[0, 1/12, 1/12, 3/12, 3/12, 2/12, 2/12, 0]$.