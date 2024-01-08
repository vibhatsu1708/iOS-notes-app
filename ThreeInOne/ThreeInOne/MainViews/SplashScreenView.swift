//
//  SplashScreenView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 09/01/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("iSimplify")
                        .font(.system(size: 40))
                        .foregroundStyle(Color(UIColor(hex: "232528")))
                        .fontWeight(.heavy)
                    HStack(spacing: 5) {
                        Group {
                            Circle()
                                .foregroundStyle(Color(UIColor(hex: "6AB547")))
                            Circle()
                                .foregroundStyle(Color(UIColor(hex: "F64740")))
                            Circle()
                                .foregroundStyle(Color(UIColor(hex: "8A4FFF")))
                        }
                        .frame(height: 15)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor(hex: "FDF0D5")))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
