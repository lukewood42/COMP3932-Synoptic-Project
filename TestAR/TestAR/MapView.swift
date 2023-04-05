//
//  MapView.swift
//  ARProject
//
//  Created by Luke Wood on 14/02/2023.
//

import SwiftUI
import MapKit
import RealityKit
import ARKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


let db = Firestore.firestore()
let checkins = db.collection("check-ins")


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    private let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            let center = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            region = MKCoordinateRegion(center: center, span: span)
        }
    }
}

struct PlaceAnnotationView: View {
    
    let title: String
    let checkedIn: Bool
    let favourite: Bool
    var body: some View {
    
        VStack {
            if favourite {
                ZStack {
                    Image(systemName: "star.circle.fill")
                        .font(.title)
                        .foregroundColor(checkedIn ? Color.green : Color.red)
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(.yellow)
                }
            }
            else {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(checkedIn ? Color.green : Color.red)
            }
                
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(checkedIn ? Color.green : Color.red)
                .offset(x: 0, y: -5)
        }
    }
}

struct MapView: View {
    @ObservedObject private var locationStore = LocationStore()
    @StateObject private var manager = LocationManager()

    
    @Environment(\.dismiss) var dismiss
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.800755, longitude: -1.549077), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    
    var body: some View {
        VStack{
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: locationStore.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    NavigationLink {
                        LocationDetailsView(location: location)
                    }
                label: {
                        PlaceAnnotationView(title: location.name, checkedIn: location.checkedIn, favourite: location.favourite)
                    }
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
