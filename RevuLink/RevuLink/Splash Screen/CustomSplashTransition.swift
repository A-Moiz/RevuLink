//
//  CustomSplashTransition.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import Foundation
import UIKit
import SwiftUICore

struct CustomSplashTransition: Transition {
    var isRoot: Bool
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .offset(y: phase.isIdentity ? 0 : isRoot ? screenSize.height : -screenSize.height)
    }
    
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        
        return .zero
    }
}
