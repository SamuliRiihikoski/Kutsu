class Filters {
  Filters({required this.gender, required this.age, required this.distance});

  Filters.init()
      : gender = "male",
        age = 18,
        distance = 100;

  String gender;
  int age;
  int distance;
}
