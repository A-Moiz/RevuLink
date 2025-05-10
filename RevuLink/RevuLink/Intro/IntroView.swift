//
//  IntroView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 09/05/2025.
//

import SwiftUI
import AVKit
// MARK: - IntroView
/// A simple introductory screen that welcomes the user,
/// provides an option to watch a video, and proceeds to the main app.
struct IntroView: View {
    // MARK: - Properties
    // Closure to be called when the user wants to continue to the main app
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Title
            Text("Welcome to RevuLink")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 60)
                .foregroundStyle(Color("icon-bg"))

            // MARK: - Subtitle
            Text("Connect and share links with ease. Start using RevuLink or watch a quick video to learn more.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            // MARK: - Watch Intro Video Button
            NavigationLink(destination: VideoPlayerView()) {
                Text("Watch Intro Video")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("icon-bg"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            // MARK: - Continue Button
            Button(action: onContinue) {
                Text("Continue to App")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Spacer()
        }
    }
}

//#Preview {
//    IntroView()
//}
