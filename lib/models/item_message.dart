import 'package:fafte/models/message.dart';
import 'package:fafte/models/user.dart';

class ItemMessageModel {
  MessageModel? messageModel;
  UserModel? userModel;

  ItemMessageModel({
    this.messageModel,
    this.userModel,
  });

  ItemMessageModel.fromJson(Map<String, dynamic> json) {
    if (userModel != null) {
      userModel = UserModel.fromJson(json['userModel']);
    }
    if (messageModel != null) {
      messageModel = MessageModel.fromJson(json['messageModel']);
    }
  }

  Map<String, dynamic> toJson() => {
        'messageModel': this.messageModel ?? '',
        'userModel': this.userModel ?? '',
      };
}
