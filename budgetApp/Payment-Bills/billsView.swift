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
    @State var date = Date.now
    @FocusState var focus
    @ObservedObject var userDefaultsManager: UserTagsWrapper
    
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
                let submitBill = Bills(name: billName, amount: billAmount, description: billDescr, time: date)
                userDefaultsManager.bills.append(submitBill)

                appStorage().mSpent += billAmount
                
                dismiss()
                
            }label:{
                Text("Submit")
            }.buttonStyle(.borderedProminent)
            .disabled(checkIfDone(name: billName, amount: billAmount))
            
            Button{ dismiss() }label:{
                Text("Dismiss")
                    
            }.buttonStyle(.borderedProminent)
            .tint(Color.red)
            
        }.padding([.leading, .trailing], 20)
    }
}

struct billsView_Previews: PreviewProvider {
    static var previews: some View {
        billsView(userDefaultsManager: UserTagsWrapper())
    }
}
