//
//  TRService.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import UIKit
import FirebaseCore
import OneSignal
import AppsFlyerLib

public class TRService {
    
    public weak var trDelegate: LAppsDelegateProtocol?
    public weak var appsFlyerDelegate: NSObject?
        
    /// init TRService
    /// TRDelegate should be putted in AppDelegate
    public init(trDelegate: LAppsDelegateProtocol?) {
        self.trDelegate = trDelegate
    }
    
    /// init Ask for notifications via OneSignal
    public func oneSignalPromptForPushNotifications(_ userResponse: ((Bool) -> ())?) {
        OneSignal.promptForPushNotifications(userResponse: userResponse)
    }
    
    /// init AppsFlyer
    public func appsFlyerInit(
        devKey: String,
        appID: String,
        waitForATT: Double?,
        delegate: NSObject?
    ) {
        AppsFlyerLib.shared().appsFlyerDevKey = devKey
        AppsFlyerLib.shared().appleAppID = appID
        AppsFlyerLib.shared().delegate = (delegate as! any AppsFlyerLibDelegate)
        
        if let seconds = waitForATT {
            AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: seconds)
        }
    }
    
    /// init start AppsFlyer
    func startAppsFlyer(completion: (([String : Any]?, Error?) -> Void)? = nil) {
        AppsFlyerLib.shared().start(completionHandler: completion)
    }
    
    /// init Handle open url via AppsFlyer
    public func appsFlyerHandleOpen(url: URL) {
        AppsFlyerLib.shared().handleOpen(url)
    }
    
    /// appsFlyer continue
    public func appsFlyerContinue(
        userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: { (restorableObjects: [Any]?) in
            if let restorableObjects = restorableObjects as? [UIUserActivityRestoring] {
                restorationHandler(restorableObjects)
            } else {
                restorationHandler(nil)
            }
        })
    }
}

