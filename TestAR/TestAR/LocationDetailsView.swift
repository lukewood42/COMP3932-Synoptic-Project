//
//  LocationDetailsView.swift
//  TestAR
//
//  Created by Luke Wood on 15/03/2023.
//

import SwiftUI
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseCore

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
}

struct LocationDetailsView: View {
    @ObservedObject private var locationStore = LocationStore()
    let location: Location
    var body: some View {
        ZStack(){
            Image(location.name)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .blur(radius: 30)
            VStack {
                Text(location.name)
                    .font(.custom("Questrial", size: 50))
                ZStack{
                    if location.checkedIn {
                        Image(systemName:"circle")
                            .resizable()
                            .foregroundColor(.green.opacity(1))
                            .frame(maxWidth: 310, maxHeight: 310)
                    }
                    Image(location.name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                    
                    if location.checkedIn {
                        Image(systemName:"checkmark.seal.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .frame(maxWidth: 100, maxHeight: 100)
                            .padding([.bottom, .leading],220)
                    }
                        
                }.frame(maxWidth: 400, maxHeight: 400)
                Spacer()
                Text(location.artist)
                Spacer()
                Button(action: {
                    toggleFavourite(ArtID: location.id)
                }, label: {
                    if !location.favourite {
                        Image(systemName: "star")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30)
                    }
                    else {
                        Image(systemName: "star.fill")
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(maxWidth: 30, maxHeight: 30)
                    }
                })
            }
            .frame(maxWidth: UIScreen.screenWidth, maxHeight: UIScreen.screenHeight-100, alignment:.top)
        }.frame(maxWidth: UIScreen.screenWidth, maxHeight: UIScreen.screenHeight-30)
    }
}

extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description: String {
        "\(latitude);\(longitude)"
    }
}

func toggleFavourite(ArtID: Int) {
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
            data?["favourite"] = !currentFavourite
            
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

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsView(location: Location(id: 0, name: "Sign for Art", artist: "Keith Wilson", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), checkedIn: true, favourite: false))
    }
}
