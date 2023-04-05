//
//  AugView.swift
//  TestAR
//
//  Created by Luke Wood on 16/02/2023.
//

import SwiftUI
import ARKit
import RealityKit
import Firebase
import FirebaseAuth
import FirebaseCore

struct AugView: View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        let bagAnchor = try!
            Experience.loadBag()
        let testAnchor = try!
            Experience.loadTest()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        arView.scene.anchors.append(bagAnchor)
        arView.scene.anchors.append(testAnchor)
        
        testAnchor.actions.testAction.onAction = { _ in
            checkIn(ArtID: 0)
        }

        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

func checkIn(ArtID: (Int)) -> Void {
    @ObservedObject var locationStore = LocationStore()
    let user = Auth.auth().currentUser
    if let user = user {
        let uid = user.uid
        let artRef = db.collection("users").document(uid).collection("art").document(String(ArtID))
        artRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            var data = document.data()
            data?["checkedIn"] = true
            
            artRef.setData(data!, merge: true) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document updated")
                }
            }
        }
    }
    print(locationStore)
}

struct AugView_Previews: PreviewProvider {
    static var previews: some View {
        AugView()
    }
}

