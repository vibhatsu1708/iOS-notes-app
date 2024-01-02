//
//  AllNotesView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct AllNotesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.date, ascending: false)]) var notes: FetchedResults<Note>
    
    @State private var toggleOnlyStar: Bool = false
    @State private var toggleOnlyBookmark: Bool = false
    @State private var toggleOnlyHidden: Bool = false
    
    @Binding var isCustomTabBarHidden: Bool
    
    @State private var searchText: String = ""
    
    var filteredNotes: [Note] {
        guard !searchText.isEmpty else {
            if toggleOnlyStar {
                return notes.filter { $0.heart }
            }
            if toggleOnlyBookmark {
                return notes.filter { $0.bookmark }
            }
            return Array(notes)
        }

        return notes.filter {
            if toggleOnlyStar {
                return $0.heart && ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
            if toggleOnlyBookmark {
                return $0.bookmark &&
                    ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
            else {
                return $0.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    var groupedNotes: [Date: [Note]] {
        let filteredUnhiddenNotes = filteredNotes.filter { !$0.hidden }
        return Dictionary(grouping: filteredUnhiddenNotes) { note in
            Calendar.current.startOfDay(for: note.date!)
        }
    }
    var groupedHiddenNotes: [Date: [Note]] {
        let filteredHiddenNotes = filteredNotes.filter { $0.hidden }
        return Dictionary(grouping: filteredHiddenNotes) { note in
            Calendar.current.startOfDay(for: note.date!)
        }
    }
    
    @State private var showingAddNote: Bool = false
    @State private var showingEditNote: Bool = false
    @State private var selectedNote: Note?
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            Button {
                                toggleOnlyStar = false
                                toggleOnlyBookmark = false
                                toggleOnlyHidden = false
                            } label: {
                                Group {
                                    Image(systemName: "eraser.fill")
                                    Text("Clear Filters")
                                }
                                .bold()
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                if toggleOnlyBookmark {
                                    toggleOnlyBookmark = false
                                }
                                toggleOnlyStar.toggle()
                            } label: {
                                Group {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f9bc2c")), Color(UIColor(hex: "f74c06"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(toggleOnlyStar ? 1.0 : 0.5)
                                    Text("Star Notes")
                                }
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                if toggleOnlyStar {
                                    toggleOnlyStar = false
                                }
                                toggleOnlyBookmark.toggle()
                            } label: {
                                Group {
                                    Image(systemName: "bookmark.fill")
                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "0968e5")), Color(UIColor(hex: "71c3f7"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(toggleOnlyBookmark ? 1.0 : 0.5)
                                    Text("Bookmark Notes")
                                }
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                toggleOnlyHidden.toggle()
                            } label: {
                                Group {
                                    Image(systemName: "eye.slash")
                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "A06CD5")), Color(UIColor(hex: "6247AA"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(toggleOnlyHidden ? 1.0 : 0.5)
                                    Text("Hidden Notes")
                                }
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                        .frame(height: 50)
                    }
                    .padding(.horizontal)
                    Divider()
                    List {
                        ForEach(toggleOnlyHidden ? groupedHiddenNotes.keys.sorted(by: >) : groupedNotes.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(formatDate(date: date))) {
                                ForEach(toggleOnlyHidden ? groupedHiddenNotes[date]! : groupedNotes[date]!) { note in
                                    NavigationLink(destination: EditNoteView(note: note, isCustomTabBarHidden: $isCustomTabBarHidden)) {
                                        
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading, spacing: 10) {
                                                HStack(alignment: .top) {
                                                    Text(note.name!)
                                                        .font(.headline)
                                                        .bold()
                                                    Spacer()
                                                    if note.bookmark {
                                                        Image(systemName: "bookmark.fill")
                                                            .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "0968e5")), Color(UIColor(hex: "71c3f7"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                            .shadow(radius: 15.0)
                                                    }
                                                    if note.heart {
                                                        Image(systemName: "star.fill")
                                                            .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f9bc2c")), Color(UIColor(hex: "f74c06"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                            .shadow(radius: 15.0)
                                                    }
                                                }
                                                
                                                Text(note.note_desc!)
                                                    .font(.subheadline)
                                                
                                                Spacer()
                                                HStack {
                                                    Text(calculateTime(date: note.date!))
                                                        .font(.caption)
                                                        .foregroundStyle(Color.gray)
                                                        .italic()
                                                    Spacer()
                                                    Image(systemName: "eye.slash")
                                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "A06CD5")), Color(UIColor(hex: "6247AA"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .opacity(note.hidden ? 1.0 : 0.0)
                                                }
                                            }
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            note.hidden.toggle()
                                            DataController().save(context: managedObjectContext)
                                        } label: {
                                            Image(systemName: note.hidden ? "eye.slash" : "eye")
                                                .tint(Color(UIColor(hex: "4F4789")))
                                        }
                                        Button {
                                            note.heart.toggle()
                                            DataController().save(context: managedObjectContext)
                                        } label: {
                                            Image(systemName: note.heart ? "star.slash.fill" : "star.fill")
                                                .tint(Color(UIColor(hex: "f74c06")))
                                        }
                                        Button {
                                            note.bookmark.toggle()
                                            DataController().save(context: managedObjectContext)
                                        } label: {
                                            Image(systemName: note.bookmark ? "bookmark.slash.fill" : "bookmark.fill")
                                                .tint(Color(UIColor(hex: "2B2D42")))
                                        }
                                    }
                                }
                                .onDelete(perform: deleteNote)
                                .padding(.vertical)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("Your Notes")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack() {
                        Button(action: {
                            showingAddNote.toggle()
                        }) {
                            Image(systemName: "note.text")
                        }
                        .sheet(isPresented: $showingAddNote) {
                            AddNoteView()
                        }
                    }
                    .font(.title)
                    .bold()
                    .frame(width: 80, height: 80)
                    .background(LinearGradient(colors: [Color(UIColor(hex: "F87666")), Color(UIColor(hex: "8A4FFF"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
                    .clipShape(Circle())
                    .shadow(radius: 30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 120)
        }
    }
    
    private func deleteNote(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                notes[$0]
            }.forEach(managedObjectContext.delete)
            
            DataController().save(context: managedObjectContext)
        }
    }
}


#Preview {
    AllNotesView(isCustomTabBarHidden: .constant(true))
}
