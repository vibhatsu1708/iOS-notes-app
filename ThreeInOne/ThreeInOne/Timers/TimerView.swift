//
//  TimerView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct TimerView: View {
    let timer: Timers
    let isActiveTimer: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
               SText(formatDuration(timer.duration))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(isActiveTimer ? Color.red : Color.yellow)
                    .animation(.easeInOut(duration: 0.3), value: isActiveTimer)
                
                Spacer()
                
                PlayPauseView(isActiveTimer: isActiveTimer)
            }
            
            // Timer name and description
            if let name = timer.name, !name.isEmpty {
               SText(name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
            }
            
            if let desc = timer.desc, !desc.isEmpty {
               SText(desc)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .lineLimit(2)
            }
            
            HStack(alignment: .center) {
                if let date = timer.date {
                    TimerTagView(
                        timer: timer,
                        text: formatDate(date),
                        systemName: "calendar",
                        type: .dateAdded
                    )
                }
                
                TimerTagView(
                    timer: timer,
                    text: nil,
                    systemName: timer.isCompleted ? "checkmark.circle.fill" : "circle",
                    type: .completedStatus
                )
                
                TimerTagView(
                    timer: timer,
                    text: nil,
                    systemName: timer.flag ? "flag.fill" : "flag",
                    type: .flag
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(isActiveTimer ? Color.red.opacity(0.2) : Color.white.opacity(0.2), lineWidth: 1)
        }
        .onTapGesture {
            onTap()
        }
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let totalSeconds = Int(duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%dh %02dm %02ds", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%dm %02ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct PlayPauseView: View {
    let isActiveTimer: Bool
    
    var body: some View {
        Image(systemName: isActiveTimer ? "pause.fill" : "play.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(isActiveTimer ? Color.red : Color.yellow)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .fill(isActiveTimer ? Color.red.opacity(0.1) : Color.yellow.opacity(0.1))
                    .strokeBorder(isActiveTimer ? Color.red.opacity(0.2) : Color.yellow.opacity(0.2))
            )
            .frame(width: UIScreen.main.bounds.width * 0.1)
    }
}

public struct TimerTagView: View {
    enum TagType {
        case dateAdded
        case flag
        case completedStatus
    }
    
    let timer: Timers
    let text: String?
    let systemName: String
    let type: TagType
    
    private var foregroundColor: Color {
        switch type {
        case .dateAdded:
            return Color.gray
        case .completedStatus:
            return timer.isCompleted ? Color.indigo : Color.red
        case .flag:
            return timer.flag ? Color.yellow : Color.gray
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .dateAdded:
            return Color.gray.opacity(0.1)
        case .completedStatus:
            return timer.isCompleted ? Color.indigo.opacity(0.1) : Color.red.opacity(0.1)
        case .flag:
            return timer.flag ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        switch type {
        case .dateAdded:
            return Color.gray.opacity(0.2)
        case .completedStatus:
            return timer.isCompleted ? Color.indigo.opacity(0.2) : Color.red.opacity(0.2)
        case .flag:
            return timer.flag ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2)
        }
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(foregroundColor)
            
            if let text = text, !text.isEmpty {
               SText(text, color: foregroundColor)
                    .font(.caption2)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .fill(backgroundColor)
                .strokeBorder(borderColor, lineWidth: 1)
        )
    }
}

//#Preview {
//    TimerView(timer: Timers())
//}

