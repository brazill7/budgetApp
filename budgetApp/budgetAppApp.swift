//
//  budgetAppApp.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/18/23.
//

import SwiftUI
import Foundation
import BackgroundTasks
import UserNotifications

@main
struct budgetAppApp: App {
    
   /*)/ func scheduleAppRefresh(){
        print("this func ran")
        let today = Calendar.current.startOfDay(for: .now)
        //let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
       // let noonComponent = DateComponents(hour: 12)
        //let noon = Calendar.current.date(byAdding: noonComponent, to: tomorrow)
        let oneMinute = Calendar.current.date(byAdding: .second, value: 10, to: today)
        
        
        
        let request = BGAppRefreshTaskRequest(identifier: "month")
        request.earliestBeginDate = oneMinute
        //request.earliestBeginDate = noon
        try? BGTaskScheduler.shared.submit(request)
        
    }*/


    
    
    var body: some Scene {
        WindowGroup {
            if appStorage().budget == 0.0{
                onboardingView()
            }else{
                ContentView(doesntNeedUpdate: true)
                    .onAppear{
                        print("contentview")
                        //notificationTest()
                    }
            }
        }/*.backgroundTask(.appRefresh("month")){
            print("got it")
            scheduleAppRefresh()
            notificationTest()
            //await notif()
        }*/
    }
}
