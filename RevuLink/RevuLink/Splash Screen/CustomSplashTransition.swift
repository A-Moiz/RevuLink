//
//  CustomSplashTransition.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import Foundation
import UIKit
import SwiftUICore
// MARK: - CustomSplashTransition
/// A custom transition for the splash screen view that moves the view off-screen based on the `isRoot` property.
/// The view slides in or out vertically based on whether it's the root screen or not.
struct CustomSplashTransition: Transition {
    // MARK: - Properties
    // A flag indicating whether the view is the root view or not
    var isRoot: Bool
    
    // MARK: - Body Method
    /// Custom transition animation applied to the view's content during the transition phase.
    /// - Parameters:
    ///   - content: The content to be transitioned
    ///   - phase: The current phase of the transition (e.g., beginning or end).
    /// - Returns: A modified version of the content with the applied offset.
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            // Offset the view's position based on the transition phase
            .offset(y: phase.isIdentity ? 0 : isRoot ? screenSize.height : -screenSize.height)
            // When the transition is complete, the view is positioned off-screen based on its "root" status
    }

    // MARK: - Screen Size Property
    /// Retrieves the size of the screen on the current device to calculate the offset for the transition.
    /// - Returns: The size of the screen (width and height).
    var screenSize: CGSize {
        // Access the current connected scene to get the screen size (for iPhone, iPad, etc.)
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        
        // Return a zero size if unable to get the screen size
        return .zero
    }
}
