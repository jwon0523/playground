//
//  ContentView.swift
//  CustomModalPopUp
//
//  Created by jaewon Lee on 4/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingPopup = false
    
    var body: some View {
        VStack {
            Button("Show Popup") {
                showingPopup = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.headline)
            .sheet(isPresented: $showingPopup) {
                PopupView(showingPopup: $showingPopup)
            }
        }
    }
}

struct PopupView: View {
    @Binding var showingPopup: Bool
    
    var body: some View {
        VStack {
            Text("Custom Popup")
                .font(.title)
                .padding()
            
            Text("This is a custom popup in SwiftUI.")
                .font(.body)
                .padding()
            
            Button("Close") {
                // Dismiss the popup
                showingPopup = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    ContentView()
}
