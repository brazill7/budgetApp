//
//  UserDefaultsManager.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/25/23.
//

import Foundation

class UserDefaultsManager: ObservableObject {
    @Published var tags: [Tags] {
        didSet {
            if let encodedData = try? JSONEncoder().encode(tags) {
                UserDefaults.standard.set(encodedData, forKey: "tags")
            }
        }
    }
    
    @Published var bills: [Bills] {
        didSet {
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
        
        if let data = UserDefaults.standard.data(forKey: "tags"),
           let decodedTags = try? JSONDecoder().decode([Tags].self, from: data) {
            self.tags = decodedTags
        } else {
            self.tags = []
        }
    }
}


