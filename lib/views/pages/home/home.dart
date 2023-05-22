import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/firebase_const.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/main.dart';
import 'package:health_connect/services/auth.dart';
import 'package:health_connect/services/db/db_2.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/views/pages/onboarding/create_profile_page_2.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_3.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_4.dart';
import 'package:health_connect/views/widgets/custom_buttons/custom_button_1.dart';
import 'package:health_connect/views/widgets/custom_drawer/custom_drawer_1.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _controller = Get.find();
  File? imageFile;
  void cropImage(XFile? file) async {
    try {
      CroppedFile? cropFile = await ImageCropper().cropImage(
        sourcePath: file!.path,
        compressQuality: 20,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (cropFile != null) {
        setState(() {
          imageFile = File(cropFile.path);
        });
        navigatorKey.currentState!.pop();
        setData();
      } else {
        navigatorKey.currentState!.pop();
        if (context.mounted) {
          UiHelper.showAlertDialog(
              context, "Upload Health Docs !!", "please select the image");
        }
        return;
      }
    } catch (e) {
      navigatorKey.currentState!.pop();
      UiHelper.showAlertDialog(context, "Error", e.toString());
    }
  }

  void selectImage(ImageSource source) async {
    UiHelper.showLoadingDialog(context, "Loading");
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) {
        navigatorKey.currentState!.pop();
        if (context.mounted) {
          UiHelper.showAlertDialog(
              context, "Upload Health Docs !!", "please select the image");
        }
        return;
      }
      cropImage(pickedFile);
    } catch (e) {
      navigatorKey.currentState!.pop();
      UiHelper.showAlertDialog(context, "Error!", e.toString());
    }
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Health Docs"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                title: const Text("Select From Gallery"),
                leading: const Icon(Icons.photo_album_outlined),
              ),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  title: const Text("Select From Camera"),
                  leading: const Icon(Icons.camera_alt_outlined))
            ]),
          );
        });
  }

  void setData() async {
    try {
      UiHelper.showLoadingDialog(context, "Uploading ");
      DateTime now = DateTime.now();
      String filename = now.toString();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('${FirebaseConst.images}/$filename')
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection(FirebaseConst.images).add({
        FirebaseConst.userId: _controller.userId,
        FirebaseConst.imageUrl: imageUrl,
        'TS': DateTime.now(),
      }).then((value) {
        Navigator.pop(context);
        UiHelper.showAlertDialog(
            context, "Image Uploaded", "Your Image Uploaded Successfully");
      });
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.mediaQueryHeightWidth();
    return Scaffold(
      appBar: appBar4,
      drawer: const Drawer1(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReusableCard(
            iconData: Icons.upload_file_outlined,
            text: "Upload Docs",
            onPressed: () {
              showPhotoOption();
            },
          ),
          ReusableCard(
            iconData: Icons.image_search_outlined,
            text: "SEE Docs",
            onPressed: () {
              Get.to(() => const ShowImages());
            },
          ),
          Expanded(
            child: Row(
              children: [
                ReusableCard(
                  iconData: Icons.find_in_page_outlined,
                  text: "Find Donors",
                  onPressed: () {
                    Get.to(() => const FindDonors());
                  },
                ),
                ReusableCard(
                  iconData: Icons.chat,
                  text: 'Chats',
                  onPressed: () {
                    Get.to(() => ChatRoom());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UiHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(title),
          ],
        ),
      ),
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return loadingDialog;
        });
  }

  static void showAlertDialog(
      BuildContext context, String title, String content) {
    AlertDialog alertdialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertdialog;
        });
  }
}

class ShowImages extends StatefulWidget {
  const ShowImages({Key? key}) : super(key: key);

  @override
  State<ShowImages> createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _stream;
  void doThis() async {
    setState(() {});
    _stream = FirebaseFirestore.instance
        .collection(FirebaseConst.images)
        .where(FirebaseConst.userId, isEqualTo: _controller.userId)
        .orderBy('TS')
        .snapshots();
    setState(() {});
  }

