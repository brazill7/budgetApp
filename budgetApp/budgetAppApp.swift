//
//  budgetAppApp.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/18/23.
//

import SwiftUI
import Foundation

@main
struct budgetAppApp: App {
    
    func resetDay()-> Bool{
        let todaysDate = Date.now
            
            //let testDay = Calendar.current.date(byAdding: .day, value: 1097, to: todaysDate)
            //let testDayComps = DateComponents(year: 2023, month: 7, day: 24, hour: 14, minute: 43)
            //let testDay = Calendar.current.dateComponents([.hour,.year,.month,.day], from: testDayComps!)
        let resetDate = UserDefaults.standard.object(forKey: "day") as! Date
            
        if (todaysDate >= resetDate){
            /// Todays date is or is after reset day
            print("today is after reset day")
            return true
            
        }else{
            /// Todays date is before reset day
            print("today is before reset day")
            return false
        }
    }


    
    
    var body: some Scene {
        WindowGroup {
            if appStorage().budget == 0.0{
                onboardingView()
            }else{
                if resetDay(){
                    monthResetView()
                }else{
                    ContentView()
                }
            }
        }
    }
}
