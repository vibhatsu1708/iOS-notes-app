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
                    TextField("Todo Name", text: $name, axis: .vertical)
                        .foregroundStyle(Color.newFont)
                        .bold()
                        .font(.headline)
                        .focused($focus, equals: .name)
                }
                Section {
                    TextField("Todo Description", text: $reminder_desc, axis: .vertical)
                        .foregroundStyle(Color.newFont)
                        .font(.subheadline)
                        .focused($focus, equals: .reminder_desc)
                }
                Section {
                    TextField("Tags", text: $tags, axis: .vertical)
                        .foregroundStyle(Color.newFont)
                        .font(.subheadline)
                }
            }
            .navigationTitle("New Todo")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                focus = .name
            }
        }
        Group {
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
            .bold()
            .font(.title3)
            .background(Color(UIColor(hex: customTabViewModel.tabBarItems[1].accentColor)))
            .foregroundStyle(Color.newFont)
            .clipShape(RoundedRectangle(cornerRadius: 1000.0))
        }
    }
    
    enum FocusedField: Hashable {
        case name, reminder_desc
    }
}

#Preview {
    AddReminderView()
}
