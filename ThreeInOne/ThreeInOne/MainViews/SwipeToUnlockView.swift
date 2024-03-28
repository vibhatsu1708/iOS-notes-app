//
//  SwipeToUnlockView.swift
//  SwipeToUnlockFunctionality
//
//  Created by Vedant Mistry on 29/03/24.
//

import SwiftUI

extension Comparable {
    func clamp<T: Comparable>(lower: T, upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
}

extension CGSize {
    static var inactiveThumbSize: CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    static var activeThumbSize: CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    static var trackSize: CGSize {
        return CGSize(width: 300, height: 70)
    }
}

extension SwipeToUnlockView {
    func onSwipeSuccess(action: @escaping() -> Void) -> Self {
        var this = self
        this.actionSuccess = action
        
        return this
    }
}

struct SwipeToUnlockView: View {
    @State private var thumbSize: CGSize = CGSize.inactiveThumbSize
    
    @State private var dragOffset: CGSize = .zero
    
    @State private var isSwipedEnough: Bool = false
    
    let trackSize: CGSize = CGSize.trackSize
    
    private var actionSuccess: (() -> Void)?
    
    @State var indexColor: Int = 0
    var sliderColors: [Color] = [Color.indigo, Color.green, Color.red]
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var swipeToEnterTextVisible: Bool = true
    @State private var welcomeTextVisible: Bool = false
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: trackSize.width, height: trackSize.height)
                .foregroundColor(sliderColors[indexColor % sliderColors.count])
            
            HStack {
                Text("Swipe to enter")
                    .offset(x: 40)
                    .opacity(swipeToEnterTextVisible ? 1.0 : 0.0)
            }
            .padding(.horizontal, 35)
            .overlay {
                HStack {
                    Text("Welcome")
                        .opacity(welcomeTextVisible ? 1.0 : 0.0)
                    Spacer()
                }
            }
            .font(.headline)
            .foregroundStyle(Color.white)
            .frame(width: trackSize.width, height: trackSize.height)
            
            ZStack {
                Circle()
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(width: thumbSize.width, height: thumbSize.height)
                    .overlay {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
            }
            .offset(
                x: getDragOffsetX(),
                y: 0
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.handleDragChanged(value: value)
                    }
                    .onEnded { value in
                        self.handleDragEnded()
                    }
            )
        }
        .shadow(color: sliderColors[indexColor % sliderColors.count].opacity(0.7), radius: 40)
        .onReceive(timer) { value in
            withAnimation(Animation.easeInOut) {
                indexColor += 1
            }
        }
    }
    
    private func getDragOffsetX() -> CGFloat {
        let clampedDragOffsetX = dragOffset.width.clamp(lower: 0, upper: trackSize.width - thumbSize.width)
        return -((trackSize.width / 2) - (thumbSize.width / 2) - clampedDragOffsetX)
    }
    
    private func handleDragChanged(value: DragGesture.Value) {
        self.dragOffset = value.translation
        
        let dragWidth = value.translation.width
        let targetDragWidth = self.trackSize.width - (self.thumbSize.width * 2)
        let wasInitiated = dragWidth > 2
        let didReachTarget = dragWidth > targetDragWidth
        
        self.thumbSize = wasInitiated ? CGSize.activeThumbSize : CGSize.inactiveThumbSize
        
        withAnimation(Animation.easeInOut) {
            if didReachTarget {
                self.isSwipedEnough = true
                self.swipeToEnterTextVisible = false
                self.welcomeTextVisible = true
            } else {
                self.isSwipedEnough = false
                self.swipeToEnterTextVisible = true
                self.welcomeTextVisible = false
            }
        }
        
    }
    
    private func handleDragEnded() {
        withAnimation(Animation.spring) {
            if self.isSwipedEnough {
                self.dragOffset = CGSize(
                    width: self.trackSize.width - self.thumbSize.width,
                    height: 0
                )
                
                if nil != self.actionSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.actionSuccess!()
                    }
                }
            } else {
                self.dragOffset = .zero
                self.thumbSize = CGSize.inactiveThumbSize
            }
        }
    }
}

#Preview {
    SwipeToUnlockView()
}
