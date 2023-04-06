//
//  ListView.swift
//  TestAR
//
//  Created by Luke Wood on 03/04/2023.
//

import SwiftUI

struct ListView: View {
    @ObservedObject private var locationStore = LocationStore()
    let gradient = LinearGradient(colors: [Color.white,Color.purple],
                                      startPoint: .top, endPoint: .bottom)
    var body: some View {
        ZStack{
            gradient.opacity(0.25).ignoresSafeArea().blur(radius: 1)
            VStack{
                List(locationStore.locations) { location in
                    NavigationLink(destination: LocationDetailsView(location: location)) {
                        HStack(spacing: 10) {
                            Image(location.name)
                                .resizable()
                                .scaledToFill()
                                .padding(0.0)
                                .clipped()
                                .frame(width: 55, height: 50, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text(location.name)
                            if location.checkedIn{
                                Spacer()
                                Image(systemName:"checkmark.seal.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
