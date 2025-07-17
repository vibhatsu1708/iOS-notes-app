//
//  AllTimersView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI
import CoreData

// MARK: - Active Timer State
struct ActiveTimerState {
    let timer: Timers
    var timeRemaining: Int
    var isPaused: Bool
    var countdownTimer: Timer?
    
    init(timer: Timers) {
        self.timer = timer
        self.timeRemaining = Int(timer.duration)
        self.isPaused = false
        self.countdownTimer = nil
    }
}

struct TimerCountdownView: View {
    let timeRemaining: Int
    let totalTime: Int
    let isPaused: Bool
    let isCountdownRunning: Bool
    let onPauseResume: () -> Void
    let onReset: () -> Void
    
    @State private var previousTimeRemaining: Int
    @State private var isFlippingHours: Bool = false
    @State private var isFlippingMinutes: Bool = false
    @State private var isFlippingSeconds: Bool = false
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    init(
        timeRemaining: Int,
        totalTime: Int,
        isPaused: Bool = false,
        isCountdownRunning: Bool = false,
        onPauseResume: @escaping () -> Void = {},
        onReset: @escaping () -> Void = {}
    ) {
        self.timeRemaining = timeRemaining
        self.totalTime = totalTime
        self.isPaused = isPaused
        self.isCountdownRunning = isCountdownRunning
        self.onPauseResume = onPauseResume
        self.onReset = onReset
        self._previousTimeRemaining = State(initialValue: timeRemaining)
    }
    
    var isTotalTimeValid: Bool {
        totalTime > 0
    }
    
    var body: some View {
        ZStack {
            // Flip clock digits
            HStack {
                FlipDigit(
                    width: screenWidth,
                    digitType: .hour,
                    value: hours,
                    previousValue: previousHours,
                    isFlipping: isFlippingHours
                )
                
                FlipDigit(
                    width: screenWidth,
                    digitType: .minute,
                    value: minutes,
                    previousValue: previousMinutes,
                    isFlipping: isFlippingMinutes
                )
                
                FlipDigit(
                    width: screenWidth,
                    digitType: .second,
                    value: seconds,
                    previousValue: previousSeconds,
                    isFlipping: isFlippingSeconds
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // Status text overlay (Paused or Completed)
            VStack {
               SText("PAUSED")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.orange.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.orange, lineWidth: 1)
                            )
                    )
                    .offset(y: isPaused ? 10 : -50)
                    .opacity(isPaused ? 1 : 0)
                    .animation(.bouncy(duration: 0.3), value: isPaused)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.top, 20)
            
            // Reset button overlay
            VStack {
                Spacer()
                
                Label("RESET", systemImage: "arrow.trianglehead.counterclockwise")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.red.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                    )
                    .onTapGesture(perform: {
                        onReset()
                    })
                .offset(y: (isTotalTimeValid && (timeRemaining > 0 || timeRemaining <= 0)) ? 10 : 50)
                .opacity((isTotalTimeValid && (timeRemaining > 0 || timeRemaining <= 0)) ? 1 : 0)
                .animation(.bouncy(duration: 0.3), value: isTotalTimeValid && (timeRemaining > 0 || timeRemaining <= 0))
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(isTotalTimeValid ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .overlay {
            RoundedRectangle(cornerRadius: 40)
                .strokeBorder(isTotalTimeValid ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2), lineWidth: 1)
        }
        .padding()
        .onTapGesture {
            if isTotalTimeValid && timeRemaining > 0 {
                onPauseResume()
            }
        }
    }
    
    private var progress: Double {
        let elapsed = totalTime - timeRemaining
        return min(max(Double(elapsed) / Double(totalTime), 0.0), 1.0)
    }
    
    private var hours: Int {
        let absTime = abs(timeRemaining)
        return absTime / 3600
    }
    
    private var minutes: Int {
        let absTime = abs(timeRemaining)
        return (absTime % 3600) / 60
    }
    
    private var seconds: Int {
        let absTime = abs(timeRemaining)
        return absTime % 60
    }
    
    private var previousHours: Int {
        let absTime = abs(previousTimeRemaining)
        return absTime / 3600
    }
    
