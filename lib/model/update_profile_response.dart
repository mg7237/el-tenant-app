import 'dart:convert';

UpdateProfileResponse updateProfileResponseFromJson(String str) => UpdateProfileResponse.fromJson(json.decode(str));

String updateProfileResponseToJson(UpdateProfileResponse data) => json.encode(data.toJson());

class UpdateProfileResponse {
  bool updateSuccessful;

  UpdateProfileResponse({
    this.updateSuccessful,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) => new UpdateProfileResponse(
    updateSuccessful: json["updateSuccessful"] == null ? null : json["updateSuccessful"],
  );

  Map<String, dynamic> toJson() => {
    "updateSuccessful": updateSuccessful == null ? null : updateSuccessful,
  };
}