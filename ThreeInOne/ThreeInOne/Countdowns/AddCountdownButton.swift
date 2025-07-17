//
//  AddCountdownButton.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct AddCountdownButton: View {
    @Binding var showingAddCountdownView: Bool
    
    var body: some View {
        Button {
            showingAddCountdownView.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(width: 70, height: 70)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                }
                .padding(.trailing)
        }
        .popover(isPresented: $showingAddCountdownView, content: {
            AddCountdownView()
                .background(.ultraThinMaterial)
                .presentationCompactAdaptation(.sheet)
        })
    }
}

#Preview {
    AddCountdownButton(showingAddCountdownView: .constant(false))
} 