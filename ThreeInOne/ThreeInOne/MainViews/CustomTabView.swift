//
//  CustomTabView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 31/12/23.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    @ObservedObject private var customTabViewModel = CustomTabViewModel()
    
    // for default value of the stroke color, set the value to the above array's first accentColor value.
    @State private var currentTabBarStrokeColor: String = CustomTabViewModel().tabBarItems[0].accentColor
    
    var body: some View {
        ZStack {
            ZStack {
                Capsule()
                    .frame(width: 300, height: 60)
                    .foregroundStyle(Color(UIColor(hex: currentTabBarStrokeColor)))
                    .padding(.top, 30)
                Capsule()
                    .frame(height: 70)
                    .foregroundStyle(Color(.secondarySystemBackground))
                    .overlay {
                        Capsule()
                            .stroke(Color.secondary, lineWidth: 1.0)
                    }
            }
            
            HStack(spacing: 40) {
                ForEach(0..<3) { index in
                    Button {
                        tabSelection = index + 1
                        currentTabBarStrokeColor = customTabViewModel.tabBarItems[index].accentColor
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: customTabViewModel.tabBarItems[index].image)
                                .font(.title)
                            if index+1 == tabSelection {
                                Capsule()
                                    .frame(width: 20, height: 5)
                                    .foregroundStyle(index+1 == tabSelection ? Color(UIColor(hex: customTabViewModel.tabBarItems[index].accentColor)) : Color.clear)
                            }
                        }
                        .foregroundStyle(Color.newFont)
                        .padding()
//                        .padding(.vertical, 15)
//                        .padding(.horizontal, 50)
                        .clipShape(Capsule())
                    }
                }
            }
            .clipShape(Capsule())
        }
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}