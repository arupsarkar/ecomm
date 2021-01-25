//
//  LoginView.swift
//  iCoffee
//
//  Created by Arup Sarkar on 1/19/21.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    
    @State var showingSignp = false
    @State var showingFinishReg = false
    @Environment(\.presentationMode) var presentationMode
    @State var email = ""
    @State var password = ""
    @State var repeatPassword = ""
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            
            Text("Sign In")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.bottom, .top], 20)
            
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(.label))
                        .opacity(0.75)
                    
                    TextField("Enter your email", text: $email)
                    Divider()
                    
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(.label))
                        .opacity(0.75)
                    
                    SecureField("Enter your password", text: $password)
                    Divider()
                    
                    
                    if(showingSignp) {
                        Text("Repeat Password")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label))
                            .opacity(0.75)
                        
                        SecureField("repeat password", text: $repeatPassword)
                        Divider()
                    }
                }
                .padding(.bottom, 15)
                .animation(.easeInOut(duration: 0.1))
                //end of VStack
                HStack {
                    Spacer()
                    Button(action: {
                        print("reset password")
                        self.resetPassword()
                    }, label: {
                        Text("Forgot Password?")
                            .foregroundColor(Color.gray.opacity(0.5))
                    })
                }
                //end of HStack
            }
            .padding(.horizontal, 6)
            //end of VStack
            Button(action: {

                self.showingSignp ? self.signUpUser() : self.loginUser()
                
            }, label: {
                Text( showingSignp ? "Sign Up" : "Sign In")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                    .padding()
            })
            .background(Color.blue)
            .clipShape(Capsule())
            .padding(.top, 45)
            //end of button
            
            SignUpView(showingSignup: $showingSignp)
        }// end of VStack
        .sheet(isPresented: $showingFinishReg) { 
            FinishRegistrationView()
        }
        
    } // end of body
    
    private func loginUser() {
        print("loginUser()")
        if email != "" && password != "" {
            FUser.loginUserWith(email: email, password: password) { (error, isEmailVerified) in
                if error != nil {
                    print("Error logging in user", error!.localizedDescription)
                    return
                }
                
                print("user login successfully. Email is verified", isEmailVerified)
                
                if FUser.currentUser() != nil && FUser.currentUser()!.onBoarding {
                    self.presentationMode.wrappedValue.dismiss()
                }else {
                    self.showingFinishReg.toggle()
                }
            }
        }
    }
    
    private func signUpUser() {
        print("signUpUser()")
        if email != "" && password != "" && repeatPassword != "" {
            if password == repeatPassword {
                FUser.registerUserWith(email: email, password: password) { (error) in
                    if error != nil {
                        print("Error registering user ", error?.localizedDescription ?? "Error Description")
                        return
                    }
                    print("User has been created.")
                    //Navigate to app
                    //check if user onboarding is done
                    
                }
            }else {
                print("Passwords do not match")
            }
        } else {
            print("Email and password must be set.")
        }
        
    }
    
    private func resetPassword() {
        print("resetPassword()")
        if(email != "") {
            FUser.resetPassword(email: email) { (error) in
                if(error != nil) {
                    print("Error resetting password", error!.localizedDescription)
                    return
                }
                print("Please check your email.")
            }
        }else {
            //notify user
            print("Email is empty")
        }
        
    }
    
    func authenticate()  {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


struct SignUpView : View {
    @Binding var showingSignup: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 8) {
                Text("Don't have an account?")
                    .foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    self.showingSignup.toggle()
                }, label: {
                    Text("Sign Up")
                })
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            } //end of HStack
            .padding(.top, 25)
        } //end of VStack
    }
}
