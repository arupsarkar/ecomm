//
//  ContentView.swift
//  iCoffee
//
//  Created by Arup Sarkar on 12/24/20.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var drinkListener = DrinkListener()
    
    var categories: [ String : [Drink]] {
        .init(
            grouping: drinkListener.drinks,
            by: {$0.category.rawValue}
        )
    }

    var body: some View {

        NavigationView {

            
            List(categories.keys.sorted(), id: \String.self) {
                key in
                
                DrinkRow(categoryName: "\(key) Drink".uppercased(), drinks: self.categories[key]!)
                    .frame(height: 320)
                    .padding(.top)
                    .padding(.bottom)
            }
            
                .navigationBarTitle(Text("iCoffee"))
                .navigationBarItems(leading:
                    Button(action: {
                        print("log out")

                    }, label: {
                        Text("Log Out")
                    })
                ,trailing:
                    Button(action: {
                        print("basket")
                    }, label: {
                        Image("basket")
                    })
                )
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
