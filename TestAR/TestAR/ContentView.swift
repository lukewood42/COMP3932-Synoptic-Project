//
//  ContentView.swift
//  TestAR
//
//  Created by Luke Wood on 19/10/2022.
//

import SwiftUI
import RealityKit
import FirebaseAuth

struct ContentView: View {
    @State var isLoggedIn: Bool = false

    var body: some View {
        if !isLoggedIn {
            LoginView(isLoggedIn: $isLoggedIn)
        } else {
            MainView()
        }
    }
}




#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
