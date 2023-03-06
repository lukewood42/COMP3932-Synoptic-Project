//
//  ARView.swift
//  ARProject
//
//  Created by Luke Wood on 19/10/2022.
//

import SwiftUI
import RealityKit
import ARKit

struct ARView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable{
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: CGRect.zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> ARViewContainer.Coordinator {
        return Coordinator()
    }

    class Coordinator {}
    
}

#if DEBUG
struct ARView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
