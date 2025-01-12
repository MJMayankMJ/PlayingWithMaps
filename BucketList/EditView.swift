//
//  EditView.swift
//  BucketList
//
//  Created by Mayank Jangid on 1/6/25.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading
        case loaded
        case failed
    }
    @State private var loadingState: LoadingState = .loading
    @State private var pages = [Page]()
    
    @Environment(\.dismiss) var dismiss
    var locationnn: Location
    var onSaveee: (Location) -> Void
    
    @State private var name: String
    @State private var description: String

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                Section("Nearby"){
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                        
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                        
                    case .failed:
                        Text("Pls try again later")
                    }
                }
            }
            .task {
                await nearbyPlaces()
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = locationnn
                    newLocation.name = name
                    newLocation.description = description
                    newLocation.id = UUID()
                    onSaveee(newLocation)
                    dismiss()
                }
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.locationnn = location
        self.onSaveee = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
        
    }
    
    func nearbyPlaces() async{
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(locationnn.latitude)%7C\(locationnn.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
               print("Bad URL: \(urlString)")
               return
           }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
        
    }
}

#Preview {
    EditView(location: .example) { _ in}
}
