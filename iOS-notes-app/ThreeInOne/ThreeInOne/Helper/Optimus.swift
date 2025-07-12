//
//  Optimus.swift
//  Smplfy
//
//  Created by Vedant Mistry on 12/07/25.
//

import SwiftUI

public struct Optimus<Data, ID, Content>: View where Data: RandomAccessCollection, ID: Hashable, Content: View {
    private let data: Data
    private let backgroundColor: Color
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        backgroundColor: Color = Color.clear,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.backgroundColor = backgroundColor
        self.id = id
        self.content = content
    }
    
    public var body: some View {
        List {
            ForEach(data, id: id) { item in
                content(item)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(.zero))
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, 12)
            }
        }
        .listStyle(.plain)
        .background(backgroundColor)
        .environment(\.defaultMinListRowHeight, 0)
    }
}

// MARK: - Convenience Initializers
public extension Optimus where ID == Data.Element, Data.Element: Hashable {
    init(
        _ data: Data,
        backgroundColor: Color = Color.clear,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.backgroundColor = backgroundColor
        self.id = \.self
        self.content = content
    }
}


