//
//  onboardingView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/21/23.
//

import SwiftUI

struct onboardingView: View {
    @State var mBudget = 0.0
    @State var selectedDate = Date.now
    @State var bSubmit = false
    
    func oneMonthFromSelected()-> Date{
        return Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
    }
    func oneMinuteFromNow() -> Date{
        return Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
    }
    
    func monthNotification(){
        let dateSet = Calendar.current.startOfDay(for: selectedDate)
        let content = UNMutableNotificationContent()
        content.title = "Budget App"
        content.subtitle = "Your monthly budget has been reset!"
        content.sound = UNNotificationSound.default
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        let nooncomp = DateComponents(hour: 12)
        let noonNotif = Calendar.current.date(byAdding: nooncomp, to: dateSet)
        
        
        let comp = Calendar.current.dateComponents([ .day, .month, .hour], from: noonNotif!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        print("Req: \(request.debugDescription)")
        UNUserNotificationCenter.current().add(request)
        print("Scheduled notif")
    
    }
    
 
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Text("Enter your monthly budget: ")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 230)
                    TextField("click/tap here", value: $mBudget, format: .currency(code: "USD"))
                        .onSubmit {
                            bSubmit = true
                        }
                    
                }.padding([.trailing, .leading], 20).padding(.top, 30)
                Spacer()
                Text("When do you want your month to reset?")
                    .fontWeight(.bold)
                Text("(It will automatically clear every month past this date, ex) if you pick the 15th it will automatically reset every month on the 15th)")
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 20)
                    .font(.footnote)
                DatePicker("", selection: $selectedDate, in: Date.now...oneMinuteFromNow(), displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding([.leading, .trailing], 20)
                HStack{
                    Text("Next Reset: ")
                    if selectedDate > Date.now{
                        Text("\(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                    }else{
                        Text("\(oneMonthFromSelected().formatted(date: .abbreviated, time: .omitted))")
                    }
                }
                Spacer()
                NavigationLink{
                    ContentView(doesntNeedUpdate: false).navigationBarBackButtonHidden()
                        .onAppear{
                            appStorage().budget = mBudget
                            UserDefaults.standard.set(selectedDate, forKey: "day")
                            UserDefaults.standard.set(oneMonthFromSelected(), forKey: "oneMonthFromNow")
                            UserDefaults.standard.set(oneMinuteFromNow(), forKey: "oneMin")
                            
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
                                if success{
                                    print("notifications enabled")
                                }else if let error = error{
                                    print(error.localizedDescription)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                print("BAM")
                                monthNotification()
                            }
                        }
                }label:{
                    Text("Submit")
                }.buttonStyle(.borderedProminent)
                    .disabled(!bSubmit)
            }
        }
    }
}

struct onboardingView_Previews: PreviewProvider {
    static var previews: some View {
        onboardingView()
    }
}
