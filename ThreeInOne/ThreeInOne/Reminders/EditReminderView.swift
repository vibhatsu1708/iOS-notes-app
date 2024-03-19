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
        NavigationStack {
            Form {
                Section("Todo name") {
                    TextField("\(reminder.name!)", text: $name, axis: .vertical)
                        .font(.headline)
                        .fontWeight(.bold)
                        .onAppear {
                            name = reminder.name!
                        }
                        .onChange(of: name) { _, _ in
                            updateButtonState()
                        }
                }
                
                Section("Todo description") {
                    TextField("\(reminder.reminder_desc!)", text: $reminder_desc, axis: .vertical)
                        .font(.subheadline)
                        .onAppear {
                            reminder_desc = reminder.reminder_desc!
                        }
                        .onChange(of: reminder_desc) { _, _ in
                            updateButtonState()
                        }
                }
            }
            .navigationTitle("Edit Todo")
        }
        .interactiveDismissDisabled()
        .background(.ultraThinMaterial)

        HStack {
            // To save changes button
            Button {
                if name.trimmingCharacters(in: .whitespaces) == "" {
                    name = "New Todo"
                }
                
                DataController().editReminder(reminder: reminder, name: name, reminder_desc: reminder_desc, tags: tags, context: managedObjectContext)
                dismiss()
            } label: {
                Label("Save changes", systemImage: "plus")
            }.disabled(disabledEditButton)
            .padding()
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.newFont)
            .background(!disabledEditButton ? Color.red : Color.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 1000.0))
            
            // to dismiss the view if wanting to exit the edit view
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .padding()
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .background(.tertiary)
                    .clipShape(Circle())
            }
        }
    }
    
    func updateButtonState() {
        disabledEditButton = name == reminder.name && reminder_desc == reminder.reminder_desc
    }
}
