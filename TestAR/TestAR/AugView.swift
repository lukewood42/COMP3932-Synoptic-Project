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
        var ref: DocumentReference? = nil
        ref = db.collection("check-ins").addDocument(data: [
            "ArtID": 0,
            "Time": Timestamp(),
            "UserID": uid,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
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

