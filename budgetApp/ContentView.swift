//
//  ContentView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/18/23.
//

import SwiftUI

struct ContentView: View {
    @State var sheet = false
    @State var spent = false
    @State var newBill = false
    @State var newBillSubmitted = false
    
    func budgetColor(mLeft: Double)-> Color{
        let phaseThree = (appStorage().budget / 2)
        let phaseTwo = (appStorage().budget / 5)
        let phaseOne = (appStorage().budget / 10)
        
        switch mLeft{
        case 0...phaseOne:
            return Color.red
        case phaseOne...phaseTwo:
            return Color.orange
        case phaseTwo...phaseThree:
            return Color.yellow
        default:
            return Color.green
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Text("My Bills")
                ScrollView{
                    
                    ForEach(UserDefaultsManager().bills){ bill in
                        if UserDefaultsManager().bills.isEmpty{
                            Text("Hit the plus to add bills")
                                .foregroundColor(.green)
                        }else{
                            Text("\(bill.name)")
                                .foregroundColor(.green)
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
                
                if sheet{
                    Text("")
                }
            }
            
            
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        ///
                        Button{ sheet = true }label:{
                            Text("Edit Budget")
                        }
                        ///
                        Button{ newBill = true }label:{
                            Text("Add a new Bill")
                        }
                        
                    }label:{
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    VStack{
                        Text("Budget")
                        Text("$\(appStorage().budget.formatted(.number))/m")
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .principal){
                    VStack{
                        Text("Remaining")
                        Text("$\((appStorage().budget - appStorage().mSpent).formatted(.number))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(spent ?
                                             budgetColor(mLeft: (appStorage().budget - appStorage().mSpent))
                                             : budgetColor(mLeft: (appStorage().budget - appStorage().mSpent)))
                    }
                }
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
        }.overlay{
            if newBillSubmitted{
                Text("")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
