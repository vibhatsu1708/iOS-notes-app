//
//  EmptyReminderStateView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 18/07/25.
//

import SwiftUI

struct EmptyReminderStateView: View {
    let reminders: FetchedResults<Reminder>
    let toggleOnlyCompleted: Bool
    let toggleOnlyNotCompleted: Bool
    let toggleOnlyFlagged: Bool
    let toggleOnlyArchived: Bool
    let calculateTotalCompleted: () -> Int
    let calculateTotalNotCompleted: () -> Int
    let calculateTotalFlagged: () -> Int
    let calculateTotalArchived: () -> Int
    
    var body: some View {
        Group {
            if reminders.isEmpty && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false && toggleOnlyFlagged == false && toggleOnlyArchived == false {
                VStack(spacing: 20) {
                    Image(systemName: "checklist")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Todos to do")
                    HStack {
                       SText("Tap on the button to add a Todo.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyFlagged == true && calculateTotalFlagged() == 0 && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false && toggleOnlyArchived == false {
                VStack(spacing: 20) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Flagged Todos to do")
                    HStack {
                       SText("Swipe on a Todo to flag.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyCompleted == true && calculateTotalCompleted() == 0 && toggleOnlyFlagged == false && toggleOnlyArchived == false {
                VStack(spacing: 20) {
                    Image(systemName: "checklist.checked")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Completed Todos")
                    HStack {
                       SText("Swipe on a Todo to Complete a Todo.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyNotCompleted == true && calculateTotalNotCompleted() == 0 && toggleOnlyFlagged == false && toggleOnlyArchived == false {
                VStack(spacing: 20) {
                    Image(systemName: "checklist.unchecked")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Incompleted Todos")
                    HStack {
                       SText("Tap on the button to add a Todo.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyArchived == true && calculateTotalArchived() == 0 && toggleOnlyFlagged == false && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false {
                VStack(spacing: 20) {
                    Image(systemName: "archivebox")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Archived Todos")
                    HStack {
                       SText("Archive completed todos to see them here.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyFlagged == true && toggleOnlyCompleted == true && (calculateTotalFlagged() == 0 || calculateTotalCompleted() == 0) && toggleOnlyArchived == false {
                VStack(spacing: 20) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Flagged Completed Todos")
                    HStack {
                       SText("Flag and Complete a Todo to see it here.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyFlagged == true && toggleOnlyNotCompleted == true && (calculateTotalFlagged() == 0 || calculateTotalNotCompleted() == 0) && toggleOnlyArchived == false {
                VStack(spacing: 20) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Flagged Incompleted Todos")
                    HStack {
                       SText("Flag an Incompleted Todo to see it here.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyFlagged == true && toggleOnlyArchived == true && (calculateTotalFlagged() == 0 || calculateTotalArchived() == 0) {
                VStack(spacing: 20) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Flagged Archived Todos")
                    HStack {
                       SText("Flag and Archive a Todo to see it here.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
        }
    }
}

//#Preview {
//    EmptyReminderStateView(
//        reminders: FetchedResults<Reminder>(),
//        toggleOnlyCompleted: false,
//        toggleOnlyNotCompleted: false,
//        toggleOnlyFlagged: false,
//        toggleOnlyArchived: false,
//        calculateTotalCompleted: { 0 },
//        calculateTotalNotCompleted: { 0 },
//        calculateTotalFlagged: { 0 },
//        calculateTotalArchived: { 0 }
//    )
//}
