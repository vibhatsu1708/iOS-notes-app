//
//  EditReminderView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct EditReminderView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var reminder: FetchedResults<Reminder>.Element
    
    @State private var disabledEditButton: Bool = true
    
    @State private var name = ""
    @State private var reminder_desc: String = ""
    @State private var tags: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("\(reminder.name!)", text: $name, axis: .vertical)
                    .bold()
                    .font(.headline)
                
                TextField("\(reminder.reminder_desc!)", text: $reminder_desc, axis: .vertical)
                    .font(.subheadline)
                    .onAppear {
                        name = reminder.name!
                        reminder_desc = reminder.reminder_desc!
                    }
                    .onChange(of: name) { _, _ in
                        updateButtonState()
                    }
                    .onChange(of: reminder_desc) { _, _ in
                        updateButtonState()
                    }
            }
        }
        Button {
            if name.trimmingCharacters(in: .whitespaces) == "" {
                name = "New Reminder"
            }
            if reminder_desc.trimmingCharacters(in: .whitespaces) == "" {
                reminder_desc = "Reminder Description"
            }
            
            DataController().editReminder(reminder: reminder, name: name, reminder_desc: reminder_desc, tags: tags, context: managedObjectContext)
            dismiss()
        } label: {
            Label("Add Changes", systemImage: "plus")
        }.disabled(disabledEditButton)
        .padding()
        .bold()
        .font(.title3)
        .background(!disabledEditButton ? LinearGradient(colors: [Color(UIColor(hex: "F3C178")), Color(UIColor(hex: "FE5E41"))], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor(hex: "DEDEE0"))], startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
        .clipShape(RoundedRectangle(cornerRadius: 1000.0))
    }
    
    func updateButtonState() {
        disabledEditButton = name == reminder.name && reminder_desc == reminder.reminder_desc
    }
}
