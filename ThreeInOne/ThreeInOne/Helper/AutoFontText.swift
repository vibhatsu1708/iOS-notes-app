//
//  AutoFontText.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

// MARK: - SText: Drop-in replacement for Text that automatically uses FunnelDisplay
struct SText: View {
    let content: String
    let size: CGFloat
    let weight: Font.Weight?
    let color: Color?
    let alignment: TextAlignment?
    
    init(_ content: String, size: CGFloat = 16, weight: Font.Weight? = nil, color: Color? = nil, alignment: TextAlignment? = nil) {
        self.content = content
        self.size = size
        self.weight = weight
        self.color = color
        self.alignment = alignment
    }
    
    var body: some View {
        Text(content)
            .font(.funnelDisplay(size: size))
            .fontWeight(weight)
            .foregroundColor(color)
            .multilineTextAlignment(alignment ?? .leading)
    }
}

// MARK: - SText Modifiers
extension SText {
    func foregroundColor(_ color: Color) -> SText {
        SText(content, size: size, weight: weight, color: color, alignment: alignment)
    }
    
    func fontWeight(_ weight: Font.Weight) -> SText {
        SText(content, size: size, weight: weight, color: color, alignment: alignment)
    }
    
    func font(_ font: Font) -> SText {
        // For now, just return the SText with current size
        // The font parameter is ignored since SText always uses FunnelDisplay
        return SText(content, size: size, weight: weight, color: color, alignment: alignment)
    }
    
    func multilineTextAlignment(_ alignment: TextAlignment) -> SText {
        SText(content, size: size, weight: weight, color: color, alignment: alignment)
    }
    
    func lineLimit(_ limit: Int?) -> some View {
        Text(content)
            .font(.funnelDisplay(size: size))
            .fontWeight(weight)
            .foregroundColor(color)
            .multilineTextAlignment(alignment ?? .leading)
            .lineLimit(limit)
    }
    
    func truncationMode(_ mode: Text.TruncationMode) -> some View {
        Text(content)
            .font(.funnelDisplay(size: size))
            .fontWeight(weight)
            .foregroundColor(color)
            .multilineTextAlignment(alignment ?? .leading)
            .truncationMode(mode)
    }
}

// MARK: - Global Environment for Default Font
struct DefaultFontKey: EnvironmentKey {
    static let defaultValue: Font = .funnelDisplay(size: 16)
}

extension EnvironmentValues {
    var defaultFont: Font {
        get { self[DefaultFontKey.self] }
        set { self[DefaultFontKey.self] = newValue }
    }
}

// MARK: - View Extensions
extension View {
    func withDefaultFont(_ font: Font = .funnelDisplay(size: 16)) -> some View {
        self.environment(\.defaultFont, font)
    }
}

// MARK: - Text Extensions for Easy FunnelDisplay Application
extension Text {
    func funnelDisplay(size: CGFloat = 16, weight: Font.Weight? = nil) -> some View {
        self
            .font(.funnelDisplay(size: size))
            .fontWeight(weight)
    }
    
    // Auto-apply FunnelDisplay if no font is set
    func autoFunnelDisplay(size: CGFloat = 16) -> some View {
        // This is a workaround since we can't detect if font is already set
        self.font(.funnelDisplay(size: size))
    }
}

// MARK: - Convenience Functions
func FunnelText(_ content: String, size: CGFloat = 16, weight: Font.Weight? = nil) -> some View {
    Text(content)
        .font(.funnelDisplay(size: size))
        .fontWeight(weight)
}

// MARK: - Usage Examples
/*
 
 // Instead of:
 Text("Hello World")
 
 // Use:
 SText("Hello World")
 
 // Or:
 FunnelText("Hello World")
 
 // Or for existing Text views:
 Text("Hello World").funnelDisplay()
 
 // For different sizes:
 SText("Large Text", size: 24)
 
 // With weight:
 SText("Bold Text", size: 18, weight: .bold)
 
 // With color:
 SText("Colored Text", color: .red)
 
 */
