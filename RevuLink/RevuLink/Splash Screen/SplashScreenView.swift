//
//  SplashScreenView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import SwiftUI

// MARK: - SplashScreenView
/// A view that displays the splash screen with a background and an app icon.
struct SplashScreenView: View {
    var body: some View {
        ZStack {
            // MARK: - Background
            Rectangle()
                .fill(Color("SplashBG"))
            
            // MARK: - App Icon
            Image("app-icon")
                .resizable()
                .frame(width: 400, height: 400)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreenView()
}
