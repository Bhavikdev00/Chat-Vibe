import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../Firebase Services/friend_request_services.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final box = GetStorage();
  FriendServices friendServices = FriendServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xff1B202D),
        title: const Text('Friend Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(box.read("uId"))
            .collection('friend_requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No Data Found"),
            );
          }

          final friendRequests = snapshot.data!.docs;

          if (friendRequests.isEmpty) {
            return const Center(
              child: Text(
                'No friend requests.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: friendRequests.length,
            itemBuilder: (context, index) {
              final friendRequestData = friendRequests[index].data();
              final senderUid = friendRequests[index].id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(senderUid)
                    .get(),
                builder: (context, senderSnapshot) {
                  if (senderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!senderSnapshot.hasData) {
                    return const Text('Error loading sender data.');
                  }

                  final senderUsername =
                      senderSnapshot.data!['username'] as String;

                  return ListTile(
                    title: Text(
                      'Friend request from: $senderUsername',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            await friendServices.acceptFriendRequest(
                                box.read("uId"), senderUid);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await friendServices.rejectFriendRequest(
                                box.read("uId"), senderUid);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
