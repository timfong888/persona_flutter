import Flutter
import UIKit
import Persona2

public class SwiftPersonaFlutterPlugin: NSObject, FlutterPlugin, InquiryDelegate {
    let channel: FlutterMethodChannel;
    var inquiry: Inquiry?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "persona_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftPersonaFlutterPlugin(withChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(withChannel channel: FlutterMethodChannel) {
        self.channel = channel;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "init":
                let arguments = call.arguments as! [String: Any]
                
                /// Theme
                var theme: InquiryTheme?
            
                if let value = arguments["theme"] as? [String: Any] {
                    theme = themeFromMap(value)
                }
            
                /// Fields
                var fields: [String: InquiryField]?
            
                if let value = arguments["fields"] as? [String: Any] {
                    fields = fieldsFromMap(value)
                }
                    
                /// Configuration
                var config: InquiryConfiguration?
            
                if let inquiryId = arguments["inquiryId"] as? String {
                    let sessionToken = arguments["sessionToken"] as? String
                    config = InquiryConfiguration(inquiryId: inquiryId, sessionToken: sessionToken, theme: theme);
                }
                else {
                
                    var environment: Environment?
                    
                    // Environment
                    if let env = arguments["environment"] as? String {
                        environment = Environment.init(rawValue: env)
                    }
                    
                    // Fields
                    
                    if let templateVersion = arguments["templateVersion"] as? String {
                        if let accountId = arguments["accountId"] as? String {
                            config = InquiryConfiguration(templateVersion: templateVersion,
                                                          accountId: accountId,
                                                          environment: environment,
                                                          fields: fields,
                                                          theme: theme)
                        }
                        else if let referenceId = arguments["referenceId"] as? String {
                            config = InquiryConfiguration(templateVersion: templateVersion,
                                                          referenceId: referenceId,
                                                          environment: environment,
                                                          fields: fields,
                                                          theme: theme)
                        }
                        else {
                            config = InquiryConfiguration(templateVersion: templateVersion,
                                                          environment: environment,
                                                          fields: fields,
                                                          theme: theme)
                        }
                    }
                    else if let templateId = arguments["templateId"] as? String {
                        if let accountId = arguments["accountId"] as? String {
                            config = InquiryConfiguration(templateId: templateId,
                                                          accountId: accountId,
                                                          environment: environment,
                                                          fields: fields,
                                                          theme: theme)
                        }
                        else if let referenceId = arguments["referenceId"] as? String {
                            config = InquiryConfiguration(templateId: templateId,
                                                          referenceId: referenceId,
                                                          environment: environment,
                                                          fields: fields,
                                                          theme: theme)
                        }
                        else {
                            config = InquiryConfiguration(templateId: templateId,
                                                          environment: environment,
                                                          fields: fields,
                                                          theme: theme)
                        }
                    }
                    
                }
            
                // Inquiry
                if let value = config {
                    inquiry = Inquiry.init(config: value, delegate: self)
                }
            
            case "start":
                if let value = inquiry {
                    let controller = UIApplication.shared.keyWindow!.rootViewController!
                    value.start(from: controller)
                }
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    /// InquiryDelegate
    
    public func inquiryComplete(inquiryId: String, status: String, fields: [String : InquiryField]) {
        let fieldsArray = mapFromFields(fields)
        self.channel.invokeMethod("onComplete", arguments: ["inquiryId": inquiryId, "status" : status, "fields": fieldsArray])
    }
    
