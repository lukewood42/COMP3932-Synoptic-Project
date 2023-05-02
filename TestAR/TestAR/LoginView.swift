//
//  LoginView.swift
//  TestAR
//
//  Created by Luke Wood on 22/03/2023.
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    // Declaring local and binding variables for text fields
    @State var email = ""
    @State var password = ""
    @Binding var isLoggedIn: Bool
    
    // Boolean variable for showing the pop up alert
    @State private var showingAlert = false
    
    let gradient = LinearGradient(colors: [Color.blue,Color.green],
                                      startPoint: .top, endPoint: .bottom)
    var body: some View {
        NavigationView {
            ZStack{
                gradient.opacity(0.25).ignoresSafeArea().blur(radius: 1)
                
                VStack {
                    Text("Leeds ").font(.custom("Questrial", size: 50)) + Text("AR").font(.custom("Questrial", size: 50)).foregroundColor(.blue) + Text("T").font(.custom("Questrial", size: 50))
                        
                }
                .frame(maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 120)
                
                // Populating the view with the email and password text entry fields
                VStack{
                    Spacer()
                    
                    TextField("Email", text: $email)
                        .font(.custom("Questrial", size: 20))
                        .padding()
                        .cornerRadius(10)
                    Divider()
                     .frame(height: 2)
                     .frame(width: 350)
                     .background(Color.black)
                    
                    SecureField("Password", text: $password)
                        .font(.custom("Questrial", size: 20))
                        .padding()
                        .cornerRadius(10)
                    Divider()
                     .frame(height: 2)
                     .frame(width: 350)
                     .background(Color.black)
                    
                    // Buttons for login and sign up
                    HStack{
                        Button(action: { login() }) {
                            Text("Login").bold()
                        }.padding().frame(maxWidth: .infinity+20).background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                        .alert("Incorrect Login Details", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up").padding().frame(maxWidth: .infinity)
                        }.background(Color.blue.opacity(0.1))
                            .cornerRadius(10)

                        
                    }
                    .padding(10)
                    Spacer()
                    
                }
                
                .ignoresSafeArea(.keyboard)
            }
        }
    }
    
    // Login function utilising Firebase API call
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                showingAlert = true
            } else {
                isLoggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView( isLoggedIn: .constant(false))
    }
}
