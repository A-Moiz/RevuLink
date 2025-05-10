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
            // A rectangle that covers the entire screen and is filled with the custom background color "SplashBG".
            Rectangle()
                .fill(Color("SplashBG"))
            
            // MARK: - App Icon
            // The app icon is displayed as a resizable image in the center with a fixed size.
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
