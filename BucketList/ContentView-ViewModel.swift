//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Mayank Jangid on 1/12/25.
//

import Foundation
import CoreLocation
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel{
        let savedPath = URL.documentsDirectory.appending(path: "SavedPlaces")
        var selectedPlace: Location?
        var isUnlocked = false
        private(set) var locations : [Location] // this makes writing of location from other views impossible --> this will tell where we need to improve the viewModel design .... as you can see its not perfekt as selectedPlace is not private(set).
        
        init(){
            do {
                let data = try Data(contentsOf: savedPath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savedPath, options: [.atomic,.completeFileProtection])
            } catch{
                print("Unable to save data")
            }
        }
        
        func addNewLocation(at point: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateNewLocation(location: Location){
            guard let selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
                }
        }
        
        func authenticateUser(){
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authenticate yourself to use this app"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    if success{
                        self.isUnlocked = true
                    } else {
                        //error
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}
