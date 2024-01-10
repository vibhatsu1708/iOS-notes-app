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
    
    @ObservedObject private var customTabViewModel = CustomTabViewModel()
    
    @Binding var isCustomTabBarHidden: Bool
    
    @State private var toggleOnlyStar: Bool = false
    @State private var toggleOnlyBookmark: Bool = false
    @State private var toggleOnlyHidden: Bool = false
    
    @State private var totalStarred: Int = 0
    @State private var totalBookmarked: Int = 0
    @State private var totalHidden: Int = 0
    
    @State private var searchText: String = ""
    
    var filteredNotes: [Note] {
        guard !searchText.isEmpty else {
            if toggleOnlyStar && toggleOnlyBookmark {
                return notes.filter { $0.star && $0.bookmark }
            }
            if toggleOnlyStar {
                return notes.filter { $0.star }
            }
            if toggleOnlyBookmark {
                return notes.filter { $0.bookmark }
            }
            return Array(notes)
        }

        return notes.filter {
            if toggleOnlyStar && toggleOnlyBookmark {
                return ($0.bookmark && $0.star) &&
                    ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
            if toggleOnlyStar {
                return $0.star && ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.note_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
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
                                toggleOnlyStar.toggle()
                            } label: {
                                HStack {
                                    Group {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f9bc2c")), Color(UIColor(hex: "f74c06"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .opacity(toggleOnlyStar ? 1.0 : 0.5)
                                        Text("Star")
                                    }
                                    
                                    Text("\(totalStarred)")
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 10)
                                }
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                toggleOnlyBookmark.toggle()
                            } label: {
                                HStack {
                                    Group {
                                        Image(systemName: "bookmark.fill")
                                            .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "0968e5")), Color(UIColor(hex: "71c3f7"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .opacity(toggleOnlyBookmark ? 1.0 : 0.5)
                                        Text("Bookmark")
                                    }
                                }
                                
                                Text("\(totalBookmarked)")
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 10)
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                toggleOnlyHidden.toggle()
                            } label: {
                                HStack {
                                    Group {
                                        Image(systemName: "eye.slash")
                                            .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "A06CD5")), Color(UIColor(hex: "6247AA"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .opacity(toggleOnlyHidden ? 1.0 : 0.5)
                                        Text("Hidden")
                                    }
                                }
                                
                                Text("\(totalHidden)")
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 10)
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                        .frame(height: 50)
                    }
                    .padding(.horizontal)
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
                                                    if note.star {
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
                                        .padding(.vertical)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            note.hidden.toggle()
                                            updateNotesCount()
                                            DataController.shared.save(context: managedObjectContext)
                                        } label: {
                                            Image(systemName: note.hidden ? "eye.slash" : "eye")
                                                .tint(Color(UIColor(hex: "4F4789")))
                                        }
                                        Button {
                                            note.star.toggle()
                                            updateNotesCount()
                                            DataController.shared.save(context: managedObjectContext)
                                        } label: {
                                            Image(systemName: note.star ? "star.slash.fill" : "star.fill")
                                                .tint(Color(UIColor(hex: "f74c06")))
                                        }
                                        Button {
                                            note.bookmark.toggle()
                                            updateNotesCount()
                                            DataController.shared.save(context: managedObjectContext)
                                        } label: {
                                            Image(systemName: note.bookmark ? "bookmark.slash.fill" : "bookmark.fill")
                                                .tint(Color(UIColor(hex: "2B2D42")))
                                        }
                                    }
                                }
                                .onDelete(perform: deleteNote)
                            }
                        }
                    }
