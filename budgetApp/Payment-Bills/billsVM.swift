//
//  billsVM.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/20/23.
//

import Foundation

struct Bills: Identifiable, Codable, Equatable{
    var id = UUID()
    var name: String
    var amount: Double
    var description: String?
    var time: Date
    var addedTags: [String] = []
    
    
    /*func hasTags()-> Bool{
        if ((addedTags?.isEmpty) != nil){
            if addedTags!.count > 0{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }*/
}



