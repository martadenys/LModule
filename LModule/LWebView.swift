//
//  LWebView.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import SwiftUI

@available(iOS 14.0, *)
public struct LWebView: View {
    
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    @State private var isLoading: Bool = false
    
    public var body: some View {
        ZStack {
            contentView()
            loadingView()
        }
    }
}

@available(iOS 14.0, *)
extension LWebView {
    public func contentView() -> some View {
        LWebViewRepresentation(url: url, loadingInProgress: $isLoading)
    }
    
    @ViewBuilder
    public func loadingView() -> some View {
        if isLoading {
            Rectangle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .cornerRadius(5)
                .shadow(color: .gray.opacity(0.5), radius: 5)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .frame(width: 30, height: 30)
        }
    }
}