  @override
  void initState() {
    doThis();
    super.initState();
  }

  final AuthController _controller = Get.find();
  File? imageFile;
  void cropImage(XFile? file) async {
    try {
      CroppedFile? cropFile = await ImageCropper().cropImage(
        sourcePath: file!.path,
        compressQuality: 20,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (cropFile != null) {
        setState(() {
          imageFile = File(cropFile.path);
        });
        navigatorKey.currentState!.pop();
        setData();
      } else {
        navigatorKey.currentState!.pop();
        if (context.mounted) {
          UiHelper.showAlertDialog(
              context, "Upload Health Docs !!", "please select the image");
        }
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "Error", e.toString());
    }
  }

  void selectImage(ImageSource source) async {
    UiHelper.showLoadingDialog(context, "Loading");
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) {
        navigatorKey.currentState!.pop();
        if (context.mounted) {
          UiHelper.showAlertDialog(
              context, "Upload Health Docs !!", "please select the image");
        }
        return;
      }
      cropImage(pickedFile);
    } catch (e) {
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "Error!", e.toString());
    }
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Health Docs"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                title: const Text("Select From Gallery"),
                leading: const Icon(Icons.photo_album_outlined),
              ),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  title: const Text("Select From Camera"),
                  leading: const Icon(Icons.camera_alt_outlined))
            ]),
          );
        });
  }

  void setData() async {
    try {
      UiHelper.showLoadingDialog(context, "Uploading ");
      DateTime now = DateTime.now();
      String filename = now.toString();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('${FirebaseConst.images}/$filename')
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection(FirebaseConst.images).add({
        FirebaseConst.userId: _controller.userId,
        FirebaseConst.imageUrl: imageUrl,
        'TS': DateTime.now(),
      }).then((value) {
        Navigator.pop(context);
        UiHelper.showAlertDialog(
            context, "Image Uploaded", "Your Image Uploaded Successfully");
      });
      doThis();
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar3,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showPhotoOption();
        },
        backgroundColor: ColorConst.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.all(4),
                  child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return FullScreenWidget(
                          disposeLevel: DisposeLevel.High,
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: FadeInImage.memoryNetwork(
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage,
                                image: snapshot.data!.docs[index]
                                    .get(FirebaseConst.imageUrl)),
                          ),
                        );
                      }),
                );
        },
      ),
    );
  }
}

class FindDonors extends StatefulWidget {
  const FindDonors({Key? key}) : super(key: key);

  @override
  State<FindDonors> createState() => _FindDonorsState();
}

