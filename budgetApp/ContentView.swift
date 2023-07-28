//
//  ContentView.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/18/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var removed = false
    @State private var sheet = false
    @State private var spent = false
    @State private var newBill = false
    @State private var updateFromSheet = false
    @State private var newTag = false
    @State private var update = false
    @State private var doesntNeedUpdate: Bool = false
    @State private var alert = false
    @State private var monthResetSheet = false

    @StateObject private var userTagsWrapper = UserTagsWrapper()

    var monthFromNow = false
    var notYet = false

    func budgetColor(mLeft: Double) -> Color {
        let phaseThree = (appStorage().budget / 2)
        let phaseTwo = (appStorage().budget / 5)
        let phaseOne = (appStorage().budget / 10)

        switch mLeft {
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
    
    func daysLeftColor(num: Int)-> Color{
        switch num{
        case 0...5:
            return Color.green
        case 6...12:
            return Color.blue
        case 13...20:
            return Color.orange
        default:
            return Color.red
        }
    }
    
    func checkIfMore(input: Int, max: Int)-> Int{
        if input < max{
            return input
        }else{
            return max
        }
    }

    var body: some View {
        let day = UserDefaults.standard.object(forKey: "day")
        NavigationView {
            VStack {
                // Tags stuff
                VStack {
                    ForEach(userTagsWrapper.tags, id: \.self) { tag in
                        HStack {
                            ProgressView(value: Float(checkIfMore(input: tag.mSpent, max: tag.maxAmount)), total: Float(tag.maxAmount)) {
                                Text("\(tag.name) - ")
                                } currentValueLabel: {
                                    Text("Amount Remaining - $\(tag.mSpent) / $\(tag.maxAmount)")
                                }.frame(maxWidth: 300)
                                .tint(tag.color.color)
                            }
                    }
                }.padding(.bottom, 20)
                // Month Reset
                Group {
                    if let data = day {
                        let monthreset = (data as! Date)
                        let daysLeft = Calendar.current.dateComponents([.day], from: Date.now, to: monthreset)
                        
                        HStack {
                            Text("\(daysLeft.day!)")
                                .foregroundColor(daysLeftColor(num: daysLeft.day!))
                                .fontWeight(.bold)
                            Text("Days Left until reset")
                        }
                    } else {
                        ProgressView()
                    }
                }.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        doesntNeedUpdate = true
                    }
                }
                // ScrollView of Bills
                ScrollView {
                    if UserDefaultsManager().bills.isEmpty {
                        Text("Hit the plus button to add bills")
                            .fontWeight(.bold)
                    } else {
                        billsListView(userDefaultsManager: userTagsWrapper, removed: true)
                    }
                }.scrollIndicators(.hidden)
            }.overlay {
                if sheet {
                    Text("")
                }
                if updateFromSheet {
                    Text("")
                }
                if removed {
                    Text("")
                }
                if doesntNeedUpdate {
                    Text("")
                }
            }.sheet(isPresented: $sheet) {
                HStack {
                    Text("New Budget ($/month):")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 200)
                    TextField("Budget", value: appStorage().$budget, format: .number)
                        .onSubmit {
                            sheet = false
                        }
                }.padding([.leading, .trailing], 20)
            }.fullScreenCover(isPresented: $newBill) {
                billsView(userDefaultsManager: userTagsWrapper)
                    .onDisappear {
                        update = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            update = false
                        }
                    }
            }.fullScreenCover(isPresented: $newTag) {
                tagsView(userDefaultsManager: userTagsWrapper)
                    .onDisappear {
                        update = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            update = false
                        }
                    }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button { sheet = true } label: {
                            Text("Edit Budget")
                        }
                        Button { newBill = true } label: {
                            Text("Add a new Bill")
                        }
                        Button { newTag = true } label: {
                            Text("Add a new Tag")
                        }
                        /*Button {
                            update = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                update = false
                            }
                            UserDefaultsManager().tags.removeAll()
                            UserDefaults.standard.removeObject(forKey: "tags")
                        } label: {
                            Text("Reset tags")
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
            }.onChange(of: update) { _ in
                print("updated")
                print(userTagsWrapper.tags)
                updateFromSheet = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    updateFromSheet = false
                }
            }
        }
    }
}

class UserTagsWrapper: ObservableObject {
    @Published var tags: [Tags] {
        didSet {
            UserDefaultsManager().tags = tags
        }
    }
    @Published var bills: [Bills]{
        didSet{
            UserDefaultsManager().bills = bills
        }
    }

    init() {
        tags = UserDefaultsManager().tags
        bills = UserDefaultsManager().bills
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

