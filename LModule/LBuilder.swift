//
//  LBuilder.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import Foundation
import AppsFlyerLib
import FirebaseAnalytics
import AdSupport


public final class LBuilder {
    
    static public func make(strUrl: String, campaign: [String: AnyObject]?, deeplink: [String: AnyObject]?) -> URL? {
        if var urlComponents = URLComponents(string: strUrl) {
            urlComponents.queryItems?.removeAll()
            
            let appsflyerUuid = AppsFlyerLib.shared().getAppsFlyerUID()
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            
            if let campaign = campaign {
                let items = campaign.map{ URLQueryItem(name: $0.key, value: "\($0.value)") }
                urlComponents.queryItems?.append(contentsOf: items)
            }
            
            if let deeplink = deeplink {
                let items = deeplink.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                urlComponents.queryItems?.append(contentsOf: items)
            }
            
            urlComponents.queryItems?.append(URLQueryItem(name: "uuid", value: appsflyerUuid))
            urlComponents.queryItems?.append(URLQueryItem(name: "idfa", value: idfa))
            
            if let adid = Analytics.appInstanceID() {
                let queryAdid = URLQueryItem(name: "fbase", value: adid)
                urlComponents.queryItems?.append(queryAdid)
            }
            return urlComponents.url
        } else {
            return nil
        }
    }
    
    static public func cast(_ any: [AnyHashable: Any]) -> [String: AnyObject] {
        var dict: [String: AnyObject] = [:]
        
        for (key, value) in any {
            if let key = key as? String {
                dict[key] = value as AnyObject
            }
        }
        return dict
    }
}


