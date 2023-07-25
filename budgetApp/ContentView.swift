//
//  ContentView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/18/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var removed = false
    @State var sheet = false
    @State var spent = false
    @State var newBill = false
    @State var newBillSubmitted = false
    @State var doesntNeedUpdate: Bool
    @State var alert = false
    @State var monthResetSheet = false
    
    var monthFromNow = false
    var notYet = false
    
    func budgetColor(mLeft: Double) -> Color {
        let phaseThree = (appStorage().budget / 2)
        let phaseTwo = (appStorage().budget / 5)
        let phaseOne = (appStorage().budget / 10)
        
        switch mLeft{
            
        case let x where x < 1:
            return Color.red
        case 1...phaseOne:
            return Color.orange
        case phaseOne...phaseTwo:
            return Color.yellow
        case phaseTwo...phaseThree:
            return Color.yellow
        default:
            return Color.green
        }
    }
    
    var body: some View {
        let day = UserDefaults.standard.object(forKey: "day")
        NavigationView {
            VStack {
                Group{
                    if let data = day {
                        HStack{
                            Text("Month Reset: \((data as! Date).formatted(date: .complete, time: .omitted)) at 12PM")
                        }
                    } else {
                        ProgressView()
                            
                    }
                }.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        doesntNeedUpdate = true
                    }
                }

                ScrollView {
                    if UserDefaultsManager().bills.isEmpty {
                        Text("Hit the plus button to add bills")
                            .fontWeight(.bold)
                    } else {
                        VStack{
                            Text("Bills paid this month")
                            ForEach(Array(UserDefaultsManager().bills.enumerated()), id: \.element.id) { index, bill in
                                VStack {
                                    HStack {
                                        Button {
                                            alert = true
                                        } label: {
                                            Image(systemName: "trash.circle.fill")
                                                .symbolRenderingMode(.palette)
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .padding([.leading, .top], 15)
                                                .foregroundStyle(.red, .black)
                                                .fontWeight(.bold)
                                        }
                                        .alert("Alert", isPresented: $alert) {
                                            Button {
                                                UserDefaultsManager().bills.remove(at: index)
                                                removed = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    removed = false
                                                }
                                                appStorage().mSpent -= bill.amount
                                                alert = false
                                            } label: {
                                                Text("Confirm")
                                            }

                                            Button(role: .cancel) {
                                                alert = false
                                            } label: {
                                                Text("Cancel")
                                            }
                                        }
                                        Spacer()
                                    }

                                    HStack {
                                        Text(bill.name)
                                            .font(.title)
                                            .fontWeight(.black)
                                        Text("- $\(bill.amount.formatted(.number))")
                                            .font(.title3)

                                    }
                                    .padding(.bottom, 10)

                                    if bill.description != "" {
                                        Text(bill.description!)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 20)
                                    }

                                    Text("\(bill.time.formatted(date: .complete, time: .shortened))")
                                        .font(.footnote)
                                        .foregroundColor(.black)


                                }
                                .frame(width: 300)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .padding(.bottom, -20)
                                        .foregroundColor(Color.gray)

                                }
                                .padding(.bottom, 50)

                            }
                        }
                    }
                }.scrollIndicators(.hidden)
            }.sheet(isPresented: $sheet){
                HStack{
                    Text("New Budget ($/month):")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 200)
                    TextField("Budget", value: appStorage().$budget, format: .number)
                        .onSubmit {
                            sheet = false
                        }
                }.padding([.leading, .trailing], 20)
            }.overlay{
                if sheet{
                    Text("")
                }
                if newBillSubmitted{
                    Text("")
                }
                if removed{
                    Text("")
                }
                if doesntNeedUpdate{
                    Text("")
                }
                
            }.fullScreenCover(isPresented: $newBill){
                billsView()
                    .onDisappear{
                        print("Dis")
                        newBillSubmitted = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            newBillSubmitted = false
                        }
                    }
            }.toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button { sheet = true } label: {
                            Text("Edit Budget")
                        }
                                       
                        Button { newBill = true } label: {
                            Text("Add a new Bill")
                        }
                        /*Button {
                            newBillSubmitted = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                newBillSubmitted = false
                            }
                            UserDefaultsManager().bills.removeAll()
                            UserDefaults.standard.removeObject(forKey: "bills")
                        } label: {
                            Text("Reset Bills")
                        }
                        
                        Button {
                            newBillSubmitted = true
                            appStorage().mSpent = 0.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                newBillSubmitted = false
                            }
                        } label: {
                            Text("Reset Remaining")
                        }*/
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack {
                        Text("Budget")
                        Text("$\(appStorage().budget.formatted(.number))/m")
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Remaining")
                        Text("$\((appStorage().budget - appStorage().mSpent).formatted(.number))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(spent ? budgetColor(mLeft: (appStorage().budget - appStorage().mSpent)) : budgetColor(mLeft: (appStorage().budget - appStorage().mSpent)))
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(doesntNeedUpdate: true)
    }
}