    private var previousMinutes: Int {
        let absTime = abs(previousTimeRemaining)
        return (absTime % 3600) / 60
    }
    
    private var previousSeconds: Int {
        let absTime = abs(previousTimeRemaining)
        return absTime % 60
    }
    
    
}

enum DigitType: String {
    case hour = "h"
    case minute = "m"
    case second = "s"
}

struct FlipDigit: View {
    var width: CGFloat
    let digitType: DigitType
    let value: Int
    let previousValue: Int
    let isFlipping: Bool
    
    var body: some View {
        HStack(alignment: .bottom) {
           SText("\(value)")
                .font(.funnelDisplay(size: 20))
                .foregroundStyle(Color.yellow)
            
           SText(digitType.rawValue)
                .foregroundStyle(Color.gray)
                .italic()
        }
        .frame(width: width / 4, height: 100)
    }
}

// MARK: - Horizontal Countdown View
struct HorizontalCountdownView: View {
    let activeTimers: [ActiveTimerState]
    let onPauseResume: (Timers) -> Void
    let onReset: (Timers) -> Void
    
    var body: some View {
        if activeTimers.isEmpty {
            // Show empty state when no active timers
            VStack {
                SText("No Active Timers")
                    .font(.funnelDisplay(size: 18))
                    .foregroundColor(.gray)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay {
                RoundedRectangle(cornerRadius: 40)
                    .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            }
            .padding()
        } else {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(Array(activeTimers.enumerated()), id: \.element.timer.id) { index, timerState in
                            TimerCountdownView(
                                timeRemaining: timerState.timeRemaining,
                                totalTime: Int(timerState.timer.duration),
                                isPaused: timerState.isPaused,
                                isCountdownRunning: timerState.timeRemaining > 0,
                                onPauseResume: {
                                    onPauseResume(timerState.timer)
                                },
                                onReset: {
                                    onReset(timerState.timer)
                                }
                            )
                            .frame(width: UIScreen.main.bounds.width)
                            .frame(height: 300)
                            .id(index)
                        }
                    }
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollTargetLayout()
            }
        }
    }
}

