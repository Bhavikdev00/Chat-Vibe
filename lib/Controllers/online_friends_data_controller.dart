import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnlineFrdDataController extends GetxController {
  List onlineFrdData = [];

  void getData() async {
    final box = GetStorage();
    CollectionReference myFriendsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(box.read("uId"))
        .collection('friends');

    QuerySnapshot querySnapshot = await myFriendsCollection.get();

    List<String> friendUids = querySnapshot.docs.map((doc) => doc.id).toList();

    friendUids.forEach((element) {
      var d = FirebaseFirestore.instance
          .collection("users")
          .doc(element)
          .snapshots();

      d.listen((event) {
        onlineFrdData.clear();
        update();
        Map data = event.data() as Map;

        if (data['status'] == "Online") {
          onlineFrdData.add(event.data());
        }

        print("-------=========== DAta  $onlineFrdData");
        update();
      });
    });
  }
}
