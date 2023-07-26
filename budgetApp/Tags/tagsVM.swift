//
//  tagsVM.swift
//  budgetApp
//
//  Created by Maverick Brazill on 7/25/23.
//

import SwiftUI
import Foundation
import UIKit

struct Tags: Identifiable, Codable, Hashable{
    var id = UUID()
    var name: String
    var color: CodableColor
    var maxAmount: Int
    var mSpent: Int
    
    func totalAmount()-> Int{
        let i = maxAmount
        let j = mSpent
        
        return (i-j)
    }
}

struct CodableColor: Codable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double

    init(_ color: Color) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &opacity)

        self.red = Double(red)
        self.green = Double(green)
        self.blue = Double(blue)
        self.opacity = Double(opacity)
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