//                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        if groupedNotes.isEmpty && toggleOnlyHidden == false && toggleOnlyBookmark == false && toggleOnlyStar == false {
                            VStack(spacing: 20) {
                                Image(systemName: "note.text")
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Notes noted")
                                HStack {
                                    Text("Tap on the button to create a Note.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if groupedNotes.isEmpty && toggleOnlyStar == true && (toggleOnlyHidden == false && toggleOnlyBookmark == false) {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "note.text")
                                }
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Starred Notes")
                                HStack {
                                    Text("Swipe on a Note to Star a Note.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if groupedNotes.isEmpty && toggleOnlyBookmark == true && (toggleOnlyHidden == false && toggleOnlyStar == false) {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "bookmark.fill")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "note.text")
                                }
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Bookmarked Notes")
                                HStack {
                                    Text("Swipe on a Note to Bookmark a Note.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if groupedNotes.isEmpty && (toggleOnlyStar == true && toggleOnlyBookmark == true) && toggleOnlyHidden == false {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "bookmark.fill")
                                }
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Starred Bookmarked Notes")
                                HStack {
                                    Text("Swipe on a Note to Star or/and Bookmark.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if groupedHiddenNotes.isEmpty && toggleOnlyHidden == true && toggleOnlyStar == false && toggleOnlyBookmark == false {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "eye.slash")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "note.text")
                                }
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Hidden Notes")
                                HStack {
                                    Text("Swipe on a Note to Hide.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if groupedHiddenNotes.isEmpty && toggleOnlyHidden == true && toggleOnlyStar == true && toggleOnlyBookmark == false {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "eye.slash")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "star.fill")
                                }
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Hidden Starred Notes")
                                HStack {
                                    Text("Swipe on a Hidden Note to Star.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if groupedHiddenNotes.isEmpty && toggleOnlyHidden == true && toggleOnlyBookmark == true && toggleOnlyStar == false {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "eye.slash")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "bookmark.fill")
                                }
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Hidden Bookmarked Notes")
                                HStack {
                                    Text("Swipe on a Hidden Note to Bookmark.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if groupedHiddenNotes.isEmpty && toggleOnlyHidden == true && (toggleOnlyBookmark == true && toggleOnlyStar == true) {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: "eye.slash")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "bookmark.fill")
                                    Image(systemName: "plus")
                                        .font(.subheadline)
                                    Image(systemName: "star.fill")
                                }
                                    .font(.system(size: 35))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Hidden Starred Bookmarked Notes")
                                HStack {
                                    Text("Swipe on a Hidden Note to Star or/and Bookmark.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                    }
                }
                .background(LinearGradient(colors: [Color(UIColor(hex: customTabViewModel.tabBarItems[2].accentColor)).opacity(0.5)], startPoint: .top, endPoint: .bottom))
                .navigationTitle("Your Notes")
//                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        EditButton()
//                    }
//                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .onAppear {
                    updateNotesCount()
                }
                .onChange(of: groupedNotes) {
                    updateNotesCount()
                }
            }

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
                    .background(Color(UIColor(hex: customTabViewModel.tabBarItems[2].accentColor)))
                    .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
                    .clipShape(Circle())
                    .shadow(radius: 30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 120)
        }
    }
    
    private func updateNotesCount() {
        totalStarred = calculateTotalStarred()
        totalBookmarked = calculateTotalNotBookmarked()
        totalHidden = calculateTotalHidden()
    }
    private func calculateTotalStarred() -> Int {
        return notes.reduce(0) {
            $0 + ($1.star ? 1 : 0)
        }
    }
    private func calculateTotalNotBookmarked() -> Int {
        return notes.reduce(0) {
            $0 + ($1.bookmark ? 1 : 0)
        }
    }
    private func calculateTotalHidden() -> Int {
        return notes.reduce(0) {
            $0 + ($1.hidden ? 1 : 0)
        }
    }
    
    private func deleteNote(offsets: IndexSet) {
        withAnimation {
//            for index in offsets {
//                let note = notes[index]
//                managedObjectContext.delete(note)
//            }
//            DataController.shared.save(context: managedObjectContext)
            
            for index in offsets {
                guard index < notes.count else { continue }
                
                let note = notes[index]
                
                guard let existingNote = managedObjectContext.object(with: note.objectID) as? Note else { continue }
                
                managedObjectContext.delete(existingNote)
            }
            DataController.shared.save(context: managedObjectContext)
        }
    }
}


#Preview {
    AllNotesView(isCustomTabBarHidden: .constant(true))
}
