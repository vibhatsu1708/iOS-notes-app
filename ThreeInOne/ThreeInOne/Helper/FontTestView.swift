//
//  FontTestView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

struct FontTestView: View {
    var body: some View {
        VStack(spacing: 20) {
           SText("Testing Custom Fonts")
                .font(.title)
                .padding()
            
           SText("LuckiestGuy-Regular")
                .font(.luckiestGuy(size: 30))
                .foregroundColor(.blue)
            
           SText("FunnelDisplay-VariableFont_wght")
                .font(.funnelDisplay(size: 30))
                .foregroundColor(.green)
            
           SText("Boldonse-Regular")
                .font(.boldonse(size: 30))
                .foregroundColor(.purple)
            
           SText("System Font (Fallback)")
                .font(.system(size: 30))
                .foregroundColor(.red)
            
            // Testing SText (uses default font automatically)
            SText("SText with default font")
                .foregroundColor(.orange)
            
            SText("SText with custom size", size: 20)
                .foregroundColor(.pink)
            
            // Testing regular Text with funnelDisplay extension
           SText("Regular Text with funnelDisplay")
//                .funnelDisplay(size: 18)
                .foregroundColor(.cyan)
            
            Button("Print Available Fonts") {
                UIFont.printAvailableFonts()
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .withDefaultFont(.funnelDisplay(size: 16)) // Set default font for this view
    }
}

#Preview {
    FontTestView()
}