    public func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        self.channel.invokeMethod("onCanceled", arguments: ["inquiryId" : inquiryId, "sessionToken": sessionToken])
    }
    
    public func inquiryError(_ error: Error) {
        self.channel.invokeMethod("onError", arguments: ["error" : error.localizedDescription]);
    }
    
    /// Convert Functions
    
    func mapFromFields(_ fields: [String: InquiryField]) -> [String: Any] {
        var result : [String : Any] = [:]
    
        for (key, field) in fields {
            
            switch field {
                case .bool(let value):
                    result[key] = value
                case .string(let value):
                    result[key] = value
                case .int(let value):
                    result[key] = value
                case .float(let value):
                    result[key] = value
                case .date(let value):
                    if let aux = value {
                        result[key] = dateFormatter().string(from: aux)
                    }
                case .datetime(let value):
                    if let aux = value {
                        result[key] = dateFormatter().string(from: aux)
                    }
                default:
                    break
            }
        }
        
        return result
    }
    
    func fieldsFromMap(_ map: [String: Any]) -> [String: InquiryField] {
        var result : [String : InquiryField] = [:]
    
        for (key, value) in map {
            
            switch value {
                case is Bool:
                    result[key] = InquiryField.bool(value as? Bool)
                case is String:
                    result[key] = InquiryField.string(value as? String)
                case is Int:
                    result[key] = InquiryField.int(value as? Int)
                case is Float:
                    result[key] = InquiryField.float(value as? Float)
                case is Date:
                    if let dateString = value as? String {
                        result[key] = InquiryField.date(dateFormatter().date(from: dateString))
                    }
                default:
                    break
            }
        }
        
        return result
    }
    
    func themeFromMap(_ map: [String: Any]) -> InquiryTheme {
        var theme = InquiryTheme();
        ///////////////////////////////////////////////////////////////////////////
        /// General Colors
        ///////////////////////////////////////////////////////////////////////////
        if let backgroundColor = map["backgroundColor"] as? String {
            theme.backgroundColor = UIColor.init(hex: backgroundColor);
        }
        if let primaryColor = map["primaryColor"] as? String {
            theme.primaryColor = UIColor.init(hex: primaryColor);
        }
        if let darkPrimaryColor = map["darkPrimaryColor"] as? String {
            theme.darkPrimaryColor = UIColor.init(hex: darkPrimaryColor);
        }
        if let accentColor = map["accentColor"] as? String {
            theme.accentColor = UIColor.init(hex: accentColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Errors
        ///////////////////////////////////////////////////////////////////////////
        if let errorColor = map["errorColor"] as? String {
            theme.errorColor = UIColor.init(hex: errorColor);
        }
        if let errorFontFamily = map["errorTextFontFamily"] as? String {
            if let errorFont = UIFont(name: errorFontFamily, size: map["errorTextFontSize"] as? CGFloat ?? 18) {
                theme.errorTextFont = errorFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Overlay
        ///////////////////////////////////////////////////////////////////////////
        if let overlayBackgroundColor = map["overlayBackgroundColor"] as? String {
            theme.overlayBackgroundColor = UIColor.init(hex: overlayBackgroundColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Footer
        ///////////////////////////////////////////////////////////////////////////
        if let footerBackgroundColor = map["footerBackgroundColor"] as? String {
            theme.footerBackgroundColor = UIColor.init(hex: footerBackgroundColor);
        }
        if let footerBorderColor = map["footerBorderColor"] as? String {
            theme.footerBorderColor = UIColor.init(hex: footerBorderColor);
        }
        if let footerBorderWidth = map["footerBorderWidth"] as? CGFloat {
            theme.footerBorderWidth = footerBorderWidth;
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Navigation Bar
        ///////////////////////////////////////////////////////////////////////////
        if let navigationBarTextColor = map["navigationBarTextColor"] as? String {
            theme.navigationBarTextColor = UIColor.init(hex: navigationBarTextColor);
        }
        if let navigationBarTextFontFamily = map["navigationBarTextFontFamily"] as? String {
            if let navigationBarTextFont = UIFont(name: navigationBarTextFontFamily, size: map["navigationBarTextFontSize"] as? CGFloat ?? 18) {
                theme.navigationBarTextFont = navigationBarTextFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Title text
        ///////////////////////////////////////////////////////////////////////////
        if let titleTextColor = map["titleTextColor"] as? String {
            theme.titleTextColor = UIColor.init(hex: titleTextColor);
        }
        if let titleTextFontFamily = map["titleTextFontFamily"] as? String {
            if let titleFont = UIFont(name: titleTextFontFamily, size: map["titleTextFontSize"] as? CGFloat ?? 24) {
                theme.titleTextFont = titleFont;
            }
        }
        
        // Body text
        if let bodyTextColor = map["bodyTextColor"] as? String {
            theme.bodyTextColor = UIColor.init(hex: bodyTextColor);
        }
        if let bodyFontFamily = map["bodyTextFontFamily"] as? String {
            if let bodyFont = UIFont(name: bodyFontFamily, size: map["bodyTextFontSize"] as? CGFloat ?? 14) {
                theme.bodyTextFont = bodyFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Footnote
        ///////////////////////////////////////////////////////////////////////////
        if let footnoteTextColor = map["footnoteTextColor"] as? String {
            theme.footnoteTextColor = UIColor.init(hex: footnoteTextColor);
        }
        if let footnoteTextFontFamily = map["footnoteTextFontFamily"] as? String {
            if let footnoteTextFont = UIFont(name: footnoteTextFontFamily, size: map["footnoteTextFontSize"] as? CGFloat ?? 14) {
                theme.footnoteTextFont = footnoteTextFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Form label
        ///////////////////////////////////////////////////////////////////////////
        if let formLabelTextColor = map["formLabelTextColor"] as? String {
            theme.formLabelTextColor = UIColor.init(hex: formLabelTextColor);
        }
        if let formLabelTextFontFamily = map["formLabelTextFontFamily"] as? String {
            if let formLabelTextFont = UIFont(name: formLabelTextFontFamily, size: map["formLabelTextFontSize"] as? CGFloat ?? 14) {
                theme.formLabelTextFont = formLabelTextFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Text field
        ///////////////////////////////////////////////////////////////////////////
        if let textFieldBorderColor = map["textFieldBorderColor"] as? String {
            theme.textFieldBorderColor = UIColor.init(hex: textFieldBorderColor);
        }
        if let textFieldTextColor = map["textFieldTextColor"] as? String {
            theme.textFieldTextColor = UIColor.init(hex: textFieldTextColor);
        }
        if let textFieldBackgroundColor = map["textFieldBackgroundColor"] as? String {
            theme.textFieldBackgroundColor = UIColor.init(hex: textFieldBackgroundColor);
        }
        if let textFieldCornerRadius = map["textFieldCornerRadius"] as? CGFloat {
            theme.textFieldCornerRadius = textFieldCornerRadius;
        }
        if let textFieldFontFamily = map["textFieldFontFamily"] as? String {
            if let textFieldFont = UIFont(name: textFieldFontFamily, size: map["textFieldFontSize"] as? CGFloat ?? 18) {
                theme.textFieldFont = textFieldFont;
            }
        }
        if let textFieldPlaceholderFontFamily = map["textFieldPlaceholderFontFamily"] as? String {
            if let textFieldPlaceholderFont = UIFont(name: textFieldPlaceholderFontFamily, size: map["textFieldPlaceholderFontSize"] as? CGFloat ?? 18) {
                theme.textFieldPlaceholderFont = textFieldPlaceholderFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Picker
        ///////////////////////////////////////////////////////////////////////////
        if let pickerTextColor = map["pickerTextColor"] as? String {
            theme.pickerTextColor = UIColor.init(hex: pickerTextColor);
        }
        if let pickerFontFamily = map["pickerTextFontFamily"] as? String {
            if let pickerFont = UIFont(name: pickerFontFamily, size: map["pickerTextFontSize"] as? CGFloat ?? 18) {
                theme.pickerTextFont = pickerFont;
            }
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Primary Button Properties
        ///////////////////////////////////////////////////////////////////////////
        if let buttonBackgroundColor = map["buttonBackgroundColor"] as? String {
            theme.buttonBackgroundColor = UIColor.init(hex: buttonBackgroundColor);
        }
        if let buttonTouchedBackgroundColor = map["buttonTouchedBackgroundColor"] as? String {
            theme.buttonTouchedBackgroundColor = UIColor.init(hex: buttonTouchedBackgroundColor);
        }
        if let buttonDisabledBackgroundColor = map["buttonDisabledBackgroundColor"] as? String {
            theme.buttonDisabledBackgroundColor = UIColor.init(hex: buttonDisabledBackgroundColor);
        }
        if let buttonTextColor = map["buttonTextColor"] as? String {
            theme.buttonTextColor = UIColor.init(hex: buttonTextColor);
        }
        if let buttonFontFamily = map["buttonFontFamily"] as? String {
            if let buttonFont = UIFont(name: buttonFontFamily, size: map["buttonFontSize"] as? CGFloat ?? 18) {
                theme.buttonFont = buttonFont;
            }
        }
        if let buttonDisabledTextColor = map["buttonDisabledTextColor"] as? String {
            theme.buttonDisabledTextColor = UIColor.init(hex: buttonDisabledTextColor);
        }
        if let buttonShadowColor = map["buttonShadowColor"] as? String {
            let buttonShadowAlpha = map["buttonShadowAlpha"] as? CGFloat;
            theme.buttonShadowColor = UIColor.init(hex: buttonShadowColor).withAlphaComponent(buttonShadowAlpha ?? 0.5);
        }

        let buttonShadowWidth = map["buttonShadowWidth"] as? CGFloat;
        let buttonShadowHeight = map["buttonShadowHeight"] as? CGFloat;

        theme.buttonShadowOffset = CGSize(width:buttonShadowWidth ?? 0, height:buttonShadowHeight ?? 0);
        
        if let buttonShadowRadius = map["buttonShadowRadius"] as? CGFloat {
            theme.buttonShadowRadius = buttonShadowRadius;
        }
        if let buttonCornerRadius = map["buttonCornerRadius"] as? CGFloat {
            theme.buttonCornerRadius = buttonCornerRadius;
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Secondary Button Properties
        ///////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////
        /// Checkbox
        ///////////////////////////////////////////////////////////////////////////
        if let checkboxBackgroundColor = map["checkboxBackgroundColor"] as? String {
            theme.checkboxBackgroundColor = UIColor.init(hex: checkboxBackgroundColor);
        }
        if let checkboxForegroundColor = map["checkboxForegroundColor"] as? String {
            theme.checkboxForegroundColor = UIColor.init(hex: checkboxForegroundColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Table view cell
        ///////////////////////////////////////////////////////////////////////////
        if let selectedCellBackgroundColor = map["selectedCellBackgroundColor"] as? String {
            theme.selectedCellBackgroundColor = UIColor.init(hex: selectedCellBackgroundColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Close button
        ///////////////////////////////////////////////////////////////////////////
        if let closeButtonTintColor = map["closeButtonTintColor"] as? String {
            theme.closeButtonTintColor = UIColor.init(hex: closeButtonTintColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Cancel Button
        ///////////////////////////////////////////////////////////////////////////
        if let cancelButtonBackgroundColor = map["cancelButtonBackgroundColor"] as? String {
            theme.cancelButtonBackgroundColor = UIColor.init(hex: cancelButtonBackgroundColor);
        }
        if let cancelButtonTextColor = map["cancelButtonTextColor"] as? String {
            theme.cancelButtonTextColor = UIColor.init(hex: cancelButtonTextColor);
        }
        if let cancelButtonAlternateBackgroundColor = map["cancelButtonAlternateBackgroundColor"] as? String {
            theme.cancelButtonAlternateBackgroundColor = UIColor.init(hex: cancelButtonAlternateBackgroundColor);
        }
        if let cancelButtonAlternateTextColor = map["cancelButtonAlternateTextColor"] as? String {
            theme.cancelButtonAlternateTextColor = UIColor.init(hex: cancelButtonAlternateTextColor);
        }
        if let cancelButtonTextColor = map["cancelButtonTextColor"] as? String {
            theme.cancelButtonTextColor = UIColor.init(hex: cancelButtonTextColor);
        }
        if let cancelButtonShadowColor = map["cancelButtonShadowColor"] as? String {
            theme.cancelButtonShadowColor = UIColor.init(hex: cancelButtonShadowColor);
        }
        if let cancelButtonShadowRadius = map["cancelButtonShadowRadius"] as? CGFloat {
            theme.cancelButtonShadowRadius = cancelButtonShadowRadius;
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Separator
        ///////////////////////////////////////////////////////////////////////////
        if let separatorColor = map["separatorColor"] as? String {
            theme.separatorColor = UIColor.init(hex: separatorColor);
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Miscellaneous
        ///////////////////////////////////////////////////////////////////////////
        if let showGovernmentIdIcons = map["showGovernmentIdIcons"] as? Bool {
            theme.showGovernmentIdIcons = showGovernmentIdIcons;
        }
        ///////////////////////////////////////////////////////////////////////////
        /// Camera
        ///////////////////////////////////////////////////////////////////////////
        if let cameraInstructionsTextColor = map["cameraInstructionsTextColor"] as? String {
            theme.cameraInstructionsTextColor = UIColor.init(hex: cameraInstructionsTextColor);
        }
        if let cameraButtonBackgroundColor = map["cameraButtonBackgroundColor"] as? String {
            theme.cameraButtonBackgroundColor = UIColor.init(hex: cameraButtonBackgroundColor);
        }
        if let cameraButtonTextColor = map["cameraButtonTextColor"] as? String {
            theme.cameraButtonTextColor = UIColor.init(hex: cameraButtonTextColor);
        }
        if let cameraButtonAlternateBackgroundColor = map["cameraButtonAlternateBackgroundColor"] as? String {
            theme.cameraButtonAlternateBackgroundColor = UIColor.init(hex: cameraButtonAlternateBackgroundColor);
        }
        if let cameraButtonAlternateTextColor = map["cameraButtonAlternateTextColor"] as? String {
            theme.cameraButtonAlternateTextColor = UIColor.init(hex: cameraButtonAlternateTextColor);
        }
        if let cameraHintTextColor = map["cameraHintTextColor"] as? String {
            theme.cameraHintTextColor = UIColor.init(hex: cameraHintTextColor);
        }
        if let cameraGuideHintTextColor = map["cameraGuideHintTextColor"] as? String {
            theme.cameraGuideHintTextColor = UIColor.init(hex: cameraGuideHintTextColor);
        }
        if let cameraGuideCornersColor = map["cameraGuideCornersColor"] as? String {
            theme.cameraGuideCornersColor = UIColor.init(hex: cameraGuideCornersColor);
        }
        
        return theme;
    }
    
    /// Helpers
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter;
    }
}

extension UIColor {
    public convenience init(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        self.init()
    }
}
