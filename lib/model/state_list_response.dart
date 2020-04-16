// To parse this JSON data, do
//
//     final stateListResponse = stateListResponseFromJson(jsonString);

import 'dart:convert';

StateListResponse stateListResponseFromJson(String str) => StateListResponse.fromJson(json.decode(str));

String stateListResponseToJson(StateListResponse data) => json.encode(data.toJson());

class StateListResponse {
  bool status;
  List<State> states;
  String message;

  StateListResponse({
    this.status,
    this.states,
    this.message,
  });

  factory StateListResponse.fromJson(Map<String, dynamic> json) => new StateListResponse(
    status: json["status"],
    states: new List<State>.from(json["states"].map((x) => State.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "states": new List<dynamic>.from(states.map((x) => x.toJson())),
    "message":message,
  };
}

class State {
  String name;
  String code;

  State({
    this.name,
    this.code,
  });

  factory State.fromJson(Map<String, dynamic> json) => new State(
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
  };
}
