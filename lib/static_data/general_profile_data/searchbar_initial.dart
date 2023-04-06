import 'dart:math';

class SearchbarInitial {
  static String initial() {
    List<String> values = [
      "@ruder.buster",
      "Wilson",
      "Phi Sigma Kappa",
      "Computer Science",
      "Industrial Engineering",
      "Med School",
      "Vice Versa",
      "Soccer",
      "The Lair",
    ];

    String val = " Try \'";
    //add a random value from the list
    val += values[Random().nextInt(values.length)] + "\'";
    return val;
  }
}
