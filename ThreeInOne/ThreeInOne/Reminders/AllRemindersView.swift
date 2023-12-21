//
//  AllRemindersView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct AllRemindersView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.undoManager) var undoManager
    @FetchRequest(
        entity: Reminder.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Reminder.date, ascending: false)]) var reminders: FetchedResults<Reminder>

    @State private var toggleOnlyCompleted: Bool = false
    @State private var toggleOnlyNotCompleted: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var totalCompleted: Int = 0
    @State private var totalNotCompleted: Int = 0
    
    var filteredReminders: [Reminder] {
        guard !searchText.isEmpty else {
            if toggleOnlyCompleted {
                return reminders.filter { $0.completed }
            }
            if toggleOnlyNotCompleted {
                return reminders.filter { !$0.completed }
            }
            return Array(reminders)
        }

        return reminders.filter {
            if toggleOnlyCompleted {
                return $0.completed && ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.reminder_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
            if toggleOnlyNotCompleted {
                return !$0.completed &&
                    ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.reminder_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            } else {
                return $0.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.reminder_desc?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    var groupedReminders: [Date: [Reminder]] {
        Dictionary(grouping: filteredReminders) { reminder in
            Calendar.current.startOfDay(for: reminder.date!)
        }
    }


    @State private var showingAddReminder: Bool = false
    @State private var showingEditReminder: Bool = false
    @State private var selectedReminder: Reminder?
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            Button {
                                toggleOnlyCompleted = false
                                toggleOnlyNotCompleted = false
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
                                if toggleOnlyNotCompleted {
                                    toggleOnlyNotCompleted = false
                                }
                                toggleOnlyCompleted.toggle()
                            } label: {
                                HStack {
                                    Circle()
                                        .frame(height: 15)
                                        .foregroundStyle(toggleOnlyCompleted ? Color(UIColor(hex: "5863F8")) : Color(UIColor(hex: "5863F8")).opacity(0.4))
                                    Text("Completed")
                                        .bold()
                                    Text("\(totalCompleted)")
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 10)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                if toggleOnlyCompleted {
                                    toggleOnlyCompleted = false
                                }
                                toggleOnlyNotCompleted.toggle()
                            } label: {
                                HStack {
                                    Circle()
                                        .frame(height: 15)
                                        .foregroundStyle(toggleOnlyNotCompleted ? Color(UIColor(hex: "FF686B")) : Color(UIColor(hex: "FF686B")).opacity(0.4))
                                    Text("Not Completed")
                                        .bold()
                                    Text("\(totalNotCompleted)")
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 10)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(8)
                            .foregroundStyle(Color.newFont)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "trash.fill")
                                    
                            }
                            .padding(8)
                            .background(Color(UIColor(hex: "E71D36")).opacity(0.3))
                            .foregroundStyle(Color.newFont.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                        .frame(height: 50)
                    }
                    .padding(.horizontal)
                    Divider()
                    List {
                        ForEach(groupedReminders.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(formatDate(date: date))) { 
                                ForEach(groupedReminders[date]!) { reminder in
                                    NavigationLink(destination: EditReminderView(reminder: reminder)) {
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading, spacing: 10) {
                                                HStack(alignment: .firstTextBaseline, spacing: 10) {
                                                    Circle()
                                                        .frame(height: 15)
                                                        .foregroundStyle(reminder.completed ? Color(UIColor(hex: "5863F8")): Color(UIColor(hex: "FF686B")))
                                                    Text(reminder.name!)
                                                        .font(.headline)
                                                        .bold()
                                                }
                                                
                                                if reminder.reminder_desc!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                                    Text(reminder.reminder_desc!)
                                                        .font(.subheadline)
                                                } else {
                                                    Text(reminder.reminder_desc!)
                                                        .font(.subheadline)
                                                }
                                                
                                                Spacer()
                                                
                                                HStack {
                                                    Text(calculateTime(date: reminder.date!))
                                                        .font(.caption)
                                                        .foregroundStyle(Color.gray)
                                                        .italic()
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            reminder.completed.toggle()
                                            updateRemindersCount()
                                            DataController().save(context: managedObjectContext)
                                        } label: {
                                            Label(reminder.completed ? "Not Done" : "Done", systemImage: "checklist.checked")
                                                .tint(reminder.completed ? Color(UIColor(hex: "FF686B")) : Color(UIColor(hex: "5863F8")))
                                        }
                                    }
                                }
                                .onDelete(perform: deleteReminder)
                                .padding(.vertical)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("Your Reminders")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                updateRemindersCount()
                managedObjectContext.undoManager = UndoManager()
            }
            .onChange(of: filteredReminders) {
                updateRemindersCount()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack() {
                        Button(action: {
                            showingAddReminder.toggle()
                        }) {
                            Image(systemName: "text.badge.checkmark")
                        }
                        .sheet(isPresented: $showingAddReminder) {
                            AddReminderView()
                        }
                    }
                    .font(.title)
                    .bold()
                    .frame(width: 80, height: 80)
                    .background(LinearGradient(colors: [Color(UIColor(hex: "F3C178")), Color(UIColor(hex: "FE5E41"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
                    .clipShape(Circle())
                    .shadow(radius: 30)
                }
            }
            .padding(30)
        }
    }
    
    private func deleteReminder(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                reminders[$0]
            }.forEach(managedObjectContext.delete)
            
            DataController().save(context: managedObjectContext)
        }
    }
    
    private func updateRemindersCount() {
        totalCompleted = calculateTotalCompleted()
        totalNotCompleted = calculateTotalNotCompleted()
    }
    private func calculateTotalCompleted() -> Int {
        return reminders.reduce(0) {
            $0 + ($1.completed ? 1 : 0)
        }
    }
    private func calculateTotalNotCompleted() -> Int {
        return reminders.reduce(0) {
            $0 + (!$1.completed ? 1 : 0)
        }
    }
}

#Preview {
    AllRemindersView()
}
