import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? msg;
  String? senderId;
  String? reciverId;
  String? sentTime;
  String? reciveTime;

  Message(
      {this.msg,
      this.senderId,
      this.reciverId,
      this.sentTime,
      this.reciveTime});

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    senderId = json['senderId'];
    reciverId = json['reciverId'];
    sentTime = json['sentTime'];
    reciveTime = json['reciveTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['senderId'] = this.senderId;
    data['reciverId'] = this.reciverId;
    data['sentTime'] = this.sentTime;
    data['reciveTime'] = this.reciveTime;
    return data;
  }
}
