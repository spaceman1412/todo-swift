//
//  AppDelegate.swift
//
//  Created by H470-088 on 14/4/25.
//

import Foundation
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    @Published var todoList = TodoList()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate:  UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler:
                                  @escaping () -> Void) {
        // Get the meeting ID from the original notification.
        let id = response.notification.request.identifier
        
        // Perform the task associated with the action.
        switch response.actionIdentifier {
        case "DISMISS_ACTION":
            print("🔁 Dismiss tapped")
            if let uuid = UUID(uuidString: id) {
                self.todoList.dismissTask(id: uuid)
            }
            break
            
        case "MARK_DONE_ACTION":
            print("🔁 Markdone tapped")
            if let uuid = UUID(uuidString: id) {
                self.todoList.markdoneTask(id: uuid)
            }
            break
            
            // Handle other actions...
        default:
            break
        }
        
        // Always call the completion handler when done.
        completionHandler()
    }
}

