//
//  billsListView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/27/23.
//

import SwiftUI

struct billsListView: View {
    @ObservedObject var userDefaultsManager: UserTagsWrapper
    @State var removed: Bool
    @State var removeBillAlert = false
    @State var removeBillIndex: Int? = nil
    
    var body: some View {
        VStack {
            Text("Bills paid this month")
            ForEach(Array(userDefaultsManager.bills.enumerated()), id: \.element.id) { index, bill in
                VStack {
                    //trash and alert
                    HStack {
                        Button {
                            //print(billIndex)
                            removeBillAlert = true
                            removeBillIndex = index // Store the index of the bill to be removed
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .symbolRenderingMode(.palette)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding([.leading, .top], 15)
                                .foregroundStyle(.red, .black)
                                .fontWeight(.bold)
                        }
                        //Spacer()
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(Array(userDefaultsManager.tags.enumerated()), id:\.element.id){ tagIndex, tag in
                                    Circle()
                                        .fill(userDefaultsManager.bills[index].addedTags.contains(tag.name) ? tag.color.color : Color.clear)

                                        .padding(.all, 3)
                                        .overlay{
                                            Circle()
                                                .stroke(tag.color.color, lineWidth: 3)
                                                .padding(.all, 3)
                                            Button{
                                                ///
                                                if userDefaultsManager.bills[index].addedTags.contains(tag.name){
                                                    print("remove")
                                                    userDefaultsManager.bills[index].addedTags.removeAll{$0 == tag.name}
                                                    userDefaultsManager.tags[tagIndex].mSpent -= Int(bill.amount)
                                                }else{
                                                    print("add")
                                                    userDefaultsManager.bills[index].addedTags.append(tag.name)
                                                    userDefaultsManager.tags[tagIndex].mSpent += Int(bill.amount)
                                                }
                                            }label:{
                                                Image(systemName: userDefaultsManager.bills[index].addedTags.contains(tag.name) ? "minus" : "plus")
                                                    .foregroundColor(.black)
                                            }
                                        }.alert("Remove this bill?", isPresented: $removeBillAlert) {
                                            Button {
                                                if let index = removeBillIndex {
                                                    userDefaultsManager.bills[index].addedTags.forEach { tagName in
                                                        if let tagIndex = userDefaultsManager.tags.firstIndex(where: { $0.name == tagName }) {
                                                            userDefaultsManager.tags[tagIndex].mSpent -= Int(bill.amount)
                                                        }
                                                    }
                                                    userDefaultsManager.bills.remove(at: index)
                                                    appStorage().mSpent -= bill.amount
                                                }
                                            } label: {
                                                Text("Confirm")
                                            }

                                            Button(role: .cancel) {
                                                removeBillAlert = false
                                            } label: {
                                                Text("Cancel")
                                            }
                                        }
                                }
                            }.padding(.top, 15)
                        }.frame(maxHeight: 50)
                    }
                    //bill information
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
}

struct billsListView_Previews: PreviewProvider {
    static var previews: some View {
        billsListView(userDefaultsManager: UserTagsWrapper(), removed: true)
    }
}
