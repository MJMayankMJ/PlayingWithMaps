//
//  Location.swift
//  BucketList
//
//  Created by Mayank Jangid on 1/2/25.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    // why var -- cz untill this id changes, while comparing swift wont give a fk about other parameter ie if it is let than it wond replace the new name of that location when u edit it cz it will check if the location changed ie lhs.id == rhs.id ..... it will show same incase of let ..... this it wont replance the newLocation in the locations array.
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var cordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Buckingham palace", description: "Lit!!!!", latitude: 51.501, longitude: -0.141)
    #endif
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

}
