//
//  ItemListView.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    /// View Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var dateAdded: Date = Date.now
    @State private var startDate: Date = Date.distantPast
    @State private var endDate: Date =  Date.distantPast
    @State private var addNewItem: Bool = false
    /// For Animation
    @Namespace private var animation
    let item: Item
    @State private var createNewItem: Bool = false
    @State private var selectedItem: Item?
    var isEditing: Bool {
        selectedItem != nil
    }
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack {
                NavigationSplitView {
                    LogoView()
                    ScrollView(.vertical) {
                        VStack(spacing: 10) {
                            ForEach(items) { item in
                                
                            }
                        }
                    }
                }detail: {
                    Text("Select an item")
                }
            }
        }
    }
}
#Preview {
    ItemListView(item: Item( ))
        .modelContainer(for: Item.self, inMemory: true)
}
