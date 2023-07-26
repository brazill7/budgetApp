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

    var body: some View {
        let day = UserDefaults.standard.object(forKey: "day")
        NavigationView {
            VStack {
                // Tags stuff
                VStack {
                    ForEach(userTagsWrapper.tags, id: \.self) { tag in
                        HStack {
                            ProgressView(value: Float(tag.mSpent), total: Float(tag.maxAmount)) {
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
                        HStack {
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
                // ScrollView of Bills
                ScrollView {
                    if UserDefaultsManager().bills.isEmpty {
                        Text("Hit the plus button to add bills")
                            .fontWeight(.bold)
                    } else {
                        VStack {
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
                                        .alert("Remove this bill?", isPresented: $alert) {
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

                                            Button(role: .destructive) {
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
                billsView()
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
                        Button {
                            update = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                update = false
                            }
                            UserDefaultsManager().tags.removeAll()
                            UserDefaults.standard.removeObject(forKey: "tags")
                        } label: {
                            Text("Reset tags")
                        }
                        /*
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
            UserDefaultsManager().tags = tags // Save changes to UserDefaults
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

