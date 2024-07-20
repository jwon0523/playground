//
//  ContentView.swift
//  PushNotification
//
//  Created by jaewon Lee on 5/11/24.
//

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager: ObservableObject {
    static let instance = NotificationManager()
    
    @Published var authorizationStatus: UNAuthorizationStatus?
    
    init() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("ERROR: \(error)")
                } else {
                    print("Permission granted: \(granted)")
                    self.authorizationStatus = granted ? .authorized : .denied
                }
            }
        }
    }
    
    func scheduleNotification(date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Scheduled Alert"
        content.subtitle = "This is your custom notification!"
        content.sound = .default
        content.badge = 1
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(date)!")
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

struct ContentView: View {
    @ObservedObject private var notificationManager = NotificationManager.instance
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            if notificationManager.authorizationStatus == .notDetermined {
                Button("Request permissions") {
                    notificationManager.requestAuthorization()
                }
                .buttonStyle(.borderedProminent)
            } else if notificationManager.authorizationStatus == .denied {
                Text("Notification permission denied. Please enable it in settings.")
                    .foregroundColor(.red)
            } else {
                DatePicker("Select Date and Time:", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .padding()
                
                Button("Schedule notification") {
                    notificationManager.scheduleNotification(date: selectedDate)
                }
                .buttonStyle(.bordered)
                
                Button("Cancel notification") {
                    notificationManager.cancelNotification()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0) { error in
                if let error = error {
                    print("Failed to reset badge count: \(error)")
                } else {
                    print("Badge count reset successfully")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
