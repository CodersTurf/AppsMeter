

import 'package:AppsMeter/datalayer/models/appdetails_model.dart';

class AppUsageModel extends AppDetailsModel{

  double usageSeconds=0;    
  double totalPercentUSed;  
  AppUsageModel(appName,this.usageSeconds,decodedImage,[appPackage='']) : super(appName,decodedImage,appPackage)
  {
    
    this.totalPercentUSed=0;
    
  }
}