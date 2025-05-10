//
//  NavigationBackButton.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import SwiftUI

// MARK: - NavigationBackButton
/// A custom back button used in navigation bars to go back to the previous screen.
struct NavigationBackButton: View {
    var body: some View {
        // MARK: - Chevron Icon
        Image(systemName: "chevron.left")
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .clipShape(Circle())
    }
}

#Preview {
    NavigationBackButton()
}
