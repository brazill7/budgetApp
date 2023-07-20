//
//  billsVM.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/20/23.
//

import Foundation

struct Bills: Identifiable, Codable{
    var id = UUID()
    var name: String
    var amount: Double
    var description: String?
}

class UserDefaultsManager: ObservableObject {
    @Published var bills: [Bills] {
        didSet {
            // Convert the array of Bills to Data before saving to UserDefaults
            if let encodedData = try? JSONEncoder().encode(bills) {
                UserDefaults.standard.set(encodedData, forKey: "bills")
            }
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "bills"),
           let decodedBills = try? JSONDecoder().decode([Bills].self, from: data) {
            self.bills = decodedBills
        } else {
            self.bills = []
        }
    }
}



