//
//  ContentView.swift
//  ARProject
//
//  Created by Luke Wood on 14/02/2023.
//

import SwiftUI
import MapKit
import Firebase
import RealityKit
import ARKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    return true
  }
    
}



struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var loggedIn = false

    var body: some View {
        NavigationView {
        VStack {
            Image(systemName: "camera.filters")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                
            Text("Welcome to AR-t")
                .font(.title)
                .foregroundColor(.green)
                .padding()
        
          
            NavigationLink(destination: MapView()) {
                Text("Map")
                }
            }
            
        }
        
        .edgesIgnoringSafeArea(.all)
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
