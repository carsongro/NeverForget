//
//  Photo.swift
//  NeverForget
//
//  Created by Carson Gross on 6/29/22.
//

import Foundation
import SwiftUI
import MapKit

struct Photo: Codable, Identifiable {
    var id: UUID
    var name: String
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    var image: Image? {
        let url = self.getDocumentsDirectory().appendingPathComponent("\(id).jpg")
        
        guard let uiImage = try? UIImage(data: Data(contentsOf: url)) else {
            print("Error creating UIImage from url \(url)")
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
    
    var location: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    mutating func setLocation(location: CLLocationCoordinate2D) {
        longitude = location.longitude
        latitude = location.latitude
    }
    
    mutating func writeToSecureDirectory(uiImage: UIImage) {
        let imageSaver = ImageSaver()
        let _ = imageSaver.writeToSecureDirectory(uiImage: uiImage, name: id.uuidString)
    }
    
    mutating func deleteFromSecureDirectory() {
        let imageSaver = ImageSaver()
        let _ = imageSaver.deleteFromSecureDirectory(name: id.uuidString)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension Photo: Comparable {
    static func < (lhs: Photo, rhs: Photo) -> Bool {
        if lhs.name == rhs.name {
            return lhs.name.lowercased() < rhs.name.lowercased()
        }
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
}
