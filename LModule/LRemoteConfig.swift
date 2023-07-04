//
//  LRemoteConfig.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import Foundation
import FirebaseRemoteConfig
import Combine

@available(iOS 14.0, *)
public class LRemoteConfig {
    
    public init() {}
        
    public func fetchRemoteConfigValue<T>(key: String, defaultValue: T) -> AnyPublisher<T, Never> {
        let remoteConfig = RemoteConfig.remoteConfig()
        let subject = PassthroughSubject<T, Never>()

        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            if status == .success {
                remoteConfig.activate(completion: { [weak self] _, _ in
                    
                    let value: T = self?.convertToType(
                        defaultValue: defaultValue,
                        configValue: remoteConfig.configValue(forKey: key)
                    ) ?? defaultValue
                    
                    subject.send(value)
                    subject.send(completion: .finished)
                })
            } else {
                subject.send(defaultValue)
                subject.send(completion: .finished)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    private func convertToType<T>(defaultValue: T, configValue: RemoteConfigValue) -> T {
        let value: T
        switch defaultValue {
        case is String:
            value = (configValue.stringValue as? T) ?? defaultValue
        case is Int:
            value = (configValue.numberValue.intValue as? T) ?? defaultValue
        case is Double:
            value = (configValue.numberValue.doubleValue as? T) ?? defaultValue
        case is Bool:
            value = (configValue.boolValue as? T) ?? defaultValue
        default:
            value = defaultValue
        }
        return value
    }
}