class _FindDonorsState extends State<FindDonors> {
  String? bloodGroup, state, city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar3,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          child: Padding(
            padding: AppSizes.horizontalPadding20,
            child: Column(
              children: [
                SizedBox(height: AppSizes.height10 * 2),
                BloodGroupDropDown(
                    value: null,
                    hint: StringConst.selectBloodGroup,
                    onChanged: (String? value) {
                      bloodGroup = value;
                    },
                    validator: (val) {
                      return val == null ? StringConst.selectBloodGroup : null;
                    }),
                SizedBox(height: AppSizes.height10 * 4),
                CSCPicker(
                  showStates: true,
                  showCities: true,
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                  onCountryChanged: (value) {},
                  onStateChanged: (value) {
                    state = value;
                  },
                  onCityChanged: (value) {
                    city = value;
                  },
                ),
                SizedBox(height: AppSizes.height10 * 4),
                CustomButton1(
                  text: StringConst.continueButtonString,
                  buttonColor: ColorConst.primaryColor,
                  textColor: ColorConst.whiteColor,
                  onTap: () {
                    Get.to(() => ShowDonors(
                        bloodGroup: bloodGroup, state: state, city: city));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowDonors extends StatefulWidget {
  final String? bloodGroup, state, city;
  const ShowDonors(
      {Key? key,
      required this.bloodGroup,
      required this.state,
      required this.city})
      : super(key: key);

  @override
  State<ShowDonors> createState() => _ShowDonorsState();
}

class _ShowDonorsState extends State<ShowDonors> {
  final AuthController _controller = Get.find();
  Stream<QuerySnapshot<Map<String, dynamic>>>? _stream;
  void doThis() async {
    setState(() {});
    _stream = FirebaseFirestore.instance
        .collection(FirebaseConst.users)
        .where(FirebaseConst.userId, isNotEqualTo: _controller.userId)
        .where(FirebaseConst.wantToDonate, isEqualTo: true)
        .where(FirebaseConst.bloodGroup, isEqualTo: widget.bloodGroup)
        .where(FirebaseConst.stateValue, isEqualTo: widget.state)
        .where(FirebaseConst.cityValue, isEqualTo: widget.city)
        .snapshots();
    setState(() {});
  }

  @override
  void initState() {
    doThis();
    super.initState();
  }

  Widget usersInfoWidget() {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];

                  return UsersInfo(
                    name: ds[FirebaseConst.userName],
                    pic: ImageConst.avatarImageURL(ds[FirebaseConst.avatar]),
                    email: ds[FirebaseConst.email],
                    phone: ds[FirebaseConst.phoneNumber],
                    bloodGroup: ds[FirebaseConst.bloodGroup],
                    age: ds[FirebaseConst.age],
                    stateName: ds[FirebaseConst.stateValue],
                    cityName: ds[FirebaseConst.cityValue],
                    gender: ds[FirebaseConst.gender],
                    uid: ds[FirebaseConst.userId],
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar3,
      body: usersInfoWidget(),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final void Function()? onPressed;
  final IconData iconData;
  final String text;
  const ReusableCard(
      {super.key,
      required this.iconData,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Checkbox.width * 0.7, vertical: AppSizes.height10),
        decoration: BoxDecoration(
          color: ColorConst.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.height10),
                decoration: BoxDecoration(
                    color: ColorConst.primaryColor,
                    borderRadius: BorderRadius.circular(25)),
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppSizes.height10 * 2),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: AppSizes.height10 * 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainUserMessage extends StatelessWidget {
  final String message;

  const MainUserMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: AppSizes.height10 * 1.2,
              horizontal: AppSizes.width10 * 1.5),
          margin: EdgeInsets.only(
              top: AppSizes.height10,
              bottom: AppSizes.height10 * 0.5,
              left: AppSizes.width10 * 9,
              right: AppSizes.width10 * 1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
          ),
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class OtherUserMessage extends StatelessWidget {
  final String message;

  const OtherUserMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.height10 * 1.2,
            horizontal: AppSizes.width10 * 1.5,
          ),
          margin: EdgeInsets.only(
            top: AppSizes.height10,
            bottom: AppSizes.height10 * 0.5,
            left: AppSizes.width10 * 1.2,
            right: AppSizes.width10 * 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey,
          ),
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class UsersInfo extends StatelessWidget {
  final name,
      pic,
      email,
      phone,
      bloodGroup,
      age,
      stateName,
      cityName,
      gender,
      uid;

  const UsersInfo({
    super.key,
    this.name,
    this.phone,
    this.email,
    this.age,
    this.bloodGroup,
    this.pic,
    this.uid,
    this.gender,
    this.stateName,
    this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppSizes.width10 * 0.7, vertical: AppSizes.height10),
      decoration: BoxDecoration(
        color: ColorConst.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: () {
          Get.to(ProfilePage(
            name: name,
            pic: pic,
            email: email,
            phone: phone,
            bloodGroup: bloodGroup,
            age: age,
            uid: uid,
            cityName: cityName,
            stateName: stateName,
            gender: gender,
          ));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height10 * 1.2),
          child: Row(
            children: [
              SizedBox(width: AppSizes.width10 * 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(55),
                child: Image.asset(pic,
                    height: AppSizes.height10 * 5.5,
                    width: AppSizes.width10 * 5.5),
              ),
              SizedBox(width: AppSizes.width10 * 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: AppSizes.height10 * 0.2),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: AppSizes.height10 * 1.8,
                    ),
                  ),
                  SizedBox(height: AppSizes.height10 * 0.8),
                  Text(
                    "$gender      $bloodGroup      $age Year",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.height10 * 1.8,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final name,
      pic,
      email,
      phone,
      bloodGroup,
      age,
      stateName,
      cityName,
      gender,
      uid;
  ProfilePage({
    super.key,
    this.name,
    this.pic,
    this.email,
    this.phone,
    this.bloodGroup,
    this.age,
    this.uid,
    this.cityName,
    this.stateName,
    this.gender,
  });

  final AuthController _controller = Get.find();

  getAndSetMessage() {
    Get.to(ChatPage(
      name: name,
      email: email,
      uid: uid,
      pic: pic,
      chatRoom: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar3,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(pic),
              ),
              SizedBox(height: 20),
              Text(
                'Name: $name',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Blood Group: $bloodGroup',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Age: $age',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'City: $cityName',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'State: $stateName',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Country: India',
                style: TextStyle(fontSize: 18),
              ),
              email != _controller.email
                  ? ReusableTextButton(
                      buttonTitle: 'Chat with ${name}',
                      buttonColor: ColorConst.primaryColor,
                      onPressed: () {
                        getAndSetMessage();
                      },
                    )
                  : Center()
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableTextButton extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onPressed;
  final Color buttonColor;

  const ReusableTextButton({
    super.key,
    required this.buttonTitle,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: buttonColor),
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            buttonTitle,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String name, pic, email, uid;
  final bool chatRoom;
  const ChatPage(
      {super.key,
      required this.name,
      required this.pic,
      required this.email,
      required this.uid,
      required this.chatRoom});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthController _controller = Get.find();
  final DbController2 _dbController2 = Get.find();
  Stream? _stream;
  final messageTextEditingController = TextEditingController();
  final _focusNode = FocusNode();
  String? chat;
  bool chatRoom() {
    return widget.chatRoom;
  }

  bool? chatRoomOrNot;
  Widget messages() {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return ds['email'] == _controller.email
                      ? MainUserMessage(message: ds['message'])
                      : OtherUserMessage(message: ds['message']);
                },
              )
            : const Center();
      },
    );
  }

  getAndSetMessage() async {
    if (messageTextEditingController.text.trim() != '') {
      setState(() {
        chat = messageTextEditingController.text.trim();
      });

      if (chatRoomOrNot == false) {
        Map<String, dynamic> myMap = {
          'name': widget.name,
          'email': widget.email,
          'pic': widget.pic,
          'uid': widget.uid,
        };
        Map<String, dynamic> map = {
          'name': _dbController2.userProfileModel[0].userName,
          'email': _controller.email,
          'pic': _dbController2.avatarImageConst(),
          'uid': _controller.userId,
        };
        await DataBaseMethods().saveMyChatRooms(
            uid: _controller.userId, gmail: widget.email, map: myMap);
        await DataBaseMethods().saveOtherChatRooms(
            uid: widget.uid, gmail: _controller.email, map: map);
      }
      var lastMessageTS = DateTime.now();
      Map<String, dynamic> myMessageInfoMap = {
        'message': chat,
        'lastMessageTS': lastMessageTS,
        'email': _controller.email,
      };
      setState(() {
        chatRoomOrNot = true;
      });
      messageTextEditingController.clear();

      await DataBaseMethods().saveMyChats(
          uid: _controller.userId, gmail: widget.email, map: myMessageInfoMap);
      await DataBaseMethods().saveOtherChats(
          uid: widget.uid, gmail: _controller.email, map: myMessageInfoMap);

      setState(() {});
      _stream = await DataBaseMethods()
          .getChats(uid: _controller.userId, gmail: widget.email);
      setState(() {});
    }
  }

  doThis() async {
    setState(() {});
    _stream = await DataBaseMethods()
        .getChats(uid: _controller.userId, gmail: widget.email);
    setState(() {});
  }

  @override
  void initState() {
    doThis();
    chatRoomOrNot = chatRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: AppSizes.height10 * 7,
        backgroundColor: ColorConst.primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle().copyWith(
          statusBarColor: ColorConst.primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppSizes.height10 * 3),
          ),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                widget.pic,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: messages(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ReusableTextFormField(
              iconData: Icons.chat,
              keyboardType: TextInputType.name,
              validator: (val) {},
              hintText: 'Type a message',
              focusNode: _focusNode,
              controller: messageTextEditingController,
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: ColorConst.primaryColor),
                splashRadius: 25,
                onPressed: () {
                  getAndSetMessage();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DataBaseMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future saveMyChatRooms(
      {required String uid, gmail, required Map<String, dynamic> map}) async {
    return await _firestore
        .collection('chats')
        .doc(uid)
        .collection('chatRooms')
        .doc(gmail)
        .set(map);
  }

  Future saveOtherChatRooms(
      {required String uid, gmail, required Map<String, dynamic> map}) async {
    return await _firestore
        .collection('chats')
        .doc(uid)
        .collection('chatRooms')
        .doc(gmail)
        .set(map);
  }

  Future getChatRooms({required String uid}) async {
    return _firestore
        .collection('chats')
        .doc(uid)
        .collection('chatRooms')
        .snapshots();
  }

  Future saveMyChats(
      {required String uid, gmail, required Map<String, dynamic> map}) async {
    return await _firestore
        .collection('chats')
        .doc(uid)
        .collection('chatRooms')
        .doc(gmail)
        .collection('chat')
        .add(map);
  }

  Future saveOtherChats(
      {required String uid, gmail, required Map<String, dynamic> map}) async {
    return await _firestore
        .collection('chats')
        .doc(uid)
        .collection('chatRooms')
        .doc(gmail)
        .collection('chat')
        .add(map);
  }

  getChats({required String uid, gmail}) async {
    return _firestore
        .collection('chats')
        .doc(uid)
        .collection('chatRooms')
        .doc(gmail)
        .collection('chat')
        .orderBy('lastMessageTS', descending: true)
        .snapshots();
  }
}

class ReusableTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget suffixIcon;
  final IconData iconData;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final FocusNode focusNode;

  const ReusableTextFormField({
    super.key,
    required this.hintText,
    required this.iconData,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    required this.focusNode,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      textAlign: TextAlign.start,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(),
      onChanged: (value) {},
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: suffixIcon,
        prefixIcon: Icon(iconData, color: Colors.grey),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream? _usersStream;
  final AuthController _controller = Get.find();

  doThis() async {
    setState(() {});
    _usersStream =
        await DataBaseMethods().getChatRooms(uid: _controller.userId);
    setState(() {});
  }

  Widget listTileInfoWidget() {
    return StreamBuilder(
      stream: _usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Scrollbar(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    return Column(
                      children: [
                        Divider(thickness: 2, height: 0),
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              ds["pic"],
                              height: 50,
                              width: 50,
                            ),
                          ), //
                          title: Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 7),
                            child: Text(ds['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          subtitle: Text(ds['email']),
                          onTap: () {
                            Get.to(ChatPage(
                              pic: ds['pic'],
                              name: ds['name'],
                              email: ds['email'],
                              uid: ds['uid'],
                              chatRoom: true,
                            ));
                          },
                        ),
                        Divider(thickness: 2, height: 0),
                      ],
                    );
                  },
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    doThis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar3,
      body: listTileInfoWidget(),
    );
  }
}

Widget crossButton() {
  return IconButton(
    onPressed: () {
      Get.offAll(() => const HomePage());
    },
    splashRadius: 25,
    icon: const Icon(
      Icons.home,
      color: Colors.white,
    ),
  );
}
