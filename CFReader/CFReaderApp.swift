//
//  CFReaderApp.swift
//  CFReader
//
//  Created by Panagiotis Bobolakis on 1/20/24.
//

import SwiftUI

@main
struct CFReaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fixedSize()
        }
        .windowResizability(.contentSize) 
    }
}
