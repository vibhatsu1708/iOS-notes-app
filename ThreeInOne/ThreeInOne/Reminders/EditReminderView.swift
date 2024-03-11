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
    
    @ObservedObject private var customTabViewModel = CustomTabViewModel()
    
    @Binding var isCustomTabBarHidden: Bool
    
    @Binding var isAddButtonHidden: Bool
    
    @State private var disabledEditButton: Bool = true
    
    @State private var name = ""
    @State private var reminder_desc: String = ""
    @State private var tags: String = ""
    
    // For presenting the sheet of the edit reminder view
    @State var editReminderViewToggle: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Todo Name") {
                    TextField("\(reminder.name!)", text: $name, axis: .vertical)
                        .bold()
                        .font(.headline)
                        .onAppear {
                            name = reminder.name!
                        }
                        .onChange(of: name) { _, _ in
                            updateButtonState()
                        }
                }
                
                Section("Todo Description") {
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

        HStack {
            // To save changes button
            Button {
                if name.trimmingCharacters(in: .whitespaces) == "" {
                    name = "New Todo"
                }
                
                DataController().editReminder(reminder: reminder, name: name, reminder_desc: reminder_desc, tags: tags, context: managedObjectContext)
                dismiss()
            } label: {
                Label("Save Changes", systemImage: "plus")
            }.disabled(disabledEditButton)
            .padding()
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.newFont)
            .background(!disabledEditButton ? Color(UIColor(hex: customTabViewModel.tabBarItems[1].accentColor)) : Color(UIColor(hex: "DEDEE0")))
            .clipShape(RoundedRectangle(cornerRadius: 1000.0))
            .onAppear {
                isCustomTabBarHidden = true
                isAddButtonHidden = true
            }
            .onDisappear {
                isCustomTabBarHidden = false
                isAddButtonHidden = false
            }
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .padding()
                    .font(.title3)
                    .fontWeight(.bold)
                    .background(.tertiary)
                    .foregroundStyle(Color.white)
                    .clipShape(Circle())
            }
        }
    }
    
    func updateButtonState() {
        disabledEditButton = name == reminder.name && reminder_desc == reminder.reminder_desc
    }
}
