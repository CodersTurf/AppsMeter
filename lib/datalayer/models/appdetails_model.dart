

import 'dart:typed_data';

class AppDetailsModel{
  String appName;  
  Uint8List decodedImage;
  bool active;
  String appPackage;
  AppDetailsModel(this.appName,this.decodedImage,[this.appPackage='',this.active=true]);
 
}