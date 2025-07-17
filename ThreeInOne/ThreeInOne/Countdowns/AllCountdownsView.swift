//
//  AllCountdownsView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI
import CoreData

struct AllCountdownsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Countdown.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Countdown.completionDate, ascending: false)]) var countdowns: FetchedResults<Countdown>
    
    @State private var toggleOnlyCompleted: Bool = false
    @State private var toggleOnlyNotCompleted: Bool = false
    @State private var toggleOnlyFlagged: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var totalCompleted: Int = 0
    @State private var totalNotCompleted: Int = 0
    @State private var totalFlagged: Int = 0
    
    // For presenting the sheet of the edit countdown view
    @State var selectedCountdown: Countdown? = nil
    @State var showingEditCountdownView: Bool = false
    
    //MARK: - Filtering countdowns when text entered in the search box
    var filteredCountdowns: [Countdown] {
        // if the search field is empty
        guard !searchText.isEmpty else {
            if toggleOnlyFlagged && toggleOnlyCompleted {
                return countdowns.filter { $0.flag && $0.isCompleted }
            }
            if toggleOnlyFlagged && toggleOnlyNotCompleted {
                return countdowns.filter { $0.flag && !$0.isCompleted }
            }
            if toggleOnlyCompleted {
                return countdowns.filter { $0.isCompleted }
            }
            if toggleOnlyNotCompleted {
                return countdowns.filter { !$0.isCompleted }
            }
            if toggleOnlyFlagged {
                return countdowns.filter { $0.flag }
            }
            
            return Array(countdowns)
        }
        
        // if the search field is not empty
        return countdowns.filter { countdown in
            let titleMatches = countdown.title?.localizedCaseInsensitiveContains(searchText) ?? false
            
            if toggleOnlyFlagged && toggleOnlyCompleted {
                return titleMatches && countdown.flag && countdown.isCompleted
            }
            if toggleOnlyFlagged && toggleOnlyNotCompleted {
                return titleMatches && countdown.flag && !countdown.isCompleted
            }
            if toggleOnlyCompleted {
                return titleMatches && countdown.isCompleted
            }
            if toggleOnlyNotCompleted {
                return titleMatches && !countdown.isCompleted
            }
            if toggleOnlyFlagged {
                return titleMatches && countdown.flag
            } else {
                return titleMatches
            }
        }
    }
    
    //MARK: - Grouping the filtered countdowns based on the completion date
    var groupedCountdowns: [Date: [Countdown]] {
        return Dictionary(grouping: filteredCountdowns) { countdown in
            Calendar.current.startOfDay(for: countdown.completionDate ?? Date())
        }
    }
    
    //MARK: - Toggles for the showing or display of the add buttons and the edit view for the selected countdown
    @State private var showingAddCountdownView: Bool = false
    
    @State private var confirmationForDeletionOfCompletedCountdowns: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    //MARK: - To display all the fetched countdowns in a list
                    List {
                        ForEach(groupedCountdowns.keys.sorted(by: >), id: \.self) { date in
                            ForEach(groupedCountdowns[date]!) { countdown in
                                CountdownListItemView(
                                    countdown: countdown,
                                    onToggleCompletion: {
                                        countdown.isCompleted.toggle()
                                        updateCountdownsCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    },
                                    onToggleFlag: {
                                        countdown.flag.toggle()
                                        updateCountdownsCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    },
                                    onDelete: {
                                        managedObjectContext.delete(countdown)
                                        DataController.shared.save(context: managedObjectContext)
                                    },
                                    onEdit: {
                                        selectedCountdown = countdown
                                        showingEditCountdownView = true
                                    }
                                )
                            }
                        }
                    }
                    .listStyle(InsetListStyle())
                    .listRowSpacing(10)
                    .environment(\.defaultMinListRowHeight, 0)
                    .overlay {
                        EmptyCountdownStateView(
                            countdowns: countdowns,
                            toggleOnlyCompleted: toggleOnlyCompleted,
                            toggleOnlyNotCompleted: toggleOnlyNotCompleted,
                            toggleOnlyFlagged: toggleOnlyFlagged,
                            calculateTotalCompleted: calculateTotalCompleted,
                            calculateTotalNotCompleted: calculateTotalNotCompleted,
                            calculateTotalFlagged: calculateTotalFlagged
                        )
                    }
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 100)
                    }
                    
                    .frame(maxWidth: .infinity)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Your Countdowns")
                            .font(.boldonse(size: 24))
                            .foregroundStyle(Color.red)
                    }
                }
            }
            .sheet(isPresented: $showingEditCountdownView) {
                if let countdown = selectedCountdown {
                    EditCountdownView(countdown: countdown)
                }
            }
            .onChange(of: showingEditCountdownView) { isPresented in
                if !isPresented {
                    selectedCountdown = nil
                }
            }
            .onAppear {
                updateCountdownsCount()
                managedObjectContext.undoManager = UndoManager()
            }
            .onChange(of: filteredCountdowns) {
                updateCountdownsCount()
            }
            
            //MARK: - Top horizontal scrollview bar featuring the toggle buttons to toggle the visibility buttons
            .safeAreaInset(edge: .bottom) {
                HStack {
                    CountdownFilterButtonsView(
                        toggleOnlyCompleted: $toggleOnlyCompleted,
                        toggleOnlyNotCompleted: $toggleOnlyNotCompleted,
                        toggleOnlyFlagged: $toggleOnlyFlagged,
                        confirmationForDeletionOfCompletedCountdowns: $confirmationForDeletionOfCompletedCountdowns,
                        totalCompleted: totalCompleted,
                        totalNotCompleted: totalNotCompleted,
                        totalFlagged: totalFlagged,
                        deleteCompletedCountdowns: deleteCompletedCountdowns
                    )
                    
                    //MARK: - View for the add countdown button
                    AddCountdownButton(
                        showingAddCountdownView: $showingAddCountdownView)
                }
            }
        }
    }
    
    //MARK: - To update the status of the countdowns when any swipe action is completed
    private func updateCountdownsCount() {
        totalCompleted = calculateTotalCompleted()
        totalNotCompleted = calculateTotalNotCompleted()
        totalFlagged = calculateTotalFlagged()
    }
    
    private func calculateTotalCompleted() -> Int {
        return countdowns.reduce(0) {
            $0 + ($1.isCompleted ? 1 : 0)
        }
    }
    
    private func calculateTotalNotCompleted() -> Int {
        return countdowns.reduce(0) {
            $0 + (!$1.isCompleted ? 1 : 0)
        }
    }
    
    private func calculateTotalFlagged() -> Int {
        return countdowns.reduce(0) {
            $0 + ($1.flag ? 1 : 0)
        }
    }
    
    private func deleteCompletedCountdowns() {
        let completedCountdownsToDelete = countdowns.filter { $0.isCompleted == true }
        for countdown in completedCountdownsToDelete {
            managedObjectContext.delete(countdown)
        }
        DataController.shared.save(context: managedObjectContext)
    }
}

#Preview  {
    AllCountdownsView()
} 
