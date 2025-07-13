//
//  TimerListItemView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct TimerListItemView: View {
    let timer: Timers
    let isActiveTimer: Bool
    let onTap: () -> Void
    let onToggleCompletion: () -> Void
    let onToggleFlag: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        TimerView(
            timer: timer,
            isActiveTimer: isActiveTimer,
            onTap: onTap
        )
        .swipeActions(edge: .leading) {
            Button {
                onToggleCompletion()
            } label: {
                Label(timer.isCompleted ? "Not Done" : "Done", systemImage: "checklist.checked")
                    .tint(timer.isCompleted ? Color.red : Color.indigo)
            }
        }
        .swipeActions(edge: .trailing) {
            Button {
                onToggleFlag()
            } label: {
                Label(timer.flag ? "Unflag" : "Flag", systemImage: timer.flag ? "flag.slash.fill" : "flag.fill")
                    .tint(Color.yellow)
            }
        }
        .contextMenu {
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(.zero))
        .listRowSeparator(.hidden)
        .padding(.horizontal, 10)
    }
}
