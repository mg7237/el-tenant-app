class UpdateFcmTokenRequest{
  String fcmToken='';

  Map<String, dynamic> toMap() => {
    "fcmToken": fcmToken,
  };
}