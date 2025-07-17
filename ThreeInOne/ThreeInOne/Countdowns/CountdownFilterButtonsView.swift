//
//  CountdownFilterButtonsView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct CountdownFilterButtonsView: View {
    @Binding var toggleOnlyCompleted: Bool
    @Binding var toggleOnlyNotCompleted: Bool
    @Binding var toggleOnlyFlagged: Bool
    @Binding var confirmationForDeletionOfCompletedCountdowns: Bool
    let totalCompleted: Int
    let totalNotCompleted: Int
    let totalFlagged: Int
    let deleteCompletedCountdowns: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                                            // to toggle all the filters to false, or to turn them off
                            Button {
                                toggleOnlyCompleted = false
                                toggleOnlyNotCompleted = false
                                toggleOnlyFlagged = false
                            } label: {
                    Group {
                        Image(systemName: "eraser.fill")
                    }
                    .bold()
                }
                .padding(10)
                .foregroundStyle(Color.newFont)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 2)
                }
                .padding(.leading)
                
                // Circle divider
                Circle()
                    .frame(height: 5)
                    .opacity(0.5)
                
                                            // to toggle the flagged countdowns
                            Button {
                                toggleOnlyFlagged.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "flag.fill")
                                        .foregroundStyle(Color.yellow)
                                        .opacity(toggleOnlyFlagged ? 1.0 : 0.5)
                                        .padding(.leading, 10)
                                   SText("Flagged")
                                   SText("\(totalFlagged)")
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 10)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(10)
                            .foregroundStyle(Color.newFont)
                            .background(toggleOnlyFlagged ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                            .clipShape(Capsule())
                            
                            // to toggle the completed countdowns
                            Button {
                                if toggleOnlyNotCompleted {
                                    toggleOnlyNotCompleted = false
                                }
                                if toggleOnlyFlagged {
                                    toggleOnlyFlagged = false
                                }
                                toggleOnlyCompleted.toggle()
                            } label: {
                    HStack {
                        Circle()
                            .frame(height: 15)
                            .foregroundStyle(Color(UIColor(hex: "5863F8")))
                            .opacity(toggleOnlyCompleted ? 1.0 : 0.5)
                            .padding(.leading, 10)
                       SText("Completed")
                       SText("\(totalCompleted)")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(10)
                .foregroundStyle(Color.newFont)
                .background(toggleOnlyCompleted ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                .clipShape(Capsule())
                
                                            // to toggle the not completed countdowns
                            Button {
                                if toggleOnlyCompleted {
                                    toggleOnlyCompleted = false
                                }
                                if toggleOnlyFlagged {
                                    toggleOnlyFlagged = false
                                }
                                toggleOnlyNotCompleted.toggle()
                            } label: {
                    HStack {
                        Circle()
                            .frame(height: 15)
                            .foregroundStyle(Color(UIColor(hex: "FF686B")))
                            .opacity(toggleOnlyNotCompleted ? 1.0 : 0.5)
                            .padding(.leading, 10)
                       SText("Not Completed")
                       SText("\(totalNotCompleted)")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(10)
                .foregroundStyle(Color.newFont)
                .background(toggleOnlyNotCompleted ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                .clipShape(Capsule())
                
                // Circle divider
                Circle()
                    .frame(height: 5)
                    .opacity(0.5)
                
                // confirmation for the deleting of the completed countdowns
                Button {
                    confirmationForDeletionOfCompletedCountdowns = true
                } label: {
                    Image(systemName: "trash.fill")
                }.confirmationDialog("Are you sure you want to Delete all the Completed Countdowns?", isPresented: $confirmationForDeletionOfCompletedCountdowns, titleVisibility: .visible, actions: {
                    Button("Delete", role: .destructive, action: deleteCompletedCountdowns)
                    Button("Cancel", role: .cancel, action: {})
                })
                .padding(10)
                .background(Color(UIColor(hex: "E71D36")).opacity(0.4))
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.trailing)
            }
        }
        .frame(height: 70)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .overlay {
            RoundedRectangle(cornerRadius: 20.0)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
        }
        .padding(.leading)
        .padding(.top)
        .padding(.bottom)
    }
}

#Preview {
    CountdownFilterButtonsView(
        toggleOnlyCompleted: .constant(false),
        toggleOnlyNotCompleted: .constant(false),
        toggleOnlyFlagged: .constant(false),
        confirmationForDeletionOfCompletedCountdowns: .constant(false),
        totalCompleted: 0,
        totalNotCompleted: 0,
        totalFlagged: 0,
        deleteCompletedCountdowns: {}
    )
} 