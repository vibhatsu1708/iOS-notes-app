//
//  AddCountdownView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI
import CoreData

struct AddCountdownView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var completionDate: Date = Date()
    @State private var showingDatePicker: Bool = false
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title input
                VStack(alignment: .leading, spacing: 8) {
                   SText("Countdown Title")
                        .font(.headline)
                        .foregroundStyle(Color.yellow)
                    
                    TextField("Enter countdown title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 16))
                }
                
                // Completion date selection
                VStack(alignment: .leading, spacing: 8) {
                   SText("Completion Date")
                        .font(.headline)
                        .foregroundStyle(Color.yellow)
                    
                    Button {
                        showingDatePicker.toggle()
                    } label: {
                        HStack {
                           SText(formatDate(completionDate))
                                .foregroundStyle(Color.primary)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .foregroundStyle(Color.yellow)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                    }
                }
                
                // Preview of time remaining
                VStack(alignment: .leading, spacing: 8) {
                   SText("Time Remaining")
                        .font(.headline)
                        .foregroundStyle(Color.yellow)
                    
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
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Countdown")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCountdown()
                    }
                    .foregroundStyle(Color.yellow)
                    .disabled(title.isEmpty)
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerView(selectedDate: $completionDate)
            }
            .onReceive(timer) { _ in
                currentTime = Date()
            }
        }
    }
    
    private func saveCountdown() {
        let newCountdown = Countdown(context: managedObjectContext)
        newCountdown.title = title
        newCountdown.completionDate = completionDate
        newCountdown.flag = false
        newCountdown.isCompleted = false
        
        DataController.shared.save(context: managedObjectContext)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
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

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.yellow)
                }
            }
        }
    }
}

#Preview {
    AddCountdownView()
} 
