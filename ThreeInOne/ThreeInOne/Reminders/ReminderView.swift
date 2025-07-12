//
//  ReminderView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct ReminderView: View {
    @StateObject var reminder: Reminder
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .frame(height: 15)
                .foregroundStyle(reminder.completed ? Color.indigo : Color.red)
            VStack(alignment: .leading, spacing: 10) {
                if let title = reminder.name {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundStyle(reminder.completed ? Color.secondary : Color.white)
                }
                
                if let description = reminder.reminder_desc, description.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    Text(reminder.reminder_desc!)
                        .font(.subheadline)
                        .foregroundStyle(reminder.completed ? Color.secondary : Color.white)
                }
                
                FlagView(reminder: reminder)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(reminder.completed ? Color.indigo.opacity(0.1) : Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20.0)
                .strokeBorder(reminder.completed ? Color.indigo.opacity(0.1) : Color.red.opacity(0.1), lineWidth: 1)
        }
        .padding(.horizontal, 10)
    }
}

public struct FlagView: View {
    @StateObject var reminder: Reminder
    
    public var body: some View {
        Image(systemName: "flag.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(reminder.flag ? Color.yellow.opacity(1.0) : Color.gray.opacity(0.1))
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .fill(reminder.flag ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
                    .strokeBorder(reminder.flag ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2))
            )
            .frame(width: UIScreen.main.bounds.width * 0.1)
    }
}

