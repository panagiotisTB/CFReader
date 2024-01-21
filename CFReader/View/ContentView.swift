//
//  ContentView.swift
//  CFReader
//
//  Created by Panagiotis Bobolakis on 1/20/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()

    var body: some View {
        VStack(alignment: .center) {
            if let selectedFileURL = appViewModel.selectedFileURL {
                Text("\(selectedFileURL.lastPathComponent)")
                    .foregroundColor(.white)
                Spacer()
            }
            
            FileDropdownButtonView(appViewModel: appViewModel)
            OutputPaneView(appInfo: appViewModel.appInfo, appViewModel: appViewModel)
        }
        .frame(minWidth: 200, maxWidth: 200, minHeight: 300, idealHeight: 300, maxHeight: 300)
        .padding()
    }
}

#Preview {
    ContentView()
}
