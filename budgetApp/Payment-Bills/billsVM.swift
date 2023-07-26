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
    var time: Date
}



