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
    
    @ObservedObject private var customTabViewModel = CustomTabViewModel()
    
    @Binding var isCustomTabBarHidden: Bool
    
    @Binding var isAddButtonHidden: Bool
    
    @State private var disabledEditButton: Bool = true
    
    @State private var name = ""
    @State private var note_desc: String = ""
    @State private var background_color: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Section {
                        TextField("Note Name\(note.name!)", text: $name, axis: .vertical)
                            .bold()
                            .font(.title)
                            .onAppear {
                                name = note.name!
                            }
                            .onChange(of: name) { _, _ in
                                updateButtonState()
                            }
                    }
                    Section {
                        TextField("Note Description\(note.note_desc!)", text: $note_desc, axis: .vertical)
                            .font(.title3)
                            .onAppear {
                                note_desc = note.note_desc!
                            }
                            .onChange(of: note_desc) { _, _ in
                                updateButtonState()
                            }
                    }
                }
                .padding()
                Spacer()
                Button {
                    if name.trimmingCharacters(in: .whitespaces) == "" {
                        name = "New Note"
                    }
                    if note_desc.trimmingCharacters(in: .whitespaces) == "" {
                        note_desc = "Note Description"
                    }
                    
                    DataController().editNote(note: note, name: name, note_desc: note_desc, background_color: background_color, context: managedObjectContext)
                    dismiss()
                } label: {
                    Label("Add Changes", systemImage: "plus")
                }.disabled(disabledEditButton)
                .padding()
                .bold()
                .font(.title3)
                .background(!disabledEditButton ? Color(UIColor(hex: customTabViewModel.tabBarItems[2].accentColor)) : Color(UIColor(hex: "DEDEE0")))
                .foregroundStyle(Color.newFont)
                .clipShape(RoundedRectangle(cornerRadius: 1000.0))
                .onAppear {
                    isCustomTabBarHidden = true
                    isAddButtonHidden = true
                }
                .onDisappear {
                    isCustomTabBarHidden = false
                    isAddButtonHidden = false
                }
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func updateButtonState() {
        disabledEditButton = name == note.name && note_desc == note.note_desc
    }
}
