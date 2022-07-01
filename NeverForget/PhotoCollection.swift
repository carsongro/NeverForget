//
//  PhotoCollection.swift
//  NeverForget
//
//  Created by Carson Gross on 6/30/22.
//

import Foundation

class PhotoCollection: ObservableObject {
    @Published var items = [Photo]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                let url = getDocumentsDirectory().appendingPathComponent("photos.json")
                try? encoded.write(to: url, options: [.atomicWrite, .completeFileProtection])
            } else {
                fatalError("Error")
            }
        }
    }
    
    init() {

        let file = "photos.json"
        let url = getDocumentsDirectory().appendingPathComponent(file)
        
//        self.items = []
        
        guard let data = try? Data(contentsOf: url) else {
            items = []
            return
        }

        let decoder = JSONDecoder()
        guard let decodedPhotos = try? decoder.decode([Photo].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
                
        items = decodedPhotos
    }
    
    func append(_ item: Photo) {
        items.append(item)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
