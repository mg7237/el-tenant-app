import 'dart:io';

import 'package:async/async.dart';
import 'package:easyleases_tenant/api_client/api_client.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/model/EditProfileRequest.dart';
import 'package:easyleases_tenant/model/agreements_response.dart';
import 'package:easyleases_tenant/model/comment_request.dart';
import 'package:easyleases_tenant/model/comment_response.dart';
import 'package:easyleases_tenant/model/dashboard_request.dart';
import 'package:easyleases_tenant/model/dashboard_response.dart';
import 'package:easyleases_tenant/model/delete_attachment_response.dart';
import 'package:easyleases_tenant/model/delete_request_response.dart';
import 'package:easyleases_tenant/model/delete_user_document_response.dart';
import 'package:easyleases_tenant/model/documents_list_response.dart' as documentListResponse;
import 'package:easyleases_tenant/model/documents_list_response.dart';
import 'package:easyleases_tenant/model/download_or_email_request.dart';
import 'package:easyleases_tenant/model/download_or_email_response.dart';
import 'package:easyleases_tenant/model/due_payment_response.dart';
import 'package:easyleases_tenant/model/edit_profile_response.dart'
    as editProfileResponse;
import 'package:easyleases_tenant/model/edit_profile_response.dart';
import 'package:easyleases_tenant/model/extend_or_terminate_request.dart';
import 'package:easyleases_tenant/model/extend_or_terminate_response.dart';
import 'package:easyleases_tenant/model/forgot_pass_init_request.dart';
import 'package:easyleases_tenant/model/forgot_pass_request.dart';
import 'package:easyleases_tenant/model/forgot_pass_response.dart';
import 'package:easyleases_tenant/model/get_bank_details_response.dart'as getBankDetailsResponse;
import 'package:easyleases_tenant/model/get_bank_details_response.dart';
import 'package:easyleases_tenant/model/get_emergency_details_response.dart'as getEmergencyDetailsResponse;
import 'package:easyleases_tenant/model/get_emergency_details_response.dart';
import 'package:easyleases_tenant/model/get_employment_response.dart' as employmentResponse;
import 'package:easyleases_tenant/model/get_employment_response.dart';
import 'package:easyleases_tenant/model/get_support_person_response.dart' as getSupportPersonResponse;
import 'package:easyleases_tenant/model/get_support_person_response.dart';
import 'package:easyleases_tenant/model/get_user_documents_response.dart' as getUserDocumentsResponse;
import 'package:easyleases_tenant/model/get_user_documents_response.dart';
import 'package:easyleases_tenant/model/login_request_model.dart';
import 'package:easyleases_tenant/model/login_response.dart';
import 'package:easyleases_tenant/model/otp_request_model.dart';
import 'package:easyleases_tenant/model/otp_response.dart';
import 'package:easyleases_tenant/model/property_list_response.dart';
import 'package:easyleases_tenant/model/request_type_list_response.dart';
import 'package:easyleases_tenant/model/reverse_payment_response.dart';
import 'package:easyleases_tenant/model/service_detail_response.dart';
import 'package:easyleases_tenant/model/service_request_list_response.dart';
import 'package:easyleases_tenant/model/state_list_response.dart'
    as stateListResponse;
import 'package:easyleases_tenant/model/state_list_response.dart';
import 'package:easyleases_tenant/model/status_list_response.dart';
import 'package:easyleases_tenant/model/update_bank_details_request.dart';
import 'package:easyleases_tenant/model/update_bank_details_response.dart' as bankDetailsResponse;
import 'package:easyleases_tenant/model/update_bank_details_response.dart';
import 'package:easyleases_tenant/model/update_emergency_details_request.dart';
import 'package:easyleases_tenant/model/update_emergency_details_response.dart';
import 'package:easyleases_tenant/model/update_employment_details-request.dart';
import 'package:easyleases_tenant/model/update_employment_details_response.dart' as updateEmploymentResponse;
import 'package:easyleases_tenant/model/update_employment_details_response.dart';
import 'package:easyleases_tenant/model/update_fcm_response.dart';
import 'package:easyleases_tenant/model/update_fcm_token_request.dart';
import 'package:easyleases_tenant/model/update_profile_request.dart';
import 'package:easyleases_tenant/model/update_profile_response.dart';
import 'package:easyleases_tenant/model/update_user_document_request.dart';
import 'package:easyleases_tenant/model/update_user_document_response.dart';
import 'package:easyleases_tenant/model/user_profile_response.dart';
import 'package:easyleases_tenant/screen/service_request/add_service_request_page.dart';
import 'package:easyleases_tenant/screen/service_request/edit_service_request_page.dart';
import 'package:easyleases_tenant/util/preference_connector.dart';
import 'package:http/http.dart' as http;
import 'package:easyleases_tenant/model/login_response.dart' as loginResponse;
import 'package:easyleases_tenant/model/dashboard_response.dart'
    as dashboardResponse;
