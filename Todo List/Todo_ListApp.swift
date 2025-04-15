//
//  Todo_ListApp.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import SwiftUI

@main
struct Todo_ListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    func notificationSetup() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted ✅")
                setupCustomNotification()
            } else {
                print("Permission denied ❌")
            }
        }
    }

    func setupCustomNotification() {
        let dissmissAction = UNNotificationAction(identifier: "DISMISS_ACTION",
              title: "Dismiss",
              options: [])
        let markdoneAction = UNNotificationAction(identifier: "MARK_DONE_ACTION",
              title: "Markdone",
              options: [])
        // Define the notification type
        let reminderCategory =
              UNNotificationCategory(identifier: "REMINDER_CATEGORY",
              actions: [dissmissAction, markdoneAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([reminderCategory])
        print("setup notification custom")
    }

    
    var body: some Scene {
        main
    }
    
    var test: some Scene {
        WindowGroup {
            TestView()
        }
    }
    
    var main: some Scene {
        WindowGroup {
            TodoListView()
                .onAppear {
                    notificationSetup()
                }
        }
        .environmentObject(appDelegate.todoList)
    }
}
