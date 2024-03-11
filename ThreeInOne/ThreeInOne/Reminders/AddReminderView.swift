//
//  AddReminderView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct AddReminderView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    // For bringing focus onto the textfields.
    @FocusState var focus: FocusedField?
    
    @ObservedObject private var customTabViewModel = CustomTabViewModel()
    
    @State private var name: String = ""
    @State private var reminder_desc: String = ""
    @State private var completed: Bool = false
    @State private var flag: Bool = false
    @State private var tags: String = ""
    @State private var deleteFlag: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Todo name...", text: $name, axis: .vertical)
                        .font(.headline)
                        .fontWeight(.bold)
                        .focused($focus, equals: .name)
                }
                Section {
                    TextField("Todo description...", text: $reminder_desc, axis: .vertical)
                        .font(.subheadline)
                        .focused($focus, equals: .reminder_desc)
                }
                Section {
                    TextField("Tags...", text: $tags, axis: .vertical)
                        .font(.subheadline)
                        .foregroundStyle(Color.newFont)
                }
            }
            .navigationTitle("New Todo")
        }
        .interactiveDismissDisabled()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                focus = .name
            }
        }
        HStack {
            // To add the new todo
            Button {
                if name.trimmingCharacters(in: .whitespaces) == "" {
                    name = "New Todo"
                }
                DataController.shared.addReminder(name: name, reminder_desc: reminder_desc, completed: completed, flag: flag, tags: tags, deleteFlag: deleteFlag, context: managedObjectContext)
                dismiss()
            } label: {
                Label("Add Todo", systemImage: "plus")
            }
            .padding()
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.newFont)
            .background(Color(UIColor(hex: customTabViewModel.tabBarItems[1].accentColor)))
            .clipShape(Capsule())
            
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
    
    enum FocusedField: Hashable {
        case name, reminder_desc
    }
}

#Preview {
    AddReminderView()
}
