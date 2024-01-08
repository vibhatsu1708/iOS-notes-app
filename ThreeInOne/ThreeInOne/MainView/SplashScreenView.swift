//
//  SplashScreenView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 09/01/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
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
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.size = 1.0
                        self.opacity = 1.0
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
