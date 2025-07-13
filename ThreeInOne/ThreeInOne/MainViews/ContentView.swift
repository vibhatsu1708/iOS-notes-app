//
//  ContentView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct TabItem {
    let tag: Int
    let color: Color
}

struct ContentView: View {
    var body: some View {
        TabView {
            AllPurchasesView()
                .tabItem {
                    Label("Budget", systemImage: "creditcard.fill")
                }
            
            AllTimersView()
                .tabItem {
                    Label("Timers", systemImage: "45.arrow.trianglehead.clockwise")
                }
            
            AllRemindersView()
                .tabItem {
                    Label("Todos", systemImage: "text.badge.checkmark")
                }
            
            AllNotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
               
        }
        .tint(Color.white)
        .withDefaultFont(.funnelDisplay(size: 16)) // Set default font for entire app
    }
}

// Extension to be able to use hex colors throughout the project views/files.
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


#Preview {
    ContentView()
}
