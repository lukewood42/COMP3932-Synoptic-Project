//
//  MapView.swift
//  ARProject
//
//  Created by Luke Wood on 14/02/2023.
//

import SwiftUI
import MapKit

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

struct MapView: View {
    @StateObject private var manager = LocationManager()

    struct Location: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }
    
    let locations = [
        Location(name: "Sign for Art", coordinate: CLLocationCoordinate2D(latitude: 53.80707773761575, longitude: -1.5543325025522405)),
        Location(name: "The Dreamer", coordinate: CLLocationCoordinate2D(latitude: 53.80763871650491, longitude: -1.5549980580280098))
    ]
    
    @Environment(\.dismiss) var dismiss
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.800755, longitude: -1.549077), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {

        Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: locations) { location in
            MapMarker(coordinate: location.coordinate)
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
