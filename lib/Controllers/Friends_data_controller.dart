import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FriendsDataController extends GetxController {
  List<Map<String, dynamic>> friendDataList = [];
  List<String> friendUids = [];
  bool isloading = false;
  Future getFriendsData() async {
    final box = GetStorage();
    isloading = true;
    update();
    CollectionReference myFriendsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(box.read("uId"))
        .collection('friends');

    QuerySnapshot querySnapshot = await myFriendsCollection.get();

    friendUids = querySnapshot.docs.map((doc) => doc.id).toList();
    friendDataList.clear();
    for (String friendUid in friendUids) {
      DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendUid)
          .get();
      if (friendSnapshot.exists) {
        Map<String, dynamic> friendData =
            friendSnapshot.data() as Map<String, dynamic>;
        friendDataList.add(friendData);
      }
    }
    isloading = false;
    update();
  }
}
