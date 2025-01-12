//
//  ContentView.swift
//  BucketList
//
//  Created by Mayank Jangid on 12/25/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var viewModel = ViewModel()
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        if viewModel.isUnlocked{
            MapReader{ proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.cordinate){
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.cyan)
                                .frame(width: 40, height: 40)
                                .background(.white)
                                .clipShape(.circle)
                            //                            .onLongPressGesture {
                            //                                selectedPlace = location
                            //                            } idk why this just doesnot work
                            //My guess is the Map's gestures take priority here so by using .simultaneousGesture, you get to have SwiftUI recognize the LongPressGesture alongside other gestures
                                .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in viewModel.selectedPlace = location })
                        }
                    }
                }
                .onTapGesture { position in
                    if let cordinate = proxy.convert(position, from: .local){
                        viewModel.addNewLocation(at: cordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) { //newLocationnn in ---->Edit view wali new location jo OnSave pass kr raha hei jab save press krte hei tab
                        viewModel.updateNewLocation(location: /*newLocationnn*/ $0)
                    }
                }
            }
        } else {
            Button("Authenitcate", action: viewModel.authenticateUser)
                .padding(10)
                .background(.cyan)
                .foregroundColor(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
