//
//  EmptyCountdownStateView.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct EmptyCountdownStateView: View {
    let countdowns: FetchedResults<Countdown>
    let toggleOnlyCompleted: Bool
    let toggleOnlyNotCompleted: Bool
    let toggleOnlyFlagged: Bool
    let calculateTotalCompleted: () -> Int
    let calculateTotalNotCompleted: () -> Int
    let calculateTotalFlagged: () -> Int
    
    var body: some View {
        if shouldShowEmptyState {
            VStack(spacing: 20) {
                Image(systemName: "clock.badge.exclamationmark")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.red)
                
               SText(emptyStateTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primary)
                
               SText(emptyStateMessage)
                    .font(.body)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
        }
    }
    
    private var shouldShowEmptyState: Bool {
        if toggleOnlyCompleted {
            return calculateTotalCompleted() == 0
        } else if toggleOnlyNotCompleted {
            return calculateTotalNotCompleted() == 0
        } else if toggleOnlyFlagged {
            return calculateTotalFlagged() == 0
        } else {
            return countdowns.isEmpty
        }
    }
    
    private var emptyStateTitle: String {
        if toggleOnlyCompleted {
            return "No Completed Countdowns"
        } else if toggleOnlyNotCompleted {
            return "No Active Countdowns"
        } else if toggleOnlyFlagged {
            return "No Flagged Countdowns"
        } else {
            return "No Countdowns Yet"
        }
    }
    
    private var emptyStateMessage: String {
        if toggleOnlyCompleted {
            return "You haven't completed any countdowns yet. Start creating countdowns and mark them as completed when they're done!"
        } else if toggleOnlyNotCompleted {
            return "All your countdowns are completed! Create new countdowns to track upcoming events."
        } else if toggleOnlyFlagged {
            return "You haven't flagged any countdowns yet. Flag important countdowns to keep track of them easily!"
        } else {
            return "Create your first countdown to start tracking time towards important events and deadlines."
        }
    }
}

//#Preview {
//    EmptyCountdownStateView(
//        countdowns: FetchedResults<Countdown>(),
//        toggleOnlyCompleted: false,
//        toggleOnlyNotCompleted: false,
//        toggleOnlyFlagged: false,
//        calculateTotalCompleted: { 0 },
//        calculateTotalNotCompleted: { 0 },
//        calculateTotalFlagged: { 0 }
//    )
//} 
