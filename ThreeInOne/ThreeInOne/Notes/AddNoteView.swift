//
//  AddNoteView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct AddNoteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    // For bringing focus onto the textfields.
    @FocusState var focus: FocusedField?
    
    @State private var name: String = ""
    @State private var note_desc: String = ""
    @State private var star: Bool = false
    @State private var bookmark: Bool = false
    @State private var hidden: Bool = false
    @State private var background_color: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Note header...", text: $name, axis: .vertical)
                        .font(.headline)
                        .fontWeight(.bold)
                        .focused($focus, equals: .name)
                        .onSubmit {
                            focus = .note_desc
                        }
                }
                Section {
                    TextField("Note body...", text: $note_desc, axis: .vertical)
                        .font(.subheadline)
                        .focused($focus, equals: .note_desc)
                        .onSubmit {
                            if name.trimmingCharacters(in: .whitespaces) != "" {
                                DataController.shared.addNote(name: name, note_desc: note_desc, star: star, bookmark: bookmark, hidden: hidden, background_color: background_color, context: managedObjectContext)
                                dismiss()
                            }
                        }
                }
            }
            .navigationTitle("New Note")
        }
        .interactiveDismissDisabled()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                focus = .name
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                // To add the new note
                Button {
                    if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        name = "New Note"
                    }
                    DataController.shared.addNote(name: name, note_desc: note_desc, star: star, bookmark: bookmark, hidden: hidden, background_color: background_color, context: managedObjectContext)
                    dismiss()
                } label: {
                    Label("Add Note", systemImage: "plus")
                }
                .padding()
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.newFont)
                .background(Color.teal)
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
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
    }
    
    enum FocusedField: Hashable {
        case name, note_desc
        // will add tags when the tags feature is implemented.
    }
}

#Preview {
    AddNoteView()
}
