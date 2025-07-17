//
//  CountdownListItemView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct CountdownListItemView: View {
    let countdown: Countdown
    let onToggleCompletion: () -> Void
    let onToggleFlag: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        CountdownView(
            countdown: countdown
        )
        .swipeActions(edge: .leading) {
            Button {
                onToggleCompletion()
            } label: {
                Label(countdown.isCompleted ? "Not Done" : "Done", systemImage: "checklist.checked")
                    .tint(countdown.isCompleted ? Color.red : Color.indigo)
            }
        }
        .swipeActions(edge: .trailing) {
            Button {
                onToggleFlag()
            } label: {
                Label(countdown.flag ? "Unflag" : "Flag", systemImage: countdown.flag ? "flag.slash.fill" : "flag.fill")
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

#Preview {
    CountdownListItemView(
        countdown: Countdown(),
        onToggleCompletion: {},
        onToggleFlag: {},
        onDelete: {},
        onEdit: {}
    )
} 
