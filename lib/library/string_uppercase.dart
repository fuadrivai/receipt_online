extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String firstUpperCase() {
    String value = this;

    List<String> vals = value.split(" ");
    List<String> newVals = [];
    for (var e in vals) {
      e = "${e[0].toUpperCase()}${e.substring(1)}";
      newVals.add(e);
    }
    return newVals.join(" ");
  }

  String upperCase() {
    return toUpperCase();
  }
}
