//
//  DrinkDetail.swift
//  iCoffee
//
//  Created by Arup Sarkar on 1/18/21.
//

import SwiftUI

struct DrinkDetail: View {
    
    @State private var showingAlert = false
    @State private var showingLogin = false
    
    var drink: Drink
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .bottom) {
                Image(drink.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Rectangle()
                    .frame(height: 80)
                    .foregroundColor(.black)
                    .opacity(0.35)
                    .blur(radius: 10)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(drink.name)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    .padding(.leading)
                    .padding(.bottom)
                    Spacer()
                } // End of HStack
                .listRowInsets(EdgeInsets())
            } // End of ZStack
            
            Text(drink.description)
                .foregroundColor(.primary)
                .font(.body)
                .lineLimit(5)
                .padding()
            
            HStack {
                Spacer()
                OrderButton(showAlert: $showingAlert, showLogin: $showingLogin, drink: self.drink)
                Spacer()
            }
            .padding(.top, 50)
            
        } //End of ScrollView
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(false)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Added to Basket"),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct DrinkDetail_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetail(drink: drinkData.first!)
    }
}


struct OrderButton : View {
    @ObservedObject var basketListener = BasketListener()
    @Binding var showAlert: Bool
    @Binding var showLogin: Bool
    var drink: Drink
    
    var body : some View {
        Button(action: {
            
            //check if user logged in
            if FUser.currentUser() != nil &&
                FUser.currentUser()!.onBoarding {
                self.showAlert.toggle()
                self.addItemToBasket()
                
            }else {
                self.showLogin.toggle()
            }
            
            print("Add to Basket, \(self.drink.name)")

        },
               label: {
            Text("Add to Basket")
        })
        .frame(width: 200, height: 50)
        .foregroundColor(.white)
        .font(.headline)
        .background(Color.blue)
        .cornerRadius(10)
        
        .sheet(isPresented: self.$showLogin) {
            if FUser.currentUser() != nil {
                FinishRegistrationView()
            }else {
                LoginView()
            }
        }
    }
    
    private func addItemToBasket() {
     
        var orderBasket: OrderBasket!
        
        if self.basketListener.orderBasket != nil {
            orderBasket = self.basketListener.orderBasket
        }else {
            orderBasket = OrderBasket()
            orderBasket.ownerId = FUser.currentId()
            orderBasket.id = UUID().uuidString
        }
        // check user as basket
        // initialize order basket

        orderBasket.add(self.drink)
        
        orderBasket.saveBasketToFirestore()
    }
}
