//
//  ContentView.swift
//  ARProject
//
//  Created by Luke Wood on 14/02/2023.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var showingMap = false
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
