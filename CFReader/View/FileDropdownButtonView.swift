//
//  FileDropdownView.swift
//  CFReader
//
//  Created by Panagiotis Bobolakis on 1/20/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileDropdownButtonView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    @State private var isHovered = false

    var body: some View {
        VStack {
            Button(action: appViewModel.selectFile) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(isHovered ? Color(red: 0.247, green: 0.259, blue: 0.298) : Color(red: 47.0 / 255.0, green: 50.0 / 255.0, blue: 60.0 / 255.0))
                    .animation(.easeInOut(duration: 0.33), value: isHovered)
                    .overlay(
                        Text("Click to add or\ndrop an app")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .buttonStyle(.plain)
            .focusable(false)
            .onDrop(of: [UTType.application], isTargeted: nil) { providers -> Bool in
                if let firstProvider = providers.first {
                    appViewModel.dragAndDropFile(with: firstProvider)
                    return true
                }
                return false
            }
            .onHover { hover in
                isHovered = hover
            }

        }
    }
}
