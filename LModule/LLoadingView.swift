//
//  LLoadingView.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import SwiftUI

@available(iOS 14.0, *)
public struct LLoadingView: View {
    
    public let backgroundColor: Color
    public let foregroundColor: Color
    public let imageName: String?
    public let text: String
    
    public init(
        backgroundColor: Color? = nil,
        text: String = "",
        foregroundColor: Color? = nil,
        imageName: String? = nil
    ) {
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            if #available(iOS 15.0, *) {
                self.backgroundColor = Color(uiColor: .systemBackground)
            } else {
                self.backgroundColor = Color.black
            }
        }
        
        if let foregroundColor = foregroundColor {
            self.foregroundColor = foregroundColor
        } else {
            if #available(iOS 15.0, *) {
                self.foregroundColor = Color(uiColor: .label)
            } else {
                self.foregroundColor = Color.white
            }
        }
        self.imageName = imageName
        self.text = text
    }
    
    public var body: some View {
        ZStack {
            backgroundColor
            
            VStack(alignment: .center, spacing: 40) {
                Spacer()
                imageLogoView()
                
                textView()
                loaderView()
                Spacer()
            }
            .offset(y: imageName == nil ? 0 : -50)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func textView() -> some View {
        Text(text)
            .foregroundColor(foregroundColor)
            .font(.title3)
    }
    
    @ViewBuilder
    private func imageLogoView() -> some View {
        if let image = imageName {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width - 40)
        }
    }
    
    private func loaderView() -> some View {
        HStack {
            Spacer()
            if #available(iOS 16.0, *) {
                ProgressView()
                    .scaleEffect(2)
                    .tint(foregroundColor)
            } else {
                ProgressView()
                    .scaleEffect(2)
                    .foregroundColor(foregroundColor)
            }
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
struct TRSplashView_Previews: PreviewProvider {
    static var previews: some View {
        LLoadingView()
    }
}


