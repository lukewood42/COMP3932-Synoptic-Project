//
//  SignUpView.swift
//  TestAR
//
//  Created by Luke Wood on 23/03/2023.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var passwordConfirm = ""
    @State var errorMessage = ""
    @State private var showingAlert = false
    
    let gradient = LinearGradient(colors: [Color.blue,Color.green],
                                      startPoint: .top, endPoint: .bottom)
    var body: some View {
        ZStack{
            gradient.opacity(0.25).ignoresSafeArea()
            VStack {
                Text("Sign Up").font(.custom("Questrial", size: 50))
                    
            }
            .frame(maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top, 120)
            VStack {
                // Declares the text field for users email
                Spacer()
                TextField("Email", text: $email)
                    .font(.custom("Questrial", size: 20))
                    .padding()
                    .cornerRadius(10)
                Divider()
                    .frame(height: 2)
                    .frame(width: 350)
                    .background(Color.black)
                
                // Declares the text field for users password
                SecureField("Password", text: $password)
                    .font(.custom("Questrial", size: 20))
                    .padding()
                    .cornerRadius(10)
                Divider()
                    .frame(height: 2)
                    .frame(width: 350)
                    .background(Color.black)
                
                // Declares the text field for users password confirmation

                SecureField("Confirm Password", text: $passwordConfirm)
                    .font(.custom("Questrial", size: 20))
                    .padding()
                    .cornerRadius(10)
                Divider()
                    .frame(height: 2)
                    .frame(width: 350)
                    .background(Color.black)
                
                // Button that triggers sign up function
                Button(action: { signup() }) {
                    Text("Sign Up")
                        .padding().frame(maxWidth: .infinity).background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                }
                .alert(errorMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    // Sign up function that calls the Firebase API
    func signup() {
        if password != passwordConfirm {
            errorMessage = "Passwords do not match"
            showingAlert = true
        }
        else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    errorMessage = (error?.localizedDescription ?? "")
                    showingAlert = true
                } else {
                    errorMessage = "Account created!"
                    showingAlert = true
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
