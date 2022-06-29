<<<<<<< HEAD
## 2.1.1

* Fix typedefs export.
* Fix birthday serialization.
* Upgraded iOS SDK to 1.1.25.
* Upgraded Android SDK to 1.1.19.

## 2.1.0

* BREAKING CHANGE: "Inquiry" class is now "PersonaInquiry" with only static methods (see example provided)
* BREAKING CHANGE: Renamed all callbacks with "Inquiry" prefix (e.g. SuccessCallback -> InquirySuccessCallback)
* BREAKING CHANGE: Renamed the following iOS theme properties: titleFont*, bodyFont*, errorFont*, pickerFont* -> titleTextFont*, bodyTextFont*, errorTextFont*, pickerTextFont*.
* Added new iOS theme properties: footnoteTextFontFamily, footnoteTextFontSize, formLabelTextFontFamily, formLabelTextFontSize
* Integrated plugin_platform_interface dependency.
* Upgraded iOS SDK to 1.1.22.
* Upgraded Android SDK to 1.1.15.

## 2.0.4

* Added new theme properties: cancelButtonAlternateTextColor, cancelButtonAlternateBackgroundColor, cancelButtonTextColor
* Upgraded iOS SDK to 1.1.11.
* Upgraded Android SDK to 1.1.4.

## 2.0.3

* Added new theme properties.
* Upgraded iOS SDK to 1.1.7.
* Upgraded Android SDK to 1.1.3.

## 2.0.2

* Improved iOS theming. Thank you @tomaash.

## 2.0.1

* Upgraded iOS SDK to 1.1.4
 
## 2.0.0

* BREAKING CHANGE: Added InquiryConfiguration to Inquiry object
* Fix typo on InquiryVerificationType 
* Null-safety support
* Added type unknown to InquiryVerificationStatus and InquiryVerificationType

## 1.2.0

* Added InquiryTheme to support ios theming. Thank you @tomaash
* Added support for android theme via styles.xml. Thank you @tomaash
* Upgraded iOS SDK to 1.1.3
* Added additionalFields support on iOS and Android.

## 1.1.0+1

* Fix intl dependency version
* Minor fixes

## 1.1.0

* Upgraded iOS SDK to 1.0.6.
* Upgraded Android SDK to 1.0.11.
* Added support for Fields in Inquiry class.
* Added InquiryVerificationStatus, InquiryVerificationType, InquiryName and InquiryAddress.
* Changed PersonaEnvironment to InquiryEnvironment.

## 1.0.6

* Updated Persona SDK to version 1.0.0

## 1.0.5

* Updated Persona SDK to version 0.12.4

## 1.0.4

* Updated Persona SDK to version 0.11.0

## 1.0.3

* Bug fix: onSuccess and onFailed not being called correctly

## 1.0.2

* Bug fix: environment not passed when inquiry initiated with template id. 

## 1.0.1

* Changed integration guide.

## 1.0.0

* Initial release.
=======
## 3.0.0-beta.0

* Initial release of native v2 SDKs implementation
>>>>>>> 9f48fbd924ecdfa76d945677fb1a5f5d359c9b57
