//
//  EditCountdownView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI
import CoreData

struct EditCountdownView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    let countdown: Countdown
    
    @State private var title: String
    @State private var completionDate: Date
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(countdown: Countdown) {
        self.countdown = countdown
        self._title = State(initialValue: countdown.title ?? "")
        self._completionDate = State(initialValue: countdown.completionDate ?? Date())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Countdown Details") {
                    TextField("Countdown Title (Optional)", text: $title)
                }
                
                Section("Completion Date") {
                    DatePicker(
                        "Select Date",
                        selection: $completionDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                HStack {
                    Spacer()
                    
                    SText(formatTimeRemaining())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(isExpired() ? Color.red : Color.yellow)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(isExpired() ? Color.red.opacity(0.2) : Color.yellow.opacity(0.2), lineWidth: 1)
                        }
                    
                    Spacer()
                }
            }
            .navigationTitle("Edit Countdown")
        }
        .interactiveDismissDisabled()
        .background(.ultraThinMaterial)
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                // To save the countdown
                Button {
                    saveCountdown()
                } label: {
                    Label("Save Countdown", systemImage: "checkmark")
                }
                .padding()
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.newFont)
                .background(Color.yellow)
                .clipShape(Capsule())
                .disabled(title.isEmpty)
                
                // to dismiss the view if wanting to exit the edit view
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .padding()
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
    }
    
    private func saveCountdown() {
        countdown.title = title
        countdown.completionDate = completionDate
        
        DataController.shared.save(context: managedObjectContext)
        dismiss()
    }
    
    private func formatTimeRemaining() -> String {
        let timeInterval = completionDate.timeIntervalSince(currentTime)
        
        if timeInterval <= 0 {
            return "EXPIRED"
        }
        
        let days = Int(timeInterval) / 86400
        let hours = (Int(timeInterval) % 86400) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if days > 0 {
            return String(format: "%dd %02dh %02dm", days, hours, minutes)
        } else if hours > 0 {
            return String(format: "%dh %02dm %02ds", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%dm %02ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
    
    private func isExpired() -> Bool {
        return currentTime > completionDate
    }
}

#Preview {
    EditCountdownView(countdown: Countdown())
}
