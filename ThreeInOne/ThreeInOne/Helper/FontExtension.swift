//
//  FontExtension.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

extension Font {
    static func customFont(_ name: String, size: CGFloat) -> Font {
        // Debug: Print available font names
        if let fontNames = UIFont.familyNames as? [String] {
            print("Available font families: \(fontNames)")
            
            for familyName in fontNames {
                if let fontNamesForFamily = UIFont.fontNames(forFamilyName: familyName) as? [String] {
                    print("Fonts in family '\(familyName)': \(fontNamesForFamily)")
                }
            }
        }
        
        return .custom(name, size: size)
    }
    
    // Convenience methods for your custom fonts
    static func luckiestGuy(size: CGFloat) -> Font {
        // Try different possible font names
        let possibleNames = [
            "LuckiestGuy-Regular",
            "LuckiestGuy",
            "Luckiest Guy",
            "LuckiestGuy-Regular.ttf"
        ]
        
        for name in possibleNames {
            if UIFont.fontNames(forFamilyName: name).count > 0 || UIFont(name: name, size: size) != nil {
                print("Found LuckiestGuy font with name: \(name)")
                return .custom(name, size: size)
            }
        }
        
        print("Warning: LuckiestGuy font not found, falling back to system font")
        return .system(size: size, weight: .bold)
    }
    
    static func funnelDisplay(size: CGFloat) -> Font {
        // Try different possible font names
        let possibleNames = [
            "FunnelDisplay-VariableFont_wght",
            "FunnelDisplay",
            "Funnel Display",
            "FunnelDisplay-VariableFont_wght.ttf"
        ]
        
        for name in possibleNames {
            if UIFont.fontNames(forFamilyName: name).count > 0 || UIFont(name: name, size: size) != nil {
                print("Found FunnelDisplay font with name: \(name)")
                return .custom(name, size: size)
            }
        }
        
        print("Warning: FunnelDisplay font not found, falling back to system font")
        return .system(size: size, weight: .medium)
    }
    
    static func boldonse(size: CGFloat) -> Font {
        // Try different possible font names
        let possibleNames = [
            "Boldonse-Regular",
            "Boldonse",
            "Boldonse Regular",
            "Boldonse-Regular.ttf"
        ]
        
        for name in possibleNames {
            if UIFont.fontNames(forFamilyName: name).count > 0 || UIFont(name: name, size: size) != nil {
                print("Found Boldonse font with name: \(name)")
                return .custom(name, size: size)
            }
        }
        
        print("Warning: Boldonse font not found, falling back to system font")
        return .system(size: size, weight: .bold)
    }
}

// Extension to help debug font loading
extension UIFont {
    static func printAvailableFonts() {
        print("=== Available Font Families ===")
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            let names = UIFont.fontNames(forFamilyName: family)
            for name in names {
                print("  Font: \(name)")
            }
        }
        print("===============================")
    }
}
