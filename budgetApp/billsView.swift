//
//  billsView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/20/23.
//

import SwiftUI

struct billsView: View {
    @Environment(\.dismiss) var dismiss
    @State var billName = ""
    @State var billAmount = 0.0
    @State var billDescr = ""
    @FocusState var focus
    @ObservedObject var userDefaultsManager = UserDefaultsManager()
    
    func checkIfDone(name: String, amount: Double)-> Bool{
        if name == ""{
            return true
        }else{
            if amount == 0.0{
                return true
            }else{
                return false
            }
        }
    }
    
    
    var body: some View {
        VStack{
            Button{ dismiss() }label:{
                Text("dismiss")
            }
            Text("Add a new bill")
            
            HStack{
                Text("Name of Bill: ")
                TextField("Name", text: $billName)
                    .autocorrectionDisabled()
            }
            
            HStack{
                Text("Amount: ")
                TextField("Amount", value: $billAmount, format: .currency(code: "USD"))
                    .focused($focus)
                    .foregroundColor(focus ? Color.gray : Color.green)
            }
            
            HStack{
                Text("Enter Description (Optional): ")
                TextField("Description", text: $billDescr)
            }
            
            Button{
                let submitBill = Bills(name: billName, amount: billAmount, description: billDescr)
                
                userDefaultsManager.bills.append(submitBill)
                //UserDefaults.standard.set(userDefaults().bills, forKey: "bills")
                
                print(submitBill)
                print(userDefaultsManager.bills)
                
                
            }label:{
                Text("submit")
            }.disabled(checkIfDone(name: billName, amount: billAmount))
            
        }.padding([.leading, .trailing], 20)
    }
}

struct billsView_Previews: PreviewProvider {
    static var previews: some View {
        billsView()
    }
}
