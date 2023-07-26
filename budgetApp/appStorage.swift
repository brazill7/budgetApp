//
//  appStorage.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/20/23.
//

import Foundation
import SwiftUI

class appStorage: ObservableObject{
    @AppStorage("budget") var budget = 0.0
    @AppStorage("tagBudget") var tagBudgetTotal = UserDefaultsManager().tags.count
    @AppStorage("moneySpent") var mSpent = 0.0

}
