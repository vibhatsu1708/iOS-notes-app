//
//  ContentView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var note: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminder: FetchedResults<Reminder>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var purchase: FetchedResults<Purchase>
    
    
    // For the navigation bar
    @State private var tabSelection: Int = 1

    var body: some View {
        TabView {
            AllPurchasesView()
                .tabItem {
                    Label("Budget Tracker", systemImage: "creditcard.fill")
                }
            
            AllRemindersView()
                .tabItem {
                    Label("Your Todos", systemImage: "text.badge.checkmark")
                }
            
            AllNotesView()
                .tabItem {
                    Label("Your Notes", systemImage: "note.text")
                }
        }
        .tint(Color.white)
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