struct AllTimersView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Timers.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Timers.date, ascending: false)]) var timers: FetchedResults<Timers>
    
    @State private var toggleOnlyCompleted: Bool = false
    @State private var toggleOnlyNotCompleted: Bool = false
    @State private var toggleOnlyFlagged: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var totalCompleted: Int = 0
    @State private var totalNotCompleted: Int = 0
    @State private var totalFlagged: Int = 0
    
    // For presenting the sheet of the edit timer view
    @State var editTimerViewToggle: Bool = false
    
    @State var selectedTimer: Timers? = nil
    @State var showingEditTimerView: Bool = false
    
    // Multiple countdown state management
    @State private var activeTimers: [ActiveTimerState] = []
    
    //MARK: - Filtering timers when text entered in the search box
    var filteredTimers: [Timers] {
        // if the search field is empty
        guard !searchText.isEmpty else {
            if toggleOnlyFlagged && toggleOnlyCompleted {
                return timers.filter { $0.flag && $0.isCompleted }
            }
            if toggleOnlyFlagged && toggleOnlyNotCompleted {
                return timers.filter { $0.flag && !$0.isCompleted }
            }
            if toggleOnlyCompleted {
                return timers.filter { $0.isCompleted }
            }
            if toggleOnlyNotCompleted {
                return timers.filter { !$0.isCompleted }
            }
            if toggleOnlyFlagged {
                return timers.filter { $0.flag }
            }
            
            return Array(timers)
        }
        
        // if the search field is not empty
        return timers.filter { _ in
            if toggleOnlyFlagged && toggleOnlyCompleted {
                return true // Since timers don't have text to search, just filter by completion and flag
            }
            if toggleOnlyFlagged && toggleOnlyNotCompleted {
                return true // Since timers don't have text to search, just filter by completion and flag
            }
            if toggleOnlyCompleted {
                return true // Since timers don't have text to search, just filter by completion
            }
            if toggleOnlyNotCompleted {
                return true // Since timers don't have text to search, just filter by completion
            }
            if toggleOnlyFlagged {
                return true // Since timers don't have text to search, just filter by flag
            } else {
                return true // Show all timers when searching (since no text fields)
            }
        }
    }
    
    //MARK: - Grouping the filtered timers based on the date of creation
    var groupedTimers: [Date: [Timers]] {
        return Dictionary(grouping: filteredTimers) { timer in
            Calendar.current.startOfDay(for: timer.date!)
        }
    }
    
    //MARK: - Toggles for the showing or display of the add buttons and the edit view for the selected timer
    @State private var showingAddTimerView: Bool = false
    
    @State private var confirmationForDeletionOfCompletedTimers: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HorizontalCountdownView(
                        activeTimers: activeTimers,
                        onPauseResume: togglePauseResume,
                        onReset: resetTimer
                    )
                    
                    //MARK: - To display all the fetched timers in a list
                    List {
                        ForEach(groupedTimers.keys.sorted(by: >), id: \.self) { date in
                            ForEach(groupedTimers[date]!) { timer in
                                TimerListItemView(
                                    timer: timer,
                                    isActiveTimer: activeTimers.contains { $0.timer.id == timer.id },
                                    onTap: {
                                        handleTimerTap(timer)
                                    },
                                    onToggleCompletion: {
                                        timer.isCompleted.toggle()
                                        updateTimersCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    },
                                    onToggleFlag: {
                                        timer.flag.toggle()
                                        updateTimersCount()
                                        DataController.shared.save(context: managedObjectContext)
                                    },
                                    onDelete: {
                                        managedObjectContext.delete(timer)
                                        DataController.shared.save(context: managedObjectContext)
                                    },
                                    onEdit: {
                                        selectedTimer = timer
                                        showingEditTimerView = true
                                    }
                                )
                            }
                        }
                    }
                    .listStyle(InsetListStyle())
                    .listRowSpacing(10)
                    .environment(\.defaultMinListRowHeight, 0)
                    .overlay {
                        EmptyStateView(
                            timers: timers,
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
                        Text("Your Timers")
                            .font(.boldonse(size: 24))
                            .foregroundStyle(Color.yellow)
                    }
                }
            }
            .sheet(isPresented: $showingEditTimerView) {
                if let timer = selectedTimer {
                    EditTimerView(timer: timer)
                }
            }
            .onChange(of: showingEditTimerView) { isPresented in
                if !isPresented {
                    selectedTimer = nil
                }
            }
            .onAppear {
                updateTimersCount()
                managedObjectContext.undoManager = UndoManager()
            }
            .onChange(of: filteredTimers) {
                updateTimersCount()
            }
            
            //MARK: - Top horizontal scrollview bar featuring the toggle buttons to toggle the visibility buttons
            .safeAreaInset(edge: .bottom) {
                HStack {
                    FilterButtonsView(
                        toggleOnlyCompleted: $toggleOnlyCompleted,
                        toggleOnlyNotCompleted: $toggleOnlyNotCompleted,
                        toggleOnlyFlagged: $toggleOnlyFlagged,
                        confirmationForDeletionOfCompletedTimers: $confirmationForDeletionOfCompletedTimers,
                        totalCompleted: totalCompleted,
                        totalNotCompleted: totalNotCompleted,
                        totalFlagged: totalFlagged,
                        deleteCompletedTimers: deleteCompletedTimers
                    )
                    
                    //MARK: - View for the add timer button
                    AddTimerButton(
                        showingAddTimerView: $showingAddTimerView)
                }
            }
        }
    }
    
    private func deleteTimer(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                filteredTimers[$0]
            }.forEach(managedObjectContext.delete)
            
            DataController.shared.save(context: managedObjectContext)
        }
    }
    
    //MARK: - To update the status of the timers when any swipe action is completed
    private func updateTimersCount() {
        totalCompleted = calculateTotalCompleted()
        totalNotCompleted = calculateTotalNotCompleted()
        totalFlagged = calculateTotalFlagged()
    }
    
    private func calculateTotalCompleted() -> Int {
        return timers.reduce(0) {
            $0 + ($1.isCompleted ? 1 : 0)
        }
    }
    
    private func calculateTotalNotCompleted() -> Int {
        return timers.reduce(0) {
            $0 + (!$1.isCompleted ? 1 : 0)
        }
    }
    
    private func calculateTotalFlagged() -> Int {
        return timers.reduce(0) {
            $0 + ($1.flag ? 1 : 0)
        }
    }
    
    private func deleteCompletedTimers() {
        let completedTimersToDelete = timers.filter { $0.isCompleted == true }
        for timer in completedTimersToDelete {
            managedObjectContext.delete(timer)
        }
        DataController.shared.save(context: managedObjectContext)
    }
    
    // MARK: - Multiple Countdown Management
    private func handleTimerTap(_ timer: Timers) {
        if let existingIndex = activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
            // Remove timer from active list
            stopCountdown(for: timer)
        } else {
            // Add timer to active list
            startCountdown(for: timer)
        }
    }
    
    private func startCountdown(for timer: Timers) {
        // Create new active timer state
        var newTimerState = ActiveTimerState(timer: timer)
        
        // Add to active timers list first
        activeTimers.append(newTimerState)
        
        // Start the countdown on the main queue to ensure it runs independently
        DispatchQueue.main.async {
            if let index = self.activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
                self.activeTimers[index].countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    DispatchQueue.main.async {
                        if let currentIndex = self.activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
                            if self.activeTimers[currentIndex].timeRemaining > 0 && !self.activeTimers[currentIndex].isPaused {
                                self.activeTimers[currentIndex].timeRemaining -= 1
                            } else if self.activeTimers[currentIndex].timeRemaining <= 0 {
                                // Timer completed - don't remove, just stop the countdown
                                self.activeTimers[currentIndex].countdownTimer?.invalidate()
                                self.activeTimers[currentIndex].countdownTimer = nil
                            }
                        }
                    }
                }
                // Add timer to RunLoop to ensure it continues during scroll
                RunLoop.main.add(self.activeTimers[index].countdownTimer!, forMode: .common)
            }
        }
    }
    
    private func togglePauseResume(for timer: Timers) {
        if let index = activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
            if activeTimers[index].isPaused {
                // Resume countdown
                activeTimers[index].isPaused = false
                startTimer(for: timer)
            } else {
                // Pause countdown
                activeTimers[index].isPaused = true
                activeTimers[index].countdownTimer?.invalidate()
                activeTimers[index].countdownTimer = nil
            }
        }
    }
    
    private func startTimer(for timer: Timers) {
        if let index = activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
            // Invalidate any existing timer first
            activeTimers[index].countdownTimer?.invalidate()
            activeTimers[index].countdownTimer = nil
            
            DispatchQueue.main.async {
                if let currentIndex = self.activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
                    self.activeTimers[currentIndex].countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        DispatchQueue.main.async {
                            if let timerIndex = self.activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
                                if self.activeTimers[timerIndex].timeRemaining > 0 && !self.activeTimers[timerIndex].isPaused {
                                    self.activeTimers[timerIndex].timeRemaining -= 1
                                } else if self.activeTimers[timerIndex].timeRemaining <= 0 {
                                    // Timer completed - don't remove, just stop the countdown
                                    self.activeTimers[timerIndex].countdownTimer?.invalidate()
                                    self.activeTimers[timerIndex].countdownTimer = nil
                                }
                            }
                        }
                    }
                    // Add timer to RunLoop to ensure it continues during scroll
                    RunLoop.main.add(self.activeTimers[currentIndex].countdownTimer!, forMode: .common)
                }
            }
        }
    }
    
    private func stopCountdown(for timer: Timers) {
        if let index = activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
            activeTimers[index].countdownTimer?.invalidate()
            activeTimers[index].countdownTimer = nil
            activeTimers.remove(at: index)
        }
    }
    
    private func resetTimer(for timer: Timers) {
        if let index = activeTimers.firstIndex(where: { $0.timer.id == timer.id }) {
            // Stop current timer first
            activeTimers[index].countdownTimer?.invalidate()
            activeTimers[index].countdownTimer = nil
            
            // Reset to original duration
            activeTimers[index].timeRemaining = Int(timer.duration)
            activeTimers[index].isPaused = false
            
            // Start new timer
            startTimer(for: timer)
        }
    }
}

#Preview  {
    AllTimersView()
}

