import 'package:get/get.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/models/user_profile_model.dart';

class CreateProfileController extends GetxController {
  final Rx<UserProfileModel> _createProfile = UserProfileModel(
    userId: "userId",
    email: "email",
    avatar: 1,
    userName: "userName",
    phoneNumber: "phoneNumber",
    countryValue: "India",
    stateValue: "Rajasthan",
    cityValue: "Jaipur",
    pinCode: "pinCode",
    gender: "gender",
    age: 0,
    bloodGroup: "bloodGroup",
    wantToDonate: false,
  ).obs;

  void updateUserId(String userId) {
    _createProfile.update((val) {
      val!.userId = userId;
    });
  }

  void updateEmail(String email) {
    _createProfile.update((val) {
      val!.email = email;
    });
  }

  int avatar() {
    return _createProfile.value.avatar;
  }

  String avatarImageConstURL() {
    return ImageConst.avatarImageURL(_createProfile.value.avatar);
  }

  void updateAvatar(int avatar) {
    _createProfile.update((val) {
      val!.avatar = avatar;
    });
  }

  String userName() {
    return _createProfile.value.userName;
  }

  void updateUserName(String userName) {
    _createProfile.update((val) {
      val!.userName = userName;
    });
  }

  String userPhoneNumber() {
    return _createProfile.value.phoneNumber;
  }

  void updateUserPhoneNumber(String phoneNumber) {
    _createProfile.update((val) {
      val!.phoneNumber = phoneNumber;
    });
  }

  String countryValue() {
    return _createProfile.value.countryValue;
  }

  void updateCountryValue(String countryValue) {
    _createProfile.update((val) {
      val!.countryValue = countryValue;
    });
  }

  String stateValue() {
    return _createProfile.value.stateValue;
  }

  void updateStateValue(String stateValue) {
    _createProfile.update((val) {
      val!.stateValue = stateValue;
    });
  }

  String cityValue() {
    return _createProfile.value.cityValue;
  }

  void updateCityValue(String cityValue) {
    _createProfile.update((val) {
      val!.cityValue = cityValue;
    });
  }

  String pinCode() {
    return _createProfile.value.pinCode;
  }

  void updatePinCode(String pinCode) {
    _createProfile.update((val) {
      val!.pinCode = pinCode;
    });
  }

  String gender() {
    return _createProfile.value.gender;
  }

  void updateGender(String gender) {
    _createProfile.update((val) {
      val!.gender = gender;
    });
  }

  int age() {
    return _createProfile.value.age;
  }

  void updateAge(int age) {
    _createProfile.update((val) {
      val!.age = age;
    });
  }

  String bloodGroup() {
    return _createProfile.value.bloodGroup;
  }

  void updateBloodGroup(String bloodGroup) {
    _createProfile.update((val) {
      val!.bloodGroup = bloodGroup;
    });
  }

  bool wantToDonate() {
    return _createProfile.value.wantToDonate;
  }

  void updateWantToDonate(bool wantToDonate) {
    _createProfile.update((val) {
      val!.wantToDonate = wantToDonate;
    });
  }
}
