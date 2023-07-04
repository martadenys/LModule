//
//  LModels.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import Foundation


// MARK: - TRApplicationDelegate
public protocol LDelegate {
    var trService: TRService! { get set }
    var trDelegate: LAppsDelegateProtocol? { get set }
}

// MARK: - TRAppsFlyerDelegate
public protocol LAppsDelegateProtocol: AnyObject {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any])
    func onConversionDataFail(_ error: Error)
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any])
    func onAppOpenAttributionFailure(_ error: Error)
}

// MARK: - Loading Status
public enum LLoadViewState {
    case content
    case loading
    case webContent(_ url: URL)
}

// MARK: - Keys
public enum LConstKey: String {
    case destinationUR = "l_open_url"
}

