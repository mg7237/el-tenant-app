import 'dart:io';

class UpdateDocumentRequest{
  String documentType='2';
  File documentFile;

  UpdateDocumentRequest({this.documentType, this.documentFile});
}