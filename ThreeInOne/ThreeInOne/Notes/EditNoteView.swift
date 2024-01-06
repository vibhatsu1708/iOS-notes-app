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
    
    @Binding var isCustomTabBarHidden: Bool
    
    @State private var disabledEditButton: Bool = true
    
    @State private var name = ""
    @State private var note_desc: String = ""
    @State private var star: Bool = false
    @State private var bookmark: Bool = false
    @State private var hidden: Bool = false
    
    var body: some View {
        Form {
            Section("Note Name") {
                TextField("\(note.name!)", text: $name, axis: .vertical)
                    .bold()
                    .font(.headline)
                    .onAppear {
                        name = note.name!
                    }
                    .onChange(of: name) { _, _ in
                        updateButtonState()
                    }
            }
            Section("Note Description") {
                TextField("\(note.note_desc!)", text: $note_desc, axis: .vertical)
                    .font(.subheadline)
                    .onAppear {
                        note_desc = note.note_desc!
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
            
            DataController().editNote(note: note, name: name, note_desc: note_desc, star: star, bookmark: bookmark, hidden: hidden, context: managedObjectContext)
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
        .onAppear {
            isCustomTabBarHidden = true
        }
        .onDisappear {
            isCustomTabBarHidden = false
        }
    }
    
    func updateButtonState() {
        disabledEditButton = name == note.name && note_desc == note.note_desc
    }
}
