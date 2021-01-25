//
//  OrderBasketView.swift
//  iCoffee
//
//  Created by Arup Sarkar on 1/19/21.
//

import SwiftUI

struct OrderBasketView: View {
    
    @ObservedObject var basketListener = BasketListener()
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    ForEach(self.basketListener.orderBasket?.items ?? []) {
                        drink in
                        HStack {
                            Text(drink.name)
                            Spacer()
                            Text("$\(drink.price.clean)")
                        } // end of HStack
                    } //end of for each
                    .onDelete(perform: { indexSet in
                        print("Deleted order index \(indexSet)")
                        self.deleteItems(at: indexSet)
                    })
                } //end of section
                
                Section {
                    NavigationLink(
                        destination: CheckoutView()) {
                        Text("Place Order")
                    }
                    
                }.disabled(self.basketListener.orderBasket?.items.isEmpty ?? true)
            } //end of List
            .navigationBarTitle("Order")
            .listStyle(GroupedListStyle())
        } // end of navigation view
        
    }
    
    func deleteItems(at offsets: IndexSet) {
        self.basketListener.orderBasket.items.remove(at: offsets.first!)
        self.basketListener.orderBasket.saveBasketToFirestore()
    }
}

struct OrderBasketView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBasketView()
    }
}
