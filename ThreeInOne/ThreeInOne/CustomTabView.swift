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
    
    let tabBarItems: [(image: String, title: String, accentColor: String, gradientColorOne: String, gradientColorTwo: String)] = [
        ("note.text", "Notes", "F87666", "F87666", "8A4FFF"),
        ("text.badge.checkmark", "Todos", "FFBA08", "FFBA08", "FE5E41")
    ]
    
    // for default value of the stroke color, set the value to the above array's first accentColor value.
    @State private var currentTabBarStrokeColor: String = "8A4FFF"
    
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
            
            HStack {
                ForEach(0..<2) { index in
                    Spacer()
                    Button {
                        tabSelection = index + 1
                        currentTabBarStrokeColor = tabBarItems[index].gradientColorTwo
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: tabBarItems[index].image)
                                .font(.title)
                            if index+1 == tabSelection {
                                Capsule()
                                    .frame(width: 20, height: 5)
                                    .foregroundStyle(index+1 == tabSelection ? Color(UIColor(hex: tabBarItems[index].gradientColorTwo)) : Color.clear)
                            }
                        }
                        .foregroundStyle(Color.newFont)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 50)
                        .clipShape(Capsule())
                    }
                    Spacer()
                }
            }
            .clipShape(Capsule())
        }
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}
