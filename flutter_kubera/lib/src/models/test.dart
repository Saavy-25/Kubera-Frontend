class Test{
  final String message;

  Test({required this.message});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      message: json['message'],
    );
  }
}