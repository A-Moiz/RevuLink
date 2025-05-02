//
//  SplashScreenView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("SplashBG"))
            
            Image("app-icon")
                .resizable()
                .frame(width: 400, height: 400)
                .cornerRadius(20)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreenView()
}
