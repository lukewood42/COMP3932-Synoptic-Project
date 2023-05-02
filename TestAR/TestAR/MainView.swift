//
//  MainView.swift
//  TestAR
//
//  Created by Luke Wood on 17/03/2023.
//

import SwiftUI
import RealityKit


struct MainView: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    

    let gradient = LinearGradient(colors: [Color.blue,Color.green],
                                      startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    // Declaring an instance of the MapView struct
                    MapView()
                        .navigationTitle(Text("Leeds Art"))
                        .padding(.top)
                        .navigationBarTitleDisplayMode(.inline)
                        // Populating the toolbar with navigation links to ListView and AugView
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading){
                                NavigationLink(destination: ListView()) {
                                    HStack {
                                        Image(systemName: "list.bullet")
                                    }
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing){
                                NavigationLink(destination: AugView()) {
                                    HStack {
                                        Image(systemName: "arkit")
                                    }
                                }
                            }
                        }
                }
                
                VStack{
                    Spacer()
                    // Declaring a navigation link to ProfileView using the gear icon
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Spacer()
                            Image(systemName: "gear.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(maxWidth: 40, maxHeight: 40)
                                .padding()
                        }
                    }
                }
            }
            
        }
        
        .edgesIgnoringSafeArea(.all)
        
    }
}



#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
