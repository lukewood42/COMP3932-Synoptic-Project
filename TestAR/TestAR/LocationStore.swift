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
import SwiftUI

struct Location: Identifiable {
    var id: Int
    var name: String
    var artist: String
    var coordinate: CLLocationCoordinate2D
    var checkedIn: Bool
    var favourite: Bool
}

class LocationStore: ObservableObject {
    @Published var locations: [Location]
    
    init() {
        // Initialize locations array
        self.locations = [
            Location(id: 1, name: "Sign for Art",artist: "Keith Wilson", coordinate: CLLocationCoordinate2D(latitude: 53.80707773761575, longitude: -1.5543325025522405), checkedIn: false, favourite: false),
            Location(id: 2, name: "The Dreamer",artist: "Quentin Bell", coordinate: CLLocationCoordinate2D(latitude: 53.80763871650491, longitude: -1.5549980580280098), checkedIn: false, favourite: false),
            Location(id: 3, name: "A Spire",artist: "Simon Fujiwara", coordinate: CLLocationCoordinate2D(latitude: 53.806978, longitude: -1.551492), checkedIn: false, favourite: false),
            Location(id: 4, name: "Converse Column",artist: "Lilian Lijn", coordinate: CLLocationCoordinate2D(latitude: 53.80519387548155, longitude: -1.549018309242582), checkedIn: false, favourite: false)
            
        ]
        
        // Call isCheckedIn for each location and update the checkedIn property
        for (index, location) in locations.enumerated() {
            isCheckedIn(ArtID: location.id) { checkedIn in
                self.locations[index].checkedIn = checkedIn
            }
        }
        startListening()

    }
    
    // Function that queries the detabase for the 'checkedIn' value of an artwork
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
    
    // Function that queries the detabase for the 'favourite' value of an artwork
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
    
    // Listening function that updates the location array when changes are made to the database
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
        }
    }
    
    // Functions used to calculate completion percentage
    func calculateCompletion() -> (Float) {
        var count = 0
        for location in self.locations {
            if location.checkedIn == true {
                count += 1
            }
        }
        let completetionFloat = Float(count) / Float(self.locations.count)
        return completetionFloat
    }
    
    func calculatePercentage() -> (String){
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter.string(from: calculateCompletion() as NSNumber)!
    }
    
    func progressColour() -> (Color) {
        let completion = calculateCompletion()
        if completion < 0.4 {
            return .red
        }
        else if completion < 1 {
            return .yellow
        }
        else {
            return .green
        }
    }
}
