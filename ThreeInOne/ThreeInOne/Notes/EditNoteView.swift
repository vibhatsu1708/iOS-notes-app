//
//  EditNoteView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct EditNoteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var note: FetchedResults<Note>.Element
    
    @State private var disabledEditButton: Bool = true
    
    @State private var name = ""
    @State private var note_desc: String = ""
    @State private var background_color: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Note header") {
                    TextField("...\(note.name!)", text: $name, axis: .vertical)
                        .font(.headline)
                        .fontWeight(.bold)
                        .onAppear {
                            name = note.name!
                        }
                        .onChange(of: name) { _, _ in
                            updateButtonState()
                        }
                }
                Section("Note description") {
                    TextField("...\(note.note_desc!)", text: $note_desc, axis: .vertical)
                        .font(.subheadline)
                        .onAppear {
                            note_desc = note.note_desc!
                        }
                        .onChange(of: note_desc) { _, _ in
                            updateButtonState()
                        }
                }
            }
            .navigationTitle("Edit Note")
        }
        .interactiveDismissDisabled()
        
        HStack {
            // To save changes button
            Button {
                if name.trimmingCharacters(in: .whitespaces) == "" {
                    name = "New note"
                }
                if note_desc.trimmingCharacters(in: .whitespaces) == "" {
                    note_desc = "Note description"
                }
                
                DataController().editNote(note: note, name: name, note_desc: note_desc, background_color: background_color, context: managedObjectContext)
                dismiss()
            } label: {
                Label("Save changes", systemImage: "plus")
            }.disabled(disabledEditButton)
            .padding()
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.newFont)
            .background(!disabledEditButton ? Color.indigo : Color.secondary)
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
        disabledEditButton = name == note.name && note_desc == note.note_desc
    }
}
