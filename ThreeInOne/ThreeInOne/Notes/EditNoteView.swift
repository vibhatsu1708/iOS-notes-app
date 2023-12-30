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
    @State private var heart: Bool = false
    @State private var bookmark: Bool = false
    @State private var hidden: Bool = false
    
    var body: some View {
        Form {
            Section {
                TextField("Note Name\(note.name!)", text: $name, axis: .vertical)
                    .bold()
                    .font(.headline)
                
                TextField("Note Description\(note.note_desc!)", text: $note_desc, axis: .vertical)
                    .font(.subheadline)
                    .onAppear {
                        name = note.name!
                        note_desc = note.note_desc!
                    }
                    .onChange(of: name) { _, _ in
                        updateButtonState()
                    }
                    .onChange(of: note_desc) { _, _ in
                        updateButtonState()
                    }
            }
        }
        Button {
            if name.trimmingCharacters(in: .whitespaces) == "" {
                name = "New Note"
            }
            if note_desc.trimmingCharacters(in: .whitespaces) == "" {
                note_desc = "Note Description"
            }
            
            DataController().editNote(note: note, name: name, note_desc: note_desc, heart: heart, bookmark: bookmark, hidden: hidden, context: managedObjectContext)
            dismiss()
        } label: {
            Label("Add Changes", systemImage: "plus")
        }.disabled(disabledEditButton)
        .padding()
        .bold()
        .font(.title3)
        .background(!disabledEditButton ? LinearGradient(colors: [Color(UIColor(hex: "F87666")), Color(UIColor(hex: "8A4FFF"))], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor(hex: "DEDEE0"))], startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
        .clipShape(RoundedRectangle(cornerRadius: 1000.0))
    }
    
    func updateButtonState() {
        disabledEditButton = name == note.name && note_desc == note.note_desc
    }
}
