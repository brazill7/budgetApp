//
//  tagsView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/25/23.
//

import SwiftUI

struct tagsView: View {
    @ObservedObject var userDefaultsManager: UserTagsWrapper
    @Environment(\.dismiss) var dismiss
    @State var tagBudgetAmountTotal = 0
    
    @State var amountOfTags = 1

    @State var tagNamesArr = Array(repeating: "", count: 10)
    @State var tagColorsArr = Array(repeating: Color.white, count: 10)
    @State var tagBudgetArr = Array(repeating: 0, count: 10)
    @State var couldentSubmit = false
    @State var sameName = ""
    
    func checkIfCompleted()-> Bool{
        var j = 0
        
        for i in 0..<amountOfTags{
            if tagNamesArr[i] == ""{
                j += 1
            }
            if tagColorsArr[i] == Color.white{
                j += 1
            }
            if tagBudgetArr[i] == 0{
                j += 1
            }
        }

        if j > 0{
            return false
        }else{
            return true
        }
    }
    
    
    var body: some View {
        ZStack{
            Color.mint.ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Button{ amountOfTags -= 1 }label:{
                        Text("minus")
                    }.disabled(amountOfTags <= 1)
                    Button{ amountOfTags += 1 }label:{
                        Text("plus")
                    }.disabled(amountOfTags >= 10)
                }.padding(.trailing, 20)
                HStack{
                    Form {
                        ForEach(0..<amountOfTags, id: \.self){ i in
                            Section{
                                HStack{
                                    Image(systemName: "\(i + 1).circle.fill")
                                    Text("Enter Tag Name:")
                                    TextField("enter name here", text: $tagNamesArr[i])
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)

                                }
                                ColorPicker("Pick A Color:", selection: $tagColorsArr[i])
                                
                                HStack{
                                    Text("Budget Amount: ").frame(minWidth: 130)
                                    TextField("",
                                              value: $tagBudgetArr[i],
                                              format: .currency(code: "USD"))
                                        .multilineTextAlignment(.trailing)
                                        
                                    Text("/ $\(appStorage().budget.formatted())")
                                }
                                    
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 300)
                }
                Button{
                    var total = 0
                    
                    for i in 0..<amountOfTags {
                        print("\(i): \(tagNamesArr[i])")
                        print("\(i): \(tagColorsArr[i])")
                        print("\(i): \(tagBudgetArr[i])")
                        
                        let newTag = Tags(name: tagNamesArr[i],
                                          color: CodableColor(tagColorsArr[i]),
                                          maxAmount: tagBudgetArr[i],
                                          mSpent: 0)
                        
                        
                        if userDefaultsManager.tags.contains(where: {$0.name.lowercased() == newTag.name.lowercased()}){
                            print("error")
                            sameName = newTag.name
                            couldentSubmit = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                                couldentSubmit = false
                            }
                        }else{
                            userDefaultsManager.tags.append(newTag)
                            total += tagBudgetArr[i]
                        
                            print("total \(total)")
                            appStorage().tagBudgetTotal = total
                        }
                        
                        }
                    
                    if !couldentSubmit{

                        if let encodedTags = try? JSONEncoder().encode(userDefaultsManager.tags) {
                            UserDefaults.standard.set(encodedTags, forKey: "tags")
                        }
                        
                        dismiss()
                    }
 
                }label:{
                    Text("Submit")
                }.buttonStyle(.borderedProminent).disabled(!checkIfCompleted())
                
                Button{
                    dismiss()
                }label:{
                    Text("Dismiss")
                }.buttonStyle(.borderedProminent)

            }.overlay{
                if couldentSubmit{
                    Text("Could not submit, already another tag under the name of \(sameName)")
                        .multilineTextAlignment(.center)
                        .padding(.all, -10)
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.gray)
                                .padding(.all, -15)
                        }
                }
            }
        }
    }
}


