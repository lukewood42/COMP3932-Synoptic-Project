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
    @State var email = ""
    @State var displayName = ""
    @State var emailInEditMode = false
    @State var nameInEditMode = false
    let gradient = LinearGradient(colors: [Color.red,Color.green],
                                      startPoint: .top, endPoint: .bottom)
    var body: some View {
        ZStack{
            gradient.opacity(0.25).ignoresSafeArea().blur(radius: 1)
            ScrollView{
                VStack{
                    //let user = Auth.auth().currentUser

                    //                    Text(user.displayName!)
                    //                        .font(.custom("Questrial", size: 50))
                    //
                    //                }
                    if !nameInEditMode {
                        HStack {
                            Text("Luke Wood").font(.custom("Questrial", size: 50))
                
                                .padding([.leading, .trailing])
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .cornerRadius(10)
                            Button(action: {
                                let currentlyEditable = nameInEditMode
                                nameInEditMode = !currentlyEditable
                            }, label: {
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: 30, maxHeight: 30, alignment: .trailing)
                                    .padding([.leading, .trailing])
                            })
                        }
                        .frame(maxHeight:70)
                        .padding(.top,90)
                        
                        
                    }
                    else {
                        TextField("", text: $displayName)
                            .textFieldStyle(.plain)
                            .font(.custom("Questrial", size: 50))
                            .padding(.top, 40)
                            .padding([.top, .leading, .trailing])
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                     .frame(height: 2)
                     .frame(width: UIScreen.screenWidth-30)
                     .background(Color.black)
        
                    TextField("lukewood42@gmail.com", text: $email)
                        .font(.custom("Questrial", size: 25))
                        .padding(.top, 40)
                        .padding([.top, .leading, .trailing])
                        //.background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                     .frame(height: 2)
                     .frame(width: UIScreen.screenWidth-30)
                     .background(Color.black)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
