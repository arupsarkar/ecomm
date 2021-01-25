//
//  CheckoutView.swift
//  iCoffee
//
//  Created by Arup Sarkar on 1/19/21.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var basketListener = BasketListener()
    static let paymentTypes = ["Cash", "Credit Card"]
    static let tipAmounts = [0, 10, 15, 20]
    @State private var paymentType = 0
    @State private var tipAmount = 2
    @State private var showingPaymentAlert = false
    var totalPrice: Double {
        let total = basketListener.orderBasket.total
        let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
        return total + tipValue
    }
    
    var body: some View {
        
        Form {
            Section {
                Picker(selection: $paymentType, label: Text("How do you want to pay ?")) {
                    ForEach(0 ..< Self.paymentTypes.count) {
                        Text(Self.paymentTypes[$0])
                    }
                }
            }// end of section
            
            Section (header: Text("Add a tip?"))  {
                Picker(selection: $tipAmount, label: Text("Percenteage: ")) {
                    ForEach(0 ..< Self.tipAmounts.count) {
                        Text("\(Self.tipAmounts[$0 ]) %")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }//end of section
            
            Section(header: Text("Total: $\(totalPrice, specifier: "%.2f")").font(.largeTitle)) {
                
                Button(action: {
                    print("Checkout")
                    //show alert
                    self.showingPaymentAlert.toggle()
                    //create order
                    self.createOrder()
                    //empty basket
                    self.emptyBasket()
                    
                }, label: {
                    Text("Confirm Order")
                })
            }
            .disabled(self.basketListener.orderBasket?.items.isEmpty ?? true)
            //end of section
            // .navigationBarTitle(Text("Payment"), displayMode: .inline)
        } //end of Form
        .navigationBarTitle(Text("Payment"), displayMode: .inline)
        .alert(isPresented: $showingPaymentAlert) {
            Alert(title: Text("Order Confirmed"), message: Text("Thank You!"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func createOrder() {
        let order = Order()
        order.amount = totalPrice
        order.id = UUID().uuidString
        order.customerId = FUser.currentId()
        order.orderItems = self.basketListener.orderBasket.items
        
        order.saveOrderToFirestore()
    }
    
    private func emptyBasket() {
        self.basketListener.orderBasket.emptyBasket()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
