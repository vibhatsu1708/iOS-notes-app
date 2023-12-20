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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var notes: FetchedResults<Note>
    
    @State private var toggleOnlyHeart: Bool = false
    @State private var toggleOnlyBookmark: Bool = false

    @State private var searchText: String = ""

    var filteredNotes: [Note] {
        guard !searchText.isEmpty else {
            if toggleOnlyHeart {
                return notes.filter { $0.heart }
            }
            if toggleOnlyBookmark {
                return notes.filter { $0.bookmark }
            }
            return Array(notes)
        }

        return notes.filter {
            if toggleOnlyHeart {
                return $0.heart && ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
            if toggleOnlyBookmark {
                return $0.bookmark &&
                    ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            } else {
                return $0.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false
            }
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
                                toggleOnlyHeart = false
                                toggleOnlyBookmark = false
                            } label: {
                                Text("Clear Filters")
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
                                toggleOnlyHeart.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f9bc2c")), Color(UIColor(hex: "f74c06"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(toggleOnlyHeart ? 1.0 : 0.5)
                                        .shadow(radius: 15.0)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                if toggleOnlyHeart {
                                    toggleOnlyHeart = false
                                }
                                toggleOnlyBookmark.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "bookmark.fill")
                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "0968e5")), Color(UIColor(hex: "71c3f7"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(toggleOnlyBookmark ? 1.0 : 0.5)
                                        .shadow(radius: 15.0)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
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
                        ForEach(filteredNotes) { note in
                            NavigationLink(destination: EditNoteView(note: note)) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            if note.bookmark {
                                                Image(systemName: "bookmark.fill")
                                                    .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "0968e5")), Color(UIColor(hex: "71c3f7"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    .shadow(radius: 15.0)
                                            }
                                            Text(note.name!)
                                                .font(.headline)
                                                .bold()
                                            Spacer()
                                            if note.heart {
                                                Image(systemName: "heart.fill")
                                                    .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f9bc2c")), Color(UIColor(hex: "f74c06"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    .shadow(radius: 15.0)
                                            }
                                        }
                                        
                                        Text(note.note_desc!)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        Divider()
                                        HStack {
                                            Text(calculateTime(date: note.date!))
                                                .font(.caption)
                                                .foregroundStyle(Color.gray)
                                                .italic()
                                        }
                                    }
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    note.heart.toggle()
                                    DataController().save(context: managedObjectContext)
                                } label: {
                                    Image(systemName: note.heart ? "heart.slash.fill" : "heart.fill")
                                        .tint(LinearGradient(colors: [Color(UIColor(hex: "f74c06"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                }
                                Button {
                                    note.bookmark.toggle()
                                    DataController().save(context: managedObjectContext)
                                } label: {
                                    Image(systemName: note.bookmark ? "bookmark.slash.fill" : "bookmark.fill")
                                        .tint(LinearGradient(colors: [Color(UIColor(hex: "71c3f7"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                }
                            }
                        }
                        .onDelete(perform: deleteNote)
                        .padding(.vertical)
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
                            Image(systemName: "doc.text.fill")
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
            .padding(30)
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
    AllNotesView()
}
