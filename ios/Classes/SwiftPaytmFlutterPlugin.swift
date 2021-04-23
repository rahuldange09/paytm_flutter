import Flutter
import UIKit

public class SwiftPaytmFlutterPlugin: NSObject, FlutterPlugin {
  
    var flutterCallbackResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "paytm_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftPaytmFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)

  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Note: this method is invoked on the UI thread.
        self.flutterCallbackResult = result
        guard  call.method == "startTransaction"
        else {
            result(FlutterMethodNotImplemented)
            return
        }
        if let parameters = call.arguments as? [String: Any] {
            let plugin = AllInOneSDKSwiftWrapper()
            plugin.startTransaction(parameters: parameters, callBack: result) //MARK:calling method of AllInOneSwiftSDKWrapper with the callback result to be called from the wrapper
        }
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let dict = self.separateDeeplinkParamsIn(url: url.absoluteString, byRemovingParams: nil)
        // print("################################ application $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        // print(dict)
        if dict["response"] != nil && dict["response"]!.count > 0{
            self.flutterCallbackResult?(dict)
        }else{
            self.flutterCallbackResult?(FlutterError(code: String("FAILED"),
                                                     message: dict["status"] ?? "Transaction failed",
                                                     details: dict))
        }
        
        return true
    }
    
    
    func separateDeeplinkParamsIn(url: String?, byRemovingParams rparams: [String]?)  -> [String: String] {
        guard let url = url else {
            return [String : String]()
        }
        /// This url gets mutated until the end. The approach is working fine in current scenario. May need a revisit.
        var urlString = stringByRemovingDeeplinkSymbolsIn(url: url)
        var paramList = [String : String]()
        let pList = urlString.components(separatedBy: CharacterSet.init(charactersIn: "&?//"))
        for keyvaluePair in pList {
            let info = keyvaluePair.components(separatedBy: CharacterSet.init(charactersIn: "="))
            if let fst = info.first , let lst = info.last, info.count == 2 {
                paramList[fst] = lst.removingPercentEncoding
                if let rparams = rparams, rparams.contains(info.first!) {
                    urlString = urlString.replacingOccurrences(of: keyvaluePair + "&", with: "")
                    //Please dont interchage the order
                    urlString = urlString.replacingOccurrences(of: keyvaluePair, with: "")
                }
            }
        }
        if let trimmedURL = pList.first {
            paramList["trimmedurl"] = trimmedURL
        }
        return paramList
    }
    
    func  stringByRemovingDeeplinkSymbolsIn(url: String) -> String {
        var urlString = url.replacingOccurrences(of: "$", with: "&")
        /// This may need a revisit. This is doing more than just removing the deeplink symbol.
        if let range = urlString.range(of: "&"), urlString.contains("?") == false{
            urlString = urlString.replacingCharacters(in: range, with: "?")
        }
        return urlString
    }
    
}

