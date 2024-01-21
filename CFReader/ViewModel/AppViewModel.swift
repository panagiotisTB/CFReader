//
//  AppViewModel.swift
//  CFReader
//
//  Created by Panagiotis Bobolakis on 1/20/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import AppKit

class AppViewModel: ObservableObject {
    @Published var selectedFileURL: URL?
    @Published var appInfo: AppInfo
    @Published var isHovering = false

    init() {
        self.appInfo = AppInfo(bundleIdentifier: "", bundleShortVersionString: "")
    }
    
    func selectFile() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowedContentTypes = [UTType.application]

        if let directoryURL = URL(string: "file:///Applications") {
            openPanel.directoryURL = directoryURL
        }

        if openPanel.runModal() == .OK, let selectedFile = openPanel.urls.first {
            selectedFileURL = selectedFile
            let escapedFileURL = selectedFile.standardizedFileURL.path(percentEncoded: false).replacingOccurrences(of: " ", with: "\\ " )
            appInfo.bundleIdentifier = shell("/usr/bin/defaults read \(escapedFileURL)/Contents/Info CFBundleIdentifier")
            appInfo.bundleShortVersionString = shell("/usr/bin/defaults read \(escapedFileURL)/Contents/Info CFBundleShortVersionString")
        }
    }
    
    func dragAndDropFile(with firstProvider: NSItemProvider) {
        
        firstProvider.loadItem(forTypeIdentifier: UTType.application.identifier, options: nil) { (urlData, error) in
            let directoryURL = urlData.unsafelyUnwrapped as! NSURL
            let urlString: String = directoryURL.absoluteString!
            var url = urlString.replacingOccurrences(of: "file://", with: "" )
            url = url.replacingOccurrences(of: "%20", with: "\\ ")
            DispatchQueue.main.async {
                self.appInfo.bundleIdentifier = self.shell("/usr/bin/defaults read \(url)/Contents/Info CFBundleIdentifier")
                self.appInfo.bundleShortVersionString = self.shell("/usr/bin/defaults read \(url)/Contents/Info CFBundleShortVersionString")
            }
        }
    }
    
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        let errorPipe = Pipe() // Separate pipe for standard error
        task.standardError = errorPipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"

        task.launch()
        task.waitUntilExit() // Wait for the command to finish

        let status = task.terminationStatus
        if status != 0 {
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorString = String(data: errorData, encoding: .utf8) ?? "Error: Unknown"
            return "Error (Exit Code \(status)): \(errorString)"
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8), !output.isEmpty {
            return output.replacingOccurrences(of: "\n", with: "")
        } else {
            return "Error: Command execution produced no output"
        }
    }

    
    func copyToPasteboard(_ text: String) -> Void {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
