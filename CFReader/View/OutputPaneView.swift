//
//  OutputPaneView.swift
//  CFReader
//
//  Created by Panagiotis Bobolakis on 1/20/24.
//

import SwiftUI

struct OutputPaneView: View {
    var appInfo: AppInfo
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        if appInfo.bundleIdentifier != "" {
            Spacer()
            
            Section {
                HoverButtonView(
                    title: "Bundle Identifier",
                    text: appInfo.bundleIdentifier,
                    sfSymbolName: "doc.on.doc",
                    action: {
                        appViewModel.copyToPasteboard(appInfo.bundleIdentifier)
                    }
                )
            }
            Section {
                HoverButtonView(
                    title: "Bundle Short Version String",
                    text: appInfo.bundleShortVersionString,
                    sfSymbolName: "doc.on.doc",
                    action: {
                        appViewModel.copyToPasteboard(appInfo.bundleShortVersionString)
                    }
                )
            }
        }
    }
}