import 'package:easyleases_tenant/model/user_profile_response.dart'
    as userProfileResponse;
import 'package:easyleases_tenant/model/update_profile_response.dart'
    as updateProfileResponse;
import 'package:easyleases_tenant/model/all_responses.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Repository {
  ApiClient _apiClient = ApiClient();
  static Repository _instance;

  factory Repository() => _instance ??= Repository._();

  Repository._();

  // common get request
  Future<String> getRequest(String method) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.getMethod(
      ApiClient.BASE_URL + method,
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common post request
  Future<String> postRequest(String method, var body) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.postMethod(
      method,
      body.toMap(),
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    print(response.body.toString());
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common patch multipart request
  Future<String> postRequestMultipart(var request) async {
    http.Response response = await _apiClient.postMethodMultipart(request);
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common patch request
  Future<String> patchRequest(String method, var body) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.patchMethod(
      method,
      body.toMap(),
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common patch multipart request
  Future<String> patchRequestMultipart(var editProfileRequest) async {
    http.Response response =
        await _apiClient.patchMethodMultipart(editProfileRequest);
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common get request
  Future<String> deleteRequest(String method) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.deleteMethod(
      ApiClient.BASE_URL + method,
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  Future<LoginResponse> login(LoginRequestModel model) async {
    String response = await postRequest("/users/login", model);
    if (response != null && response.isNotEmpty) {
      return loginResponse.loginResponseFromJson(response);
    } else {
      return null;
    }
  }
  Future<OtpResponse> generateOtp(OtpRequestModel model) async {
    String response = await postRequest("/users/generateotp", model);
    if (response != null && response.isNotEmpty) {
      return otpResponseFromJson(response);
    } else {
      return null;
    }
  }
  Future<ForgotPassInitResponse> forgotPasswordInit(
      ForgotPasswordInitRequest model) async {
    String response = await postRequest("/users/changepasswordinit", model);
    if (response != null && response.isNotEmpty) {
      return forgotPassInitResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ForgotPassResponse> forgotPassword(ForgotPasswordRequest model) async {
    String response = await patchRequest("/users/changepassword", model);
    if (response != null && response.isNotEmpty) {
      return forgotPassResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<DashboardResponse> getDashboard(String tenantId) async {
    String response = await getRequest("/tenant/dashboard");
    if (response != null && response.isNotEmpty) {
      return dashboardResponse.dashboardResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<UserProfileResponse> getProfile(String tenantId) async {
    String response = await getRequest("/tenant/profile");
    if (response != null && response.isNotEmpty) {
      return userProfileResponse.userProfileResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<UpdateProfileResponse> updateProfileData(
      String tenantId, UpdateProfileRequest model) async {
    String response = await postRequest("tenant/updateProfile", model);
    if (response != null && response.isNotEmpty) {
      return updateProfileResponse.updateProfileResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<EditProfileResponse> editProfileData(EditProfileRequest _data) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse(ApiClient.BASE_URL + "/tenant/profile"));

    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['name'] = _data.name;
    request.fields['phoneNumber'] = _data.phone;
    request.fields['unitNo'] = "fds";
    request.fields['addressLine1'] = _data.addLine1;
    request.fields['addressLine2'] = _data.addLine2;
    request.fields['city'] = _data.city;
    request.fields['stateCode'] = _data.stateCode;
    request.fields['pincode'] = _data.pinCode;

    if (_data.profilePic != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.profilePic.openRead()));
      var length = await _data.profilePic.length();
      var multipartFile = new http.MultipartFile('profilePic', stream, length,
          filename: basename(_data.profilePic.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "x-api-key": x_api_key,
    });

    String response = await patchRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return editProfileResponse.editProfileResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<StateListResponse> getStateList() async {
    String response = await getRequest("/reference/statelist");
    if (response != null && response.isNotEmpty) {
      return stateListResponse.stateListResponseFromJson(response);
    } else {
      return null;
    }
  }

/*  Future<StateListResponse> getStateList() async {
    String response = await getRequest("/province/list");
    if (response != null && response.isNotEmpty) {
      return stateListResponse.stateListResponseFromJson(response);
    } else {
      return null;
    }
  }*/


  Future<PastPaymentResponse> getPastPaymentList(String userId) async {
    String response = await getRequest("/tenant/pastpayments");
    if (response != null && response.isNotEmpty) {
      return pastPaymentResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<DuePaymentResponse> getDuePaymentList(String userId) async {
    String response = await getRequest("/tenant/paymentsdue");
    if (response != null && response.isNotEmpty) {
      return pastDueResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ReversePaymentResponse> reverseNEFT(String rowId) async {
    LoginRequestModel model = LoginRequestModel();
    String response = await postRequest('/tenant/reverseneft/$rowId', model);
    if (response != null && response.isNotEmpty) {
      return reversePaymentResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<AgreementResponse> getAgreementsList(String userId) async {
    String response = await getRequest("/tenant/agreements");
    if (response != null && response.isNotEmpty) {
      return agreementResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ExtendOrTerminateResponse> extendOrTerminate(
      String userId, ExtendOrTerminateRequest model) async {
    String response =
        await postRequest("/tenant/agreementextendterminate", model);
    if (response != null && response.isNotEmpty) {
      return extendOrTerminateResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<DownloadOrEmailResponse> downloadOrEmail(
      String userId, DownloadOrEmailRequest model) async {
    String response =
        await postRequest("/tenant/paymentreceipt/$userId", model);
    if (response != null && response.isNotEmpty) {
      return downloadOrEmailResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ServiceRequestResponse> getServiceRequestList() async {
    String response = await getRequest("/servicerequest/srlist");
    if (response != null && response.isNotEmpty) {
      return serviceRequestResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ServiceDetailResponse> getServiceDetails(String rowId) async {
    String response = await getRequest("/servicerequest/srdetail/$rowId");
    if (response != null && response.isNotEmpty) {
      return serviceDetailResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<PropertyListResponse> getPropertyList() async {
    String response = await getRequest("/servicerequest/propertylist");
    if (response != null && response.isNotEmpty) {
      return propertyListResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<RequestTypeListResponse> getRequestTypeList() async {
    String response = await getRequest("/servicerequest/typeslist");
    if (response != null && response.isNotEmpty) {
      return requestTypeListResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<StatusListResponse> getStatusList() async {
    String response = await getRequest("/servicerequest/statuslist");
    if (response != null && response.isNotEmpty) {
      return statusListResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<DeleteRequestResponse> deleteServiceRequestById(
      String serviceId) async {
    String response =
        await deleteRequest("/servicerequest/deleterequest/$serviceId");
    if (response != null && response.isNotEmpty) {
      return deleteRequestResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<DeleteAttachmentResponse> deleteAttachment(String attachmentId) async {
    String response =
        await deleteRequest("/servicerequest/deleteattachment/$attachmentId");
    if (response != null && response.isNotEmpty) {
      return deleteAttachmentResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<CommentResponse> comment(String requestId, CommentRequest model) async {
    String response =
        await postRequest("/servicerequest/createcomment/$requestId", model);
    if (response != null && response.isNotEmpty) {
      return commentResponseFromJson(response);
    } else {
      return null;
    }
  }


  Future<CommentResponse> addServiceRequest(AddServiceModel _data) async {
    var request = new http.MultipartRequest("POST",
        Uri.parse(ApiClient.BASE_URL + "/servicerequest/createrequest"));

    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['requestTitle'] = _data.title;
    request.fields['requestDescription'] = _data.description;
    request.fields['requestStatus'] = '1';
    request.fields['requestType'] = _data.requestTypeId;
    request.fields['propertyId'] = _data.propertyId;

    if(_data.files != null && _data.files.length !=0) {
      List<http.MultipartFile> multiFiles = List<http.MultipartFile>();

      for (int i = 0; i < _data.files.length; i++) {
        multiFiles.add(await http.MultipartFile.fromPath(
            "attachments[$i]", _data.files[i].path,
            contentType: mediaTypeImage));
      }

      request.files.addAll(multiFiles);
    }

    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "x-api-key": x_api_key,
    });

    String response = await postRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return commentResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<CommentResponse> addAttachmentRequest(String rowId, File file) async {
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(
            ApiClient.BASE_URL + "/servicerequest/createattachment/$rowId"));
    MediaType mediaTypeImage = MediaType.parse("image/png");

    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFile = new http.MultipartFile('attachment', stream, length,
        filename: basename(file.path), contentType: mediaTypeImage);

    request.files.add(multipartFile);

    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "x-api-key": x_api_key,
    });

    String response = await postRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return commentResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<CommentResponse> updateServiceRequest(
      String requestId, EditServiceModel model) async {
    String response =
        await postRequest("/servicerequest/updaterequest/$requestId", model);
    if (response != null && response.isNotEmpty) {
      return commentResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<File> download(String directory) async {
    http.Response response = await _apiClient.getMethod(
        'http://13.233.103.136/receipt/Payment_Receipt_2325.pdf', {});
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file =
    await File(directory).writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<UpdateBankDetailsResponse> updateBankDetails(UpdateBankDetailsRequest _data) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse(ApiClient.BASE_URL + "/tenant/updatebankdetails"));

    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['accountHolderName'] = _data.accountHolderName;
    request.fields['PAN'] = _data.PAN;
    request.fields['bankName'] = _data.bankName;
    request.fields['branchName'] = _data.branchName;
    request.fields['IFSC'] = _data.IFSC;
    request.fields['accountNumber'] = _data.accountNumber;
    print('Update Bank Details Request');
    print(request.fields);
    if (_data.cancelledChequePic != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.cancelledChequePic.openRead()));
      var length = await _data.cancelledChequePic.length();
      var multipartFile = new http.MultipartFile('cancelledCheque', stream, length,
          filename: basename(_data.cancelledChequePic.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }
    String deviceId =
    await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
    await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      /*"Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",*/
      "x-api-key": x_api_key,
    });

    String response = await patchRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      print(response);
      return bankDetailsResponse.updateBankDetailsResponseFromJson(response);
    } else {
      print(response);
      return null;
    }
  }

  Future<GetBankDetailsResponse> getBankDetails() async {
    String response = await getRequest("/tenant/getbankdetails");
    if (response != null && response.isNotEmpty) {
      return getBankDetailsResponse.getBankDetailsResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<EmploymentResponse> getEmploymentDetails() async {
    String response = await getRequest("/tenant/getemploymentdetails");
    if (response != null && response.isNotEmpty) {
      return employmentResponse.employmentResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<UpdateEmploymentDetailsResponse> updateEmploymentDetails(UpdateEmploymentDetailsRequest _data) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse(ApiClient.BASE_URL + "/tenant/updateemploymentdetails"));
    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['employerName'] = _data.employerName;
    request.fields['employeeId'] = _data.employeeId;
    request.fields['employerEmail'] = _data.employerEmail;
    request.fields['employmentStartDate'] = _data.employmentStartDate;
    if (_data.employmentProof != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.employmentProof.openRead()));
      var length = await _data.employmentProof.length();
      var multipartFile = new http.MultipartFile('employmentProof', stream, length,
          filename: basename(_data.employmentProof.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }
    String deviceId =
    await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
    await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      /*"Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",*/
      "x-api-key": x_api_key,
    });

    String response = await patchRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return updateEmploymentResponse.updateEmploymentDetailsResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<GetEmergencyDetailsResponse> getEmergencyDetails() async {
    String response = await getRequest("/tenant/getemergencydetails");
    if (response != null && response.isNotEmpty) {
      return getEmergencyDetailsResponse.getEmergencyDetailsResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<UpdateEmergencyDetailsResponse> updateEmergencyDetails(UpdateEmergencyDetailsRequest model) async {
    String response =
    await postRequest("/tenant/updateemergencydetails/", model);
    if (response != null && response.isNotEmpty) {
      return updateEmergencyDetailsResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<DocumentListResponse> getDocumentsType() async {

    String response = await getRequest("/reference/prooftypes");
    if (response != null && response.isNotEmpty) {
      return documentListResponse.documentListResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<GetUserDocumentsResponse> getUserDocuments() async {
    String response = await getRequest("/users/userdocuments");
    if (response != null && response.isNotEmpty) {
      return getUserDocumentsResponse.getUserDocumentsResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<UpdateUserDocumentsResponse> updateUserDocuments(UpdateDocumentRequest _data) async {
    var request = new http.MultipartRequest("POST",
        Uri.parse(ApiClient.BASE_URL + "/users/createdocument"));

    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['documentType'] = _data.documentType;
    if (_data.documentFile != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.documentFile.openRead()));
      var length = await _data.documentFile.length();
      var multipartFile = new http.MultipartFile('documentFile', stream, length,
          filename: basename(_data.documentFile.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }
    String deviceId =
    await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
    await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "x-api-key": x_api_key,
    });

    String response = await postRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return updateUserDocumentsResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<DeleteUserDocumentsResponse> deleteUserDocument(int documentID) async {
    String response =
    await deleteRequest("/users/deletedocument/$documentID");
    if (response != null && response.isNotEmpty) {
      return deleteUserDocumentsResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<GetSupportPersonResponse> getSupportPerson() async {
    String response = await getRequest("/users/supportperson");
    if (response != null && response.isNotEmpty) {
      return getSupportPersonResponse.getSupportPersonResponseFromJson(response);
    } else {
      return null;
    }
  }


  Future<UpdateFcmResponse> updateFcm(UpdateFcmTokenRequest model) async {
    String response =
    await postRequest("/users/updatefcm", model);
    if (response != null && response.isNotEmpty) {
      return updateFcmResponseFromJson(response);
    } else {
      return null;
    }
  }


}
