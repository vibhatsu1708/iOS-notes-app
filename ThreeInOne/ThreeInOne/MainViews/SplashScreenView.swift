//
//  SplashScreenView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 09/01/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var showUnlockedView: Bool = false
    @State private var didUnlock: Bool = false
    
    @State private var angle: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color.black
            
//            VStack {
//                HStack {
//                    Rectangle()
//                        .frame(height: 80)
//                        .frame(maxWidth: .infinity)
//                }
//                
//                Spacer()
//            }
//            .frame(maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                Text("Simplify")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                if showUnlockedView {
                    SwipeToUnlockView()
                        .onSwipeSuccess {
                            withAnimation(Animation.easeInOut) {
                                self.didUnlock = true
                                self.showUnlockedView = false
                            }
                        }
                        .transition(AnyTransition.slide.animation(Animation.easeInOut))
                }
            }
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(.ultraThinMaterial)
            
            if didUnlock {
                ContentView()
                    .transition(AnyTransition.slide.animation(Animation.easeInOut))
            }
        }
        .ignoresSafeArea()
        .ignoresSafeArea()
        .onAppear {
            self.showUnlockedView = true
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SplashScreenView()
}
