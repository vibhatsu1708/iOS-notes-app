//
//  EmptyStateView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct EmptyStateView: View {
    let timers: FetchedResults<Timers>
    let toggleOnlyCompleted: Bool
    let toggleOnlyNotCompleted: Bool
    let toggleOnlyFlagged: Bool
    let calculateTotalCompleted: () -> Int
    let calculateTotalNotCompleted: () -> Int
    let calculateTotalFlagged: () -> Int
    
    var body: some View {
        Group {
            if timers.isEmpty && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false && toggleOnlyFlagged == false {
                VStack(spacing: 20) {
                    Image(systemName: "timer")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Timers")
                    HStack {
                       SText("Tap on the button to add a Timer.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyFlagged == true && calculateTotalFlagged() == 0 && toggleOnlyCompleted == false && toggleOnlyNotCompleted == false {
                VStack(spacing: 20) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Flagged Timers")
                    HStack {
                       SText("Swipe on a Timer to Flag it.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyCompleted == true && calculateTotalCompleted() == 0 && toggleOnlyFlagged == false {
                VStack(spacing: 20) {
                    Image(systemName: "checklist.checked")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Completed Timers")
                    HStack {
                       SText("Swipe on a Timer to Complete it.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyNotCompleted == true && calculateTotalNotCompleted() == 0 && toggleOnlyFlagged == false {
                VStack(spacing: 20) {
                    Image(systemName: "checklist.unchecked")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Incompleted Timers")
                    HStack {
                       SText("Tap on the button to add a Timer.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyFlagged == true && toggleOnlyCompleted == true && (calculateTotalFlagged() == 0 || calculateTotalCompleted() == 0) {
                VStack(spacing: 20) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Flagged Completed Timers")
                    HStack {
                       SText("Flag and Complete a Timer to see it here.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if toggleOnlyFlagged == true && toggleOnlyNotCompleted == true && (calculateTotalFlagged() == 0 || calculateTotalNotCompleted() == 0) {
                VStack(spacing: 20) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .padding()
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                   SText("No Flagged Incompleted Timers")
                    HStack {
                       SText("Flag an Incompleted Timer to see it here.")
                    }
                    Spacer()
                }
                .padding(.top, 50)
            }
        }
    }
}
