//
//  LNotifications.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import UIKit
import OneSignal

public class LNotifications {
    
    public static func didReceiveNotificationExtensionRequest(
        request:UNNotificationRequest,
        content:UNMutableNotificationContent,
        contentHandler:@escaping ((UNNotificationContent) -> Void))
    {
        OneSignal.didReceiveNotificationExtensionRequest(
            request, with:content,
            withContentHandler:contentHandler
        )
    }
    
    public static func serviceExtensionTimeWillExpireRequest(
        request:UNNotificationRequest,
        content:UNMutableNotificationContent)
    {
        OneSignal.serviceExtensionTimeWillExpireRequest(
            request,
            with: content
        )
    }
}


