//
//  EditTimerView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI
import CoreData

struct EditTimerView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    let timer: Timers
    
    @State private var name: String = ""
    @State private var desc: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Timer Details") {
                    TextField("Timer Name (Optional)", text: $name)
                    
                    TextField("Description (Optional)", text: $desc, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Timer Duration") {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24, id: \.self) { hour in
                               SText("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { minute in
                               SText("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                        
                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60, id: \.self) { second in
                               SText("\(second)s").tag(second)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Section {
                   SText("Total Duration: \(formatDuration())")
                        .font(.headline)
                        .foregroundStyle(Color.newFont)
                }
            }
            .navigationTitle("Edit Timer")
        }
        .interactiveDismissDisabled()
        .background(.ultraThinMaterial)
        .onAppear {
            // Load existing timer data
            name = timer.name ?? ""
            desc = timer.desc ?? ""
            
            // Convert duration to hours, minutes, seconds
            let totalSeconds = Int(timer.duration)
            hours = totalSeconds / 3600
            minutes = (totalSeconds % 3600) / 60
            seconds = totalSeconds % 60
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                // To save the edited timer
                Button {
                    let totalDuration = Double(hours * 3600 + minutes * 60 + seconds)
                    if totalDuration > 0 {
                        DataController.shared.editTimer(
                            timer: timer,
                            name: name.isEmpty ? nil : name,
                            desc: desc.isEmpty ? nil : desc,
                            duration: totalDuration,
                            isCompleted: timer.isCompleted,
                            context: managedObjectContext
                        )
                        dismiss()
                    }
                } label: {
                    Label("Save Timer", systemImage: "checkmark")
                }
                .padding()
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.newFont)
                .background(Color.yellow)
                .clipShape(Capsule())
                .disabled(hours == 0 && minutes == 0 && seconds == 0)
                
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
    
    private func formatDuration() -> String {
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        let h = totalSeconds / 3600
        let m = (totalSeconds % 3600) / 60
        let s = totalSeconds % 60
        
        if h > 0 {
            return "\(h)h \(m)m \(s)s"
        } else if m > 0 {
            return "\(m)m \(s)s"
        } else {
            return "\(s)s"
        }
    }
}

#Preview {
    EditTimerView(timer: Timers())
}
