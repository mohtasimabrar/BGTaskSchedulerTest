//
//  AppDelegate.swift
//  BGTaskSchedulerTest
//
//  Created by Mohtasim Abrar Samin on 11/7/23.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let bgTaskIdentifier = {
        return "com.example.test"
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //        BGTaskScheduler.shared.register(
        //            forTaskWithIdentifier: bgTaskIdentifier(),
        //            using: DispatchQueue.global()
        //        ) { task in
        //            print("########## inside register func ###########")
        //        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: bgTaskIdentifier(), using: DispatchQueue.global()) { task in
            self.handleAppRefresh(task: task)
        }
        
        
        scheduleAppRefresh()
        
        return true
    }
    
    private func scheduleAppRefresh() {
        print("########## inside scheduleAppRefresh func ###########")
        //        let request = BGAppRefreshTaskRequest(identifier: bgTaskIdentifier())
        //        // Fetch no earlier than 60 minutes from now.
        //        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        //
        //        do {
        //            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: bgTaskIdentifier())
        //            try BGTaskScheduler.shared.submit(request)
        //        } catch {
        //            print("############### Could not schedule app refresh: \(error) ###############")
        //        }
        do {
            let processingTaskRequest = BGProcessingTaskRequest(identifier: bgTaskIdentifier())
            processingTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            //            processingTaskRequest.requiresExternalPower = true
            processingTaskRequest.requiresNetworkConnectivity = true
            try BGTaskScheduler.shared.submit(processingTaskRequest)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleAppRefresh(task: BGTask) {
        
        print("########## inside handleAppRefresh func ###########")
        // Schedule a new refresh task.
        //        scheduleAppRefresh()
        
        // Start refresh of the app data
        self.fetchOfflineData(){ [weak self] in
            guard let self else {
                task.setTaskCompleted(success: false)
                return
            }
            task.setTaskCompleted(success: true)
            self.scheduleAppRefresh()
        }
        
        // Provide the background task with an expiration handler that cancels the operation.
        //        task.expirationHandler = {
        //            updateTask.cancel()
        //        }
    }
    
    func fetchOfflineData(completion: @escaping (()-> Void)) {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("########## inside fetch func ###########")
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

