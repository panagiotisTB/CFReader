//
//  HoverButtonView.swift
//  CFReader
//
//  Created by Panagiotis Bobolakis on 1/20/24.
//

import SwiftUI

struct HoverButtonView: View {
    var title: String
    var text: String
    var sfSymbolName: String
    var action: () -> Void

    @State private var isHovered = false


    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(isHovered ? Color(red: 0.247, green: 0.259, blue: 0.298) : Color.clear)
                    .animation(.easeInOut(duration: 0.33), value: isHovered)
                VStack(alignment: .leading, content: {
                    Spacer()
                    Text(title)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .opacity(isHovered ? 0 : 1)
                        .animation(.easeInOut(duration: 0.33), value: isHovered)
                    Spacer()
                    Text(text)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .opacity(isHovered ? 0 : 1)
                        .animation(.easeInOut(duration: 0.33), value: isHovered)
                    Spacer()
                })
                .frame(maxWidth: .infinity)
                .padding(5)
                Image(systemName: sfSymbolName)
                    .opacity(isHovered ? 1 : 0)
                    .animation(.easeInOut(duration: 0.33), value: isHovered)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .buttonStyle(.plain)
        .focusable(false)
        .onHover { hover in
            isHovered = hover
        }
    }
}
#Preview {
    HoverButtonView(title: "Demo", text: "Demo", sfSymbolName: "doc.on.doc", action: {return})
}
