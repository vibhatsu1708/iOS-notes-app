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
    
    // For hiding the Custom Tab Bar when in Edit View or Add View.
//    @Binding var isCustomTabBarHidden: Bool
    
    // For hiding the Add button when in Edit View.
//    @Binding var isAddButtonHidden: Bool

    @State private var toggleOnlyCompleted: Bool = false
    @State private var toggleOnlyNotCompleted: Bool = false
    
    @State private var toggleOnlyFlag: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var totalCompleted: Int = 0
    @State private var totalNotCompleted: Int = 0
    @State private var totalFlagged: Int = 0
    
    // For presenting the sheet of the edit reminder view
    @State var editReminderViewToggle: Bool = false
    
    @State var selectedReminder: Reminder? = nil
    
    //MARK: - Filtering reminders when text entered in the search box
    var filteredReminders: [Reminder] {
        // if the search field is empty
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

        // if the search field is not empty
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
    
    //MARK: - Grouping the filtered reminders based on the date of creation
    var groupedReminders: [Date: [Reminder]] {
        Dictionary(grouping: filteredReminders) { reminder in
            Calendar.current.startOfDay(for: reminder.date!)
        }
    }

    //MARK: - Toggles for the showing or display of the add buttons and the edit view for the selected reminder
    @State private var showingAddReminder: Bool = false
    @State private var showingEditReminder: Bool = false
    
    @State private var confirmationForDeletionOfCompletedReminders: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                //MARK: - To display all the fetched reminders in a list
                List {
                    ForEach(groupedReminders.keys.sorted(by: >), id: \.self) { date in
                        Section(header: Text(formatDate(date: date))) {
                            ForEach(groupedReminders[date]!, id:  \.self) { reminder in
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
                                        }
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            Image(systemName: "flag.fill")
                                                .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f83d5c")), Color(UIColor(hex: "fd4b2f"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .opacity(reminder.flag ? 1.0 : 0.0)
                                        }
                                    }
                                }
                                // swipe actions for each reminder
                                .swipeActions(edge: .leading) {
                                    // to toggle the completion toggle of a reminder
                                    Button {
                                        reminder.completed.toggle()
                                        updateRemindersCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    } label: {
                                        Label(reminder.completed ? "Not Done" : "Done", systemImage: "checklist.checked")
                                            .tint(reminder.completed ? Color(UIColor(hex: "FF686B")) : Color(UIColor(hex: "5863F8")))
                                    }
                                    // to toggle the flag status of a reminder
                                    Button {
                                        reminder.flag.toggle()
                                        updateRemindersCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    } label: {
                                        Label(reminder.flag ? "Unflag" : "Flag", systemImage: reminder.flag ? "flag.slash.fill" : "flag.fill")
                                            .tint(Color(UIColor(hex: "392d69")))
                                    }
                                }
                                // to display the context menu when long pressing a reminder
                                .contextMenu {
                                    // to push the selected reminder in edit view
                                    Button {
                                        selectedReminder = reminder
                                    } label: {
                                        Text("Edit")
                                    }
                                    
                                    Button {
                                    } label: {
                                        Text("Delete")
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
                
                // To display the sheet for the edit view for the selected reminder
                .sheet(item: $selectedReminder) { reminder in
                    EditReminderView(reminder: reminder/*, isAddButtonHidden: $isAddButtonHidden*/)
                        .onDisappear {
                            selectedReminder = nil
                        }
                }
                .background(.ultraThinMaterial)
                
                // To display the empty states based on the toggles activated
                .overlay {
                    if reminders.isEmpty && toggleOnlyFlag == false && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false {
                        VStack(spacing: 20) {
                            Image(systemName: "checklist")
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
                                Text("Tap on the button to add a Todo.")
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
                .navigationTitle("Your Todos")
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                updateRemindersCount()
                managedObjectContext.undoManager = UndoManager()
            }
            .onChange(of: filteredReminders) {
                updateRemindersCount()
            }
            
            //MARK: - Top horizontal scrollview bar featuring the toggle buttons to toggle the visibility buttons
            .safeAreaInset(edge: .bottom) {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            // to toggle all the filters to false, or to turn them off
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
                            
                            // to toggle the flagged reminders
                            Button {
                                toggleOnlyFlag.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "flag.fill")
                                        .foregroundStyle(LinearGradient(colors: [Color(UIColor(hex: "f83d5c")), Color(UIColor(hex: "fd4b2f"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(toggleOnlyFlag ? 1.0 : 0.5)
                                        .padding(.leading, 10)
                                    
                                    Text("Flagged")
                                    Text("\(totalFlagged)")
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 10)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(10)
                            .foregroundStyle(Color.newFont)
                            .background(toggleOnlyFlag ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                            .clipShape(Capsule())
                            
                            // to toggle the not completed reminders
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
                                        .padding(.leading, 10)
                                    Text("Completed")
                                    Text("\(totalCompleted)")
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 10)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(10)
                            .foregroundStyle(Color.newFont)
                            .background(toggleOnlyCompleted ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                            .clipShape(Capsule())
                            
                            // to toggle the completed reminders
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
                                        .padding(.leading, 10)
                                    Text("Not Completed")
                                    Text("\(totalNotCompleted)")
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 10)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(10)
                            .foregroundStyle(Color.newFont)
                            .background(toggleOnlyNotCompleted ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                            .clipShape(Capsule())
                            
                            // confirmation for the deleting of the archived reminders
                            Button {
                                confirmationForDeletionOfCompletedReminders = true
                            } label: {
                                Image(systemName: "trash.fill")
                            }.confirmationDialog("Are you sure you want to Delete all the Completed Todos?", isPresented: $confirmationForDeletionOfCompletedReminders, titleVisibility: .visible, actions: {
                                Button("Delete", role: .destructive, action: deleteCompletedReminders)
                                Button("Cancel", role: .cancel, action: {})
                            })
                            .padding(10)
                            .background(Color(UIColor(hex: "E71D36")).opacity(0.4))
                            .foregroundStyle(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .padding(.trailing)
                        }
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
                    
                    //MARK: - View for the add reminder button
                    AddReminderButton(
                        showingAddReminder: $showingAddReminder
                        /*isAddButtonHidden: $isAddButtonHidden*/)
                }
            }
        }
    }
    
    private func deleteReminder(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                filteredReminders[$0]
            }.forEach(managedObjectContext.delete)
            
            DataController.shared.save(context: managedObjectContext)
        }
    }
    
    //MARK: - To update the status of the reminders when any swipe action is completed
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

//MARK: - All Reminders View Preview
#Preview {
    AllRemindersView(/*isAddButtonHidden: .constant(true)*/)
}

//MARK: - Preview for the Custom View for the scrollview
//#Preview {
//    CustomReminderView()
//}

//MARK: - Custom view for the add reminder button
struct AddReminderButton: View {
    @Binding var showingAddReminder: Bool
    
    var body: some View {
        Button {
            showingAddReminder.toggle()
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
        .popover(isPresented: $showingAddReminder, content: {
            AddReminderView()
                .background(.ultraThinMaterial)
                .presentationCompactAdaptation(.sheet)
        })
    }
}

