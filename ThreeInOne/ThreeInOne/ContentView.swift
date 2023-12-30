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
    
    
    var body: some View {
        TabView {
            AllNotesView()
                .tabItem {
                    Label("My Notes", systemImage: "note.text")
                }
            AllRemindersView()
                .tabItem {
                    Label("My Reminders", systemImage: "checklist")
                }
//            AllPurchasesView()
//                .tabItem {
//                    Label("My Budget", systemImage: "chart.bar")
//                }
        }
    }
}

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
