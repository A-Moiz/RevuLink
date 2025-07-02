//
//  VideoPlayerView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 09/05/2025.
//

import SwiftUI
import AVKit

// MARK: - VideoPlayerView
/// A view that plays a video from the app's bundle.

struct VideoPlayerView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // MARK: - Video Player
            // Attempt to find the "intro.mp4" file in the app bundle and play it.
            if let url = Bundle.main.url(forResource: "intro", withExtension: "mp4") {
                // Create a VideoPlayer view with the AVPlayer
                VideoPlayer(player: AVPlayer(url: url))
                    .ignoresSafeArea()
                    // MARK: - onAppear Modifier
                    .onAppear {
                        do {
                            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
                            try AVAudioSession.sharedInstance().setActive(true)
                        } catch {
                            // Print error message if setting the audio session fails.
                            print("Failed to set AVAudioSession: \(error)")
                        }

                        // Play the video once everything is ready.
                        AVPlayer(url: url).play()
                    }
                    .ignoresSafeArea()

            } else {
                // MARK: - Fallback Text
                // If the video file is not found in the bundle, display message.
                Text("Video not found")
                    .foregroundColor(.red)
            }
        }
    }
}

//#Preview {
//    VideoPlayerView()
//}
