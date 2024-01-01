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
    
    let tabBarItems: [(image: String, title: String, accentColor: String)] = [
        ("note.text", "Notes", "5448C8"),
        ("text.badge.checkmark", "Todos", "FC7A1E")
    ]
    
    // for default value of the stroke color, set the value to the above array's first accentColor value.
    @State private var currentTabBarStrokeColor: String = "5448C8"
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 80)
                .foregroundStyle(Color(.secondarySystemBackground))
            
            HStack {
                ForEach(0..<2) { index in
                    Spacer()
                    Button {
                        tabSelection = index + 1
                        currentTabBarStrokeColor = tabBarItems[index].accentColor
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: tabBarItems[index].image)
                            Text("\(tabBarItems[index].title)")
                                .bold()
                        }
                        .foregroundStyle(index+1 == tabSelection ? Color(UIColor(hex: tabBarItems[index].accentColor)) : Color(.secondaryLabel))
                    }
                    Spacer()
                }
            }
            .frame(height: 80)
            .padding(.horizontal)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(Color(UIColor(hex: currentTabBarStrokeColor)), lineWidth: 2)
            }
        }
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}
