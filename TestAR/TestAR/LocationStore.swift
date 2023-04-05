//
//  LocationStore.swift
//  TestAR
//
//  Created by Luke Wood on 03/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import MapKit

struct Location: Identifiable {
    let id: Int
    let name: String
    let artist: String
    let coordinate: CLLocationCoordinate2D
    var checkedIn: Bool
    var favourite: Bool
}

class LocationStore: ObservableObject {
    @Published var locations: [Location]
    
    init() {
        // Initialize locations array
        self.locations = [
            Location(id: 0, name: "test scan", artist: "Luke Wood", coordinate: CLLocationCoordinate2D(latitude: 53.8167, longitude: -1.5558), checkedIn: false, favourite: false),
            Location(id: 1, name: "Sign for Art",artist: "Keith Wilson", coordinate: CLLocationCoordinate2D(latitude: 53.80707773761575, longitude: -1.5543325025522405), checkedIn: false, favourite: false),
            Location(id: 2, name: "The Dreamer",artist: "Quentin Bell", coordinate: CLLocationCoordinate2D(latitude: 53.80763871650491, longitude: -1.5549980580280098), checkedIn: false, favourite: false)
            
        ]
        
        // Call isCheckedIn for each location and update the checkedIn property
        for (index, location) in locations.enumerated() {
            isCheckedIn(ArtID: location.id) { checkedIn in
                self.locations[index].checkedIn = checkedIn
            }
            
        }
        startListening()

    }
    
    private func isCheckedIn(ArtID: Int, completion: @escaping (Bool) -> Void) {
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
                let currentFavourite = data?["checkedIn"] as? Bool ?? false
                if currentFavourite {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func isFavourite(ArtID: Int, completion: @escaping (Bool) -> Void) {
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
                let currentFavourite = data?["favourite"] as? Bool ?? false
                if currentFavourite {
                    completion(false)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    
    func startListening() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            db.collection("users").document(uid).collection("art")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    snapshot.documentChanges.forEach { diff in
                        if let artID = Int(diff.document.documentID) {
                            if let index = self.locations.firstIndex(where: { $0.id == artID }) {
                                if let checkedIn = diff.document.data()["checkedIn"] as? Bool {
                                    self.locations[index].checkedIn = checkedIn
                                }
                                if let favourite = diff.document.data()["favourite"] as? Bool {
                                    self.locations[index].favourite = favourite
                                }
                            }
                        }
                    }
                }
//            db.collection("check-ins").whereField("UserID", isEqualTo: uid)
//                .addSnapshotListener { (querySnapshot, error) in
//                    guard let snapshot = querySnapshot else {
//                        print("Error fetching snapshots: \(error!)")
//                        return
//                    }
//                    snapshot.documentChanges.forEach { diff in
//                        if (diff.type == .added || diff.type == .modified) {
//                            let data = diff.document.data()
//                            if let artID = data["ArtID"] as? Int {
//                                if let index = self.locations.firstIndex(where: { $0.id == artID }) {
//                                    self.locations[index].checkedIn = true
//                                }
//                            }
//                        }
//                    }
//                }
//            db.collection("favourites").whereField("UserID", isEqualTo: uid)
//                .addSnapshotListener { (querySnapshot, error) in
//                    guard let snapshot = querySnapshot else {
//                        print("Error fetching snapshots: \(error!)")
//                        return
//                    }
//                    snapshot.documentChanges.forEach { diff in
//                        if (diff.type == .added || diff.type == .modified) {
//                            let data = diff.document.data()
//                            if let artID = data["ArtID"] as? Int {
//                                if let index = self.locations.firstIndex(where: { $0.id == artID }) {
//                                    self.locations[index].favourite = (data["favourite"] != nil)
//                                }
//                            }
//                        }
//                    }
//                }
        }
    }

}
