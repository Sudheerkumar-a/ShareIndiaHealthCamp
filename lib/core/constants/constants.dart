import 'dart:ui';

const String fontFamilyEN = "Poppins";
const String fontFamilyAR = "AR_GE_SS";
bool isSelectedLocalEn = true;
String userToken = '';
bool showSplash = true;
bool isServicesLoaded = false;
String appVersion = '';
Size screenSize = const Size(550, 730);
int selectedSideBarIndex = 0;
const nameRegExp = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
const mobileRegExp = r'^[6-9]\d{9}$';
const numberRegExp = r'^[0-9]*$';
