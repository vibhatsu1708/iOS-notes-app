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
    
    var body: some View {
        
        ZStack {
            Color.black
            
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
            
            if didUnlock {
                ContentView()
                    .transition(AnyTransition.slide.animation(Animation.easeInOut))
            }
        }
        .ignoresSafeArea()
        .onAppear {
            self.showUnlockedView = true
        }
    }
}

#Preview {
    SplashScreenView()
}
