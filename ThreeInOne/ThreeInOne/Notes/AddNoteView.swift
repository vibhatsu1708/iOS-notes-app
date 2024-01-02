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
    
    @State private var name: String = ""
    @State private var note_desc: String = ""
    @State private var heart: Bool = false
    @State private var bookmark: Bool = false
    @State private var hidden: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Note Name", text: $name, axis: .vertical)
                            .foregroundStyle(Color.newFont)
                            .font(.headline)
                            .bold()
                    }
                    Section {
                        TextField("Note Description", text: $note_desc, axis: .vertical)
                            .foregroundStyle(Color.newFont)
                            .font(.subheadline)
                    }
                }
                Group {
                    Button {
                        if name.trimmingCharacters(in: .whitespaces) == "" {
                            name = "New Note"
                        }
                        if note_desc.trimmingCharacters(in: .whitespaces) == "" {
                            note_desc = "Note Description"
                        }
                        DataController().addNote(name: name, note_desc: note_desc, heart: heart, bookmark: bookmark, hidden: hidden, context: managedObjectContext)
                        dismiss()
                    } label: {
                        Label("Add Note", systemImage: "plus")
                    }
                    .padding()
                    .bold()
                    .font(.title3)
                    .background(LinearGradient(colors: [Color(UIColor(hex: "F87666")), Color(UIColor(hex: "8A4FFF"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
                    .clipShape(RoundedRectangle(cornerRadius: 1000.0))
                }
            }
            .navigationTitle("New Note")
        }
    }
}

#Preview {
    AddNoteView()
}
