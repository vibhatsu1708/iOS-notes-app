//
//  AddTimerView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI
import CoreData

struct AddTimerView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
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
                
                Section("Timer Duration: \(formatDuration())") {
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
            }
            .navigationTitle("New Timer")
        }
        .interactiveDismissDisabled()
        .background(.ultraThinMaterial)
        .safeAreaInset(edge: .bottom) {
            HStack {
                // To add the new timer
                Button {
                    let totalDuration = Double(hours * 3600 + minutes * 60 + seconds)
                    if totalDuration > 0 {
                        DataController.shared.addTimer(
                            name: name.isEmpty ? nil : name,
                            desc: desc.isEmpty ? nil : desc,
                            duration: totalDuration,
                            isCompleted: false,
                            context: managedObjectContext
                        )
                        dismiss()
                    }
                } label: {
                    Label("Add Timer", systemImage: "plus")
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
    AddTimerView()
}

