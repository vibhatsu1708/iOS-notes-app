//
//  CountdownView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct CountdownView: View {
    let countdown: Countdown
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                timeRemainingText
                
                Spacer()
                
                CountdownStatusView(isExpired: isExpired())
            }
            
            // Countdown title
            if let title = countdown.title, !title.isEmpty {
               SText(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
            }
            
            HStack(alignment: .center) {
                if let completionDate = countdown.completionDate {
                    CountdownTagView(
                        countdown: countdown,
                        text: formatDate(completionDate),
                        systemName: "target",
                        type: .completionDate
                    )
                }
                
                CountdownTagView(
                    countdown: countdown,
                    text: nil,
                    systemName: countdown.isCompleted ? "checkmark.circle.fill" : "circle",
                    type: .completedStatus
                )
                
                CountdownTagView(
                    countdown: countdown,
                    text: nil,
                    systemName: countdown.flag ? "flag.fill" : "flag",
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
                .strokeBorder(borderColor, lineWidth: 1)
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    private var timeRemainingText: some View {
        SText(formatTimeRemaining())
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(timeRemainingColor)
    }
    
    private var timeRemainingColor: Color {
        isExpired() ? Color.red : Color.yellow
    }
    
    private var borderColor: Color {
        isExpired() ? Color.red.opacity(0.2) : Color.white.opacity(0.2)
    }
    
    private func formatTimeRemaining() -> String {
        guard let completionDate = countdown.completionDate else {
            return "No date set"
        }
        
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
        guard let completionDate = countdown.completionDate else {
            return false
        }
        return currentTime > completionDate
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct CountdownStatusView: View {
    let isExpired: Bool
    
    var body: some View {
        Image(systemName: statusIcon)
            .resizable()
            .scaledToFit()
            .foregroundStyle(statusColor)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .fill(statusBackgroundColor)
                    .strokeBorder(statusBorderColor)
            )
            .frame(width: UIScreen.main.bounds.width * 0.1)
    }
    
    private var statusIcon: String {
        isExpired ? "exclamationmark.triangle.fill" : "clock.fill"
    }
    
    private var statusColor: Color {
        isExpired ? Color.red : Color.yellow
    }
    
    private var statusBackgroundColor: Color {
        isExpired ? Color.red.opacity(0.1) : Color.yellow.opacity(0.1)
    }
    
    private var statusBorderColor: Color {
        isExpired ? Color.red.opacity(0.2) : Color.yellow.opacity(0.2)
    }
}

public struct CountdownTagView: View {
    enum TagType {
        case completionDate
        case flag
        case completedStatus
    }
    
    let countdown: Countdown
    let text: String?
    let systemName: String
    let type: TagType
    
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
    
    private var foregroundColor: Color {
        switch type {
        case .completionDate:
            return Color.blue
        case .completedStatus:
            return countdown.isCompleted ? Color.indigo : Color.red
        case .flag:
            return countdown.flag ? Color.yellow : Color.gray
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .completionDate:
            return Color.blue.opacity(0.1)
        case .completedStatus:
            return countdown.isCompleted ? Color.indigo.opacity(0.1) : Color.red.opacity(0.1)
        case .flag:
            return countdown.flag ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        switch type {
        case .completionDate:
            return Color.blue.opacity(0.2)
        case .completedStatus:
            return countdown.isCompleted ? Color.indigo.opacity(0.2) : Color.red.opacity(0.2)
        case .flag:
            return countdown.flag ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2)
        }
    }
}

#Preview {
    CountdownView(countdown: Countdown())
} 