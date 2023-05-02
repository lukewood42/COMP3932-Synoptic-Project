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
        
        // Load the scene for each artwork from the "Experience" Reality File
        
        let Anchor1 = try! Experience.loadAnchor1()
        let Anchor2 = try! Experience.loadAnchor2()
        let Anchor3 = try! Experience.loadAnchor3()
        let Anchor4 = try! Experience.loadAnchor4()
        // Add each anchor to the scene
        arView.scene.anchors.append(Anchor1)
        arView.scene.anchors.append(Anchor2)
        arView.scene.anchors.append(Anchor3)
        arView.scene.anchors.append(Anchor4)
        
        // Call the checkIn function whenever the 'scanned' behaviour is triggered
        Anchor1.actions.scanned.onAction = { _ in
            checkIn(ArtID: 1)
        }
        Anchor2.actions.scanned.onAction = { _ in
            checkIn(ArtID: 2)
        }
        Anchor3.actions.scanned.onAction = { _ in
            checkIn(ArtID: 3)
        }
        Anchor4.actions.scanned.onAction = { _ in
            checkIn(ArtID: 4)
        }
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

// Function to update the 'checkedIn' status of each art piece
func checkIn(ArtID: (Int)) -> Void {
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
}

struct AugView_Previews: PreviewProvider {
    static var previews: some View {
        AugView()
    }
}

