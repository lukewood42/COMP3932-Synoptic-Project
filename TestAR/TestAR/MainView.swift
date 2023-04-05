//
//  MainView.swift
//  TestAR
//
//  Created by Luke Wood on 17/03/2023.
//

import SwiftUI
import RealityKit

//import FirebaseFirestore
//private var db = Firestore.firestore()

struct MainView: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    

    //let citiesRef = db.collection("check-ins")
    let gradient = LinearGradient(colors: [Color.blue,Color.green],
                                      startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    MapView()
                    .navigationTitle(Text("Leeds Art").font(.custom("Questrial", size: 50)))
                    .padding(.top)
                    .navigationBarTitleDisplayMode(.inline)
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
