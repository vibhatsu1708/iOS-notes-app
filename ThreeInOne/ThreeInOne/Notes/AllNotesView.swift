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
    
    @State private var totalStarred: Int = 0
    @State private var totalBookmarked: Int = 0
    @State private var totalHidden: Int = 0
    
    @State private var searchText: String = ""
    
    @State var selectedNote: Note? = nil
    
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
    
    @State private var showingAddNoteView: Bool = false
    @State private var showingEditNoteView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(toggleOnlyHidden ? groupedHiddenNotes.keys.sorted(by: >) : groupedNotes.keys.sorted(by: >), id: \.self) { date in
                        Section(header: Text(formatDate(date: date))) {
                            ForEach(toggleOnlyHidden ? groupedHiddenNotes[date]! : groupedNotes[date]!) { note in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack(alignment: .top) {
                                            Text(note.name!)
                                                .font(.headline)
                                                .bold()
                                            Spacer()
                                            if note.star {
                                                Image(systemName: "star.fill")
                                                    .foregroundStyle(Color.orange)
                                                    .shadow(radius: 15.0)
                                            }
                                            if note.bookmark {
                                                Image(systemName: "bookmark.fill")
                                                    .foregroundStyle(Color.blue)
                                                    .shadow(radius: 15.0)
                                            }
                                        }
                                        
                                        if !note.note_desc!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text(note.note_desc!)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                        
                                        if note.hidden {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "eye.slash")
                                                    .foregroundStyle(Color.purple)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical)
                                // leading swipe actions are bookmark and star
                                .swipeActions(edge: .leading) {
                                    Button {
                                        note.star.toggle()
                                        updateNotesCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    } label: {
                                        Image(systemName: note.star ? "star.slash.fill" : "star.fill")
                                            .tint(Color.orange)
                                    }
                                    Button {
                                        note.bookmark.toggle()
                                        updateNotesCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    } label: {
                                        Image(systemName: note.bookmark ? "bookmark.slash.fill" : "bookmark.fill")
                                            .tint(Color.blue)
                                    }
                                }
                                
                                // trailing swipe action is the hide function
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        note.hidden.toggle()
                                        updateNotesCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    } label: {
                                        Image(systemName: note.hidden ? "eye.slash" : "eye")
                                            .tint(Color.purple)
                                    }
                                }
                                .contextMenu {
                                    Button {
                                        selectedNote = note
                                    } label: {
                                        Text("Edit")
                                    }
                                    
                                    Button {
                                    } label: {
                                        Text("Delete")
                                    }
                                }
                            }
                        }
                    }
                }
                .sheet(item: $selectedNote) { note in
                    EditNoteView(note: note)
                        .onDisappear {
                            selectedNote = nil
                        }
                }
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
                .navigationTitle("Your Notes")
                .navigationBarTitleDisplayMode(.automatic)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .onAppear {
                    updateNotesCount()
                }
                .onChange(of: groupedNotes) {
                    updateNotesCount()
                }
                
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                Button {
                                    toggleOnlyStar = false
                                    toggleOnlyBookmark = false
                                    toggleOnlyHidden = false
                                } label: {
                                    Group {
                                        Image(systemName: "eraser.fill")
                                    }
                                    .bold()
                                }
                                .padding(10)
                                .foregroundStyle(Color.newFont)
                                .background(Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 2)
                                }
                                .padding(.leading)
                                
                                Circle()
                                    .frame(height: 5)
                                    .opacity(0.5)
                                
                                Button {
                                    toggleOnlyStar.toggle()
                                } label: {
                                    HStack {
                                        Group {
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(Color.orange)
                                                .opacity(toggleOnlyStar ? 1.0 : 0.5)
                                                .padding(.leading, 10)
                                            Text("Star")
                                        }
                                        
                                        Text("\(totalStarred)")
                                            .foregroundStyle(.secondary)
                                            .padding(.horizontal, 10)
                                    }
                                }
                                .padding(10)
                                .foregroundStyle(Color.newFont)
                                .background(toggleOnlyStar ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                                .clipShape(Capsule())
                                
                                Button {
                                    toggleOnlyBookmark.toggle()
                                } label: {
                                    HStack {
                                        Group {
                                            Image(systemName: "bookmark.fill")
                                                .foregroundStyle(Color.blue)
                                                .opacity(toggleOnlyBookmark ? 1.0 : 0.5)
                                                .padding(.leading, 10)
                                            Text("Bookmark")
                                        }
                                    }
                                    
                                    Text("\(totalBookmarked)")
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 10)
                                }
                                .padding(10)
                                .foregroundStyle(Color.newFont)
                                .background(toggleOnlyBookmark ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                                .clipShape(Capsule())
                                
                                Button {
                                    toggleOnlyHidden.toggle()
                                } label: {
                                    HStack {
                                        Group {
                                            Image(systemName: "eye.slash")
                                                .foregroundStyle(Color.purple)
                                                .opacity(toggleOnlyHidden ? 1.0 : 0.5)
                                                .padding(.leading, 10)
                                            Text("Hidden")
                                        }
                                    }
                                    
                                    Text("\(totalHidden)")
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 10)
                                }
                                .padding(10)
                                .foregroundStyle(Color.newFont)
                                .background(toggleOnlyHidden ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                                .clipShape(Capsule())
                                .padding(.trailing)
                            }
                            .frame(minHeight: 50)
                            .frame(maxHeight: 60)
                        }
                        .frame(height: 70)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20.0)
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        }
                        .padding(.leading)
                        .padding(.top)
                        .padding(.bottom)
                        
                        //MARK: - View for the add note button
                        AddNoteButton(
                            showingAddNoteView: $showingAddNoteView)
                    }
                }
            }
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
    AllNotesView()
}

//MARK: - Custom view for the add note button
struct AddNoteButton: View {
    @Binding var showingAddNoteView: Bool
    
    var body: some View {
        Button {
            showingAddNoteView.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(width: 70, height: 70)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                }
                .padding(.trailing)
        }
        .popover(isPresented: $showingAddNoteView, content: {
            AddNoteView()
                .background(.ultraThinMaterial)
                .presentationCompactAdaptation(.sheet)
        })
    }
}
