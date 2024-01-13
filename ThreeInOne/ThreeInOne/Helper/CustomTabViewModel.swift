//
//  CustomTabBarModel.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 10/01/24.
//

import Foundation

class CustomTabViewModel: ObservableObject {
    @Published var tabBarItems: [(image: String, title: String, accentColor: String)] = [
        ("creditcard.fill", "Budget Tracker", "6AB547"),
        ("text.badge.checkmark", "Todos", "F64740"),
        ("note.text", "Notes", "8A4FFF")
    ]
}
