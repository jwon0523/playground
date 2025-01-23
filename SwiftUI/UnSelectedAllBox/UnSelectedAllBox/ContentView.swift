////
////  ContentView.swift
////  UnSelectedAllBox
////
////  Created by jaewon Lee on 3/26/24.
////

import SwiftUI

struct Item {
    let id: String
    let name: String
}

struct ContentView: View {
    @State private var selectedItems: Set<String> = []

    let items: [Item] = [
        Item(id: "1", name: "1"),
        Item(id: "2", name: "2"),
        Item(id: "3", name: "3"),
        Item(id: "4", name: "4"),
        Item(id: "5", name: "5"),
    ]

    var body: some View {
        VStack {
            List(items, id: \.id) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    if selectedItems.contains(item.id) {
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    if selectedItems.contains(item.id) {
                        selectedItems.remove(item.id)
                    } else {
                        selectedItems.insert(item.id)
                    }
                    print(selectedItems)
                }
            }
            Button("취소") {
                selectedItems.removeAll()
            }
        }
    }
}

#Preview {
    ContentView()
}
