//
//  PhotoDetails.swift
//  NeverForget
//
//  Created by Carson Gross on 6/29/22.
//

import SwiftUI
import MapKit

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct PhotoDetails: View {
    
    var photo: Photo
    @State private var newImageName = ""
    @State private var showNameImage = false
    @EnvironmentObject var photos: PhotoCollection
    @State private var showDeleteAlert = false
    
    var markers: [LocationPin] {
        if let location = photo.location {
            return [LocationPin(coordinate: location)]
        }
        return []
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                photo.image?
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            if let location = photo.location {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Location")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Delete") {
                            showDeleteAlert = true
                        }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), annotationItems: markers) { item in
                        MapPin(coordinate: item.coordinate)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .navigationBarTitle(photo.name, displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit") {
            showNameImage = true
        })
        .sheet(isPresented: $showNameImage, onDismiss: saveImageName) {
            EditPhotoName(name: $newImageName)
        }
        .onAppear() {
            newImageName = photo.name
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Do you want to delete"),
                message: Text("Are you sure you want to delete \(photo.name)"),
                primaryButton: .default(
                    Text("Cancel"),
                    action: cancelDelete
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: deletePhoto
                )
            )
        }
    }
    
    func saveImageName() {
        let photoIndex = photos.items.firstIndex(where: { $0.id == photo.id })
        if let photoIndex = photoIndex {
            photos.items[photoIndex].name = newImageName
        }
    }
    
    func deletePhoto() {
        let photoIndex = photos.items.firstIndex(where: { $0.id == photo.id })
        if let photoIndex = photoIndex {
            photos.items[photoIndex].deleteFromSecureDirectory()
            photos.items.remove(at: photoIndex)
        }
    }
    
    func cancelDelete() {
        showDeleteAlert = false
    }
}

//struct PhotoDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoDetails(photo: PhotoCollection().items[0])
//    }
//}
