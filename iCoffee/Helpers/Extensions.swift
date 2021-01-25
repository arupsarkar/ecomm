//
//  Extensions.swift
//  iCoffee
//
//  Created by Arup Sarkar on 1/19/21.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
