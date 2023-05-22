class UserProfileModel {
  String userId;
  String email;

  int avatar;
  String userName;
  String phoneNumber;
  String countryValue;
  String stateValue;
  String cityValue;
  String pinCode;

  String gender;
  int age;
  String bloodGroup;
  bool wantToDonate;

  UserProfileModel({
    required this.userId,
    required this.email,
    required this.avatar,
    required this.userName,
    required this.phoneNumber,
    required this.countryValue,
    required this.stateValue,
    required this.cityValue,
    required this.pinCode,
    required this.gender,
    required this.age,
    required this.bloodGroup,
    required this.wantToDonate,
  });
}
