class ExtendOrTerminateRequest {
  String propertyId;
  String extendOrTerminate;

  Map<String, dynamic> toMap() => {
        "propertyId": propertyId,
        "extendOrTerminate": extendOrTerminate,
      };
}
