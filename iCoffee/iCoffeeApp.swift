//
//  iCoffeeApp.swift
//  iCoffee
//
//  Created by Arup Sarkar on 12/24/20.
//

import SwiftUI
import Firebase

@main
struct iCoffeeApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        
    }
}
