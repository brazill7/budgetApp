//
//  monthResetView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/25/23.
//

import SwiftUI

struct monthResetView: View {
    @State var proceed = false
    
    var body: some View {
        NavigationView{
            VStack{
                Text("PayDay!")
                Text("Your Monthly Budget has been reset")

                HStack{
                    Button{ }label:{
                        Text("View Stats")
                    }.disabled(true)
                    
                    Spacer()
                    NavigationLink{
                        ContentView()
                            .navigationBarBackButtonHidden()
                            .onAppear{
                                proceed = true
                                appStorage().mSpent = 0
                                let oneMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date.now)
                                
                                UserDefaults.standard.set(oneMonth, forKey: "day")

                            }
                    }label:{
                        Text("Continue")
                    }.buttonStyle(.borderedProminent)
                }.padding([.top,.leading,.trailing], 20)
            }.frame(maxWidth: 300)
        }
    }
}

struct monthResetView_Previews: PreviewProvider {
    static var previews: some View {
        monthResetView()
    }
}
