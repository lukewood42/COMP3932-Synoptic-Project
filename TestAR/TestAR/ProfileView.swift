//
//  ProfileView.swift
//  TestAR
//
//  Created by Luke Wood on 05/04/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

struct ProfileView: View {
    @State private var confirmationShown = false
    @State var password = ""
    @State var passwordConfirm = ""
    @State private var showingAlert = false
    @State var errorMessage = ""
    @Binding var isLoggedIn: Bool


    let gradient1 = LinearGradient(colors: [Color.red,Color.green],
                                   startPoint: .top, endPoint: .bottom)
    let gradient2 = LinearGradient(colors: [Color.blue,Color.orange],
                                   startPoint: .top, endPoint: .bottom)
    var body: some View {
        ZStack{
            gradient1.opacity(0.25).ignoresSafeArea().blur(radius: 1)
            VStack{

                SecureField("New Password", text: $password)
                    .font(.custom("Questrial", size: 20))
                    .padding()
                //.background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Divider()
                    .frame(height: 2)
                    
                    .background(Color.black)
                
                SecureField("Confirm Password", text: $passwordConfirm)
                    .font(.custom("Questrial", size: 20))
                    .padding()
                //.background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Divider()
                    .frame(height: 2)
                    .background(Color.black)
                Spacer()
                
                Button(action: { updatePassword() }) {
                    Text("Update Password")
                        .padding().frame(maxWidth: .infinity).background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                }
                Button(action: { confirmationShown = true   }) {
                    Text("Delete Account")
                        .padding().frame(maxWidth: .infinity).background(Color.red.opacity(0.2)).foregroundColor(.red)
                            .cornerRadius(10)
                }.confirmationDialog(
                    "Are you sure?",
                     isPresented: $confirmationShown,
                    titleVisibility: .visible
                ) {
                    Button("Confirm", role: .destructive) {
                        
                            deleteAccount()
                        
                    }
                }.alert(errorMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }.frame(maxWidth: UIScreen.screenWidth-30, maxHeight: 450)
        }
    }
    func updatePassword() {
        if password != passwordConfirm {
            errorMessage = "Passwords do not match"
            showingAlert = true
        }
        else {
            Auth.auth().currentUser?.updatePassword(to: password) { error in
                if let error = error {
                    errorMessage = (error.localizedDescription)
                } else {
                    errorMessage = "Password Changed"
                }
                showingAlert = true

            }
        }
    }
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
              errorMessage = (error.localizedDescription)
          } else {
              errorMessage = "Account Deleted"
              isLoggedIn = false
          }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
    }
}
