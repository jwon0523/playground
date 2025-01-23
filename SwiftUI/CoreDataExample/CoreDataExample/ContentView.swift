//
//  ContentView.swift
//  CoreDataExample
//
//  Created by jaewon Lee on 5/13/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: FoodEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FoodEntity.name, ascending: true)
        ]
    ) var Food: FetchedResults<FoodEntity>
    
    @State private var textFieldTitle: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 10) {
                TextField("", text: $textFieldTitle)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground).cornerRadius(10))
                    .padding(.horizontal, 10)
                
                Button(action: {addItem()}, label: {
                    Text("저장")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .foregroundColor(.white)
                        .background(Color.accentColor.cornerRadius(10))
                        .padding(.horizontal, 10)
                    
                })
                
                List {
                    ForEach(Food) { foods in
                        //과일에 이름이 없으면 빈문자열을 생성
                        Text(foods.name ?? "아이템 없음")
                    }
                    .onDelete(perform: deleteItems)
                }
                
                .listStyle(PlainListStyle())
                .navigationBarTitle("음식")
            }
            
        }
    }
    
    private func addItem() {
        withAnimation {
            let newFood = FoodEntity(context: viewContext)
            newFood.name = textFieldTitle
            textFieldTitle = ""
            
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            //                offsets.map { items[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else { return }
            let FoodEentity = Food[index]
            viewContext.delete(FoodEentity)
            
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
