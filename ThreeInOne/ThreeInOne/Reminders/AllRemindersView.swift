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
    @FetchRequest(
        entity: Reminder.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Reminder.date, ascending: false)]) var reminders: FetchedResults<Reminder>
    
    @ObservedObject private var customTabViewModel = CustomTabViewModel()
    
    @Binding var isCustomTabBarHidden: Bool

    @State private var toggleOnlyCompleted: Bool = false
    @State private var toggleOnlyNotCompleted: Bool = false
    
    @State private var toggleOnlyFlag: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var totalCompleted: Int = 0
    @State private var totalNotCompleted: Int = 0
    @State private var totalFlagged: Int = 0
    
    var filteredReminders: [Reminder] {
        guard !searchText.isEmpty else {
            if toggleOnlyFlag && toggleOnlyCompleted {
                return reminders.filter { $0.flag && $0.completed }
            }
            if toggleOnlyFlag && toggleOnlyNotCompleted {
                return reminders.filter { $0.flag && !$0.completed }
            }
            if toggleOnlyCompleted {
                return reminders.filter { $0.completed }
            }
            if toggleOnlyNotCompleted {
                return reminders.filter { !$0.completed }
            }
            if toggleOnlyFlag {
                return reminders.filter { $0.flag }
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
            } 
            if toggleOnlyFlag {
                return $0.flag && ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.reminder_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            } 
            if toggleOnlyFlag && toggleOnlyCompleted {
                return $0.flag && $0.completed && ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.reminder_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
            if toggleOnlyFlag && toggleOnlyNotCompleted {
                return $0.flag && !$0.completed && ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.reminder_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
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
    
    @State private var confirmationForDeletionOfCompletedReminders: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            Button {
                                toggleOnlyCompleted = false
                                toggleOnlyNotCompleted = false
                                toggleOnlyFlag = false
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
                                toggleOnlyFlag.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "flag.fill")
                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f83d5c")), Color(UIColor(hex: "fd4b2f"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(toggleOnlyFlag ? 1.0 : 0.5)
                                    
                                    Text("Flagged")
                                    Text("\(totalFlagged)")
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
                                if toggleOnlyNotCompleted {
                                    toggleOnlyNotCompleted = false
                                }
                                toggleOnlyCompleted.toggle()
                            } label: {
                                HStack {
                                    Circle()
                                        .frame(height: 15)
                                        .foregroundStyle(Color(UIColor(hex: "5863F8")))
                                        .opacity(toggleOnlyCompleted ? 1.0 : 0.5)
                                    Text("Completed")
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
                                        .foregroundStyle(Color(UIColor(hex: "FF686B")))
                                        .opacity(toggleOnlyNotCompleted ? 1.0 : 0.5)
                                    Text("Not Completed")
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
                                confirmationForDeletionOfCompletedReminders = true
                            } label: {
                                Image(systemName: "trash.fill")
                            }.confirmationDialog("Are you sure you want to Delete all the Completed Todos?", isPresented: $confirmationForDeletionOfCompletedReminders, titleVisibility: .visible, actions: {
                                Button("Delete", role: .destructive, action: deleteCompletedReminders)
                                Button("Cancel", role: .cancel, action: {})
                            })
                            .padding(8)
                            .background(Color(UIColor(hex: "E71D36")).opacity(0.3))
                            .foregroundStyle(Color.newFont.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                        .frame(height: 50)
                    }
                    .padding(.horizontal)
                    List {
                        ForEach(groupedReminders.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(formatDate(date: date))) {
                                ForEach(groupedReminders[date]!) { reminder in
                                    NavigationLink(destination: EditReminderView(reminder: reminder, isCustomTabBarHidden: $isCustomTabBarHidden)) {
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
                                                    Image(systemName: "flag.fill")
                                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f83d5c")), Color(UIColor(hex: "fd4b2f"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .opacity(reminder.flag ? 1.0 : 0.0)
                                                }
                                            }
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            reminder.completed.toggle()
                                            updateRemindersCount()
                                            DataController.shared.save(context: managedObjectContext)
                                        } label: {
                                            Label(reminder.completed ? "Not Done" : "Done", systemImage: "checklist.checked")
                                                .tint(reminder.completed ? Color(UIColor(hex: "FF686B")) : Color(UIColor(hex: "5863F8")))
                                        }
                                        Button {
                                            reminder.flag.toggle()
                                            updateRemindersCount()
                                            DataController.shared.save(context: managedObjectContext)
                                        } label: {
                                            Label(reminder.flag ? "Unflag" : "Flag", systemImage: reminder.flag ? "flag.slash.fill" : "flag.fill")
                                                .tint(Color(UIColor(hex: "392d69")))
                                        }
                                    }
//                                    .swipeActions(edge: .trailing) {
//                                        Button {
//                                            reminder.deleteFlag = true
//                                            deleteReminder()
//                                        } label: {
//                                            Image(systemName: "trash.fill")
//                                        }
//                                    }
                                }
                                .onDelete(perform: deleteReminder)
                                .padding(.vertical)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .overlay {
                        if reminders.isEmpty && toggleOnlyFlag == false && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false {
                            VStack(spacing: 20) {
                                Image(systemName: "checklist.checked")
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Todos to do")
                                HStack {
                                    Text("Tap on the button to add a Todo.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if toggleOnlyFlag == true && calculateTotalFlagged() == 0 && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false {
                            VStack(spacing: 20) {
                                Image(systemName: "flag.fill")
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Flagged Todos to do")
                                HStack {
                                    Text("Swipe on a Todo to flag.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if toggleOnlyCompleted == true && calculateTotalCompleted() == 0 && toggleOnlyFlag == false {
                            VStack(spacing: 20) {
                                Image(systemName: "checklist.checked")
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Completed Todos")
                                HStack {
                                    Text("Swipe on a Todo to Complete a Todo.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if toggleOnlyNotCompleted == true && calculateTotalNotCompleted() == 0 && toggleOnlyFlag == false {
                            VStack(spacing: 20) {
                                Image(systemName: "checklist.unchecked")
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Incompleted Todos")
                                HStack {
                                    Text("Tap on the button to add a todo.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if (toggleOnlyCompleted == true && toggleOnlyFlag == true) && (filteredReminders.isEmpty) {
                            VStack(spacing: 20) {
                                Image(systemName: "checklist.unchecked")
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Flagged Completed Todos")
                                HStack {
                                    Text("Swipe on a Completed Todo to Flag a Todo.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                        if (toggleOnlyFlag == true && toggleOnlyNotCompleted == true) && (filteredReminders.isEmpty) {
                            VStack(spacing: 20) {
                                Image(systemName: "checklist.unchecked")
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(.tertiary)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                Text("No Flagged Incompleted Todos")
                                HStack {
                                    Text("Swipe on a Incompleted Todo to Flag a Todo.")
                                }
                                Spacer()
                            }
                            .padding(.top, 50)
                        }
                    }
                }
                .background(Color(UIColor(hex: customTabViewModel.tabBarItems[1].accentColor)).opacity(0.3))
                .navigationTitle("Your Todos")
//                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        EditButton()
//                    }
//                }
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
                            Image(systemName: "checklist")
                        }
                        .sheet(isPresented: $showingAddReminder) {
                            AddReminderView()
                        }
                    }
                    .font(.title)
                    .bold()
                    .frame(width: 80, height: 80)
                    .background(LinearGradient(colors: [Color(UIColor(hex: "FFBA08")), Color(UIColor(hex: "FE5E41"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
                    .clipShape(Circle())
                    .shadow(radius: 30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 120)
        }
    }
    
    private func deleteReminder(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                guard index < reminders.count else { continue }
                
                let reminder = reminders[index]
                
                guard let existingReminder = managedObjectContext.object(with: reminder.objectID) as? Reminder else { continue }
                
                managedObjectContext.delete(existingReminder)
            }
            DataController.shared.save(context: managedObjectContext)
        }
    }
    
//    private func deleteReminder() {
//        let reminderToDelete = reminders.filter { $0.deleteFlag == true }
//        for reminder in reminderToDelete {
//            managedObjectContext.delete(reminder)
//        }
//        DataController.shared.save(context: managedObjectContext)
//    }
    
    private func updateRemindersCount() {
        totalCompleted = calculateTotalCompleted()
        totalNotCompleted = calculateTotalNotCompleted()
        totalFlagged = calculateTotalFlagged()
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
    private func calculateTotalFlagged() -> Int {
        return reminders.reduce(0) {
            $0 + ($1.flag ? 1 : 0)
        }
    }
    private func deleteCompletedReminders() {
        let completedRemindersToDelete = reminders.filter { $0.completed == true }
        for reminder in completedRemindersToDelete {
            managedObjectContext.delete(reminder)
        }
        DataController.shared.save(context: managedObjectContext)
    }
}

#Preview {
    AllRemindersView(isCustomTabBarHidden: .constant(true))
}
