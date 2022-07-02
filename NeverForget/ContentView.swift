//
//  ContentView.swift
//  NeverForget
//
//  Created by Carson Gross on 6/29/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var photos = PhotoCollection()
    @State private var newImage: UIImage?
    @State private var newImageName = ""
    @State private var showImagePicker = false
    @State private var showNameImage = false
    @State private var showingEditor = false
    @State private var showDeleteAlert = false
    @State private var tappedPhoto = Photo(name: "")
    let locationFetcher = LocationFetcher()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                    ForEach(photos.items.sorted()) { photo in
                        NavigationLink(
                            destination: PhotoDetailsView(photo: photo).environmentObject(photos),
                            label: {
                                HStack {
                                    ZStack(alignment: .bottomLeading) {
                                        if !showingEditor {
                                            photo.image?
                                                .resizable()
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
                                                .cornerRadius(15)

                                        Text(photo.name)
                                            .font(photo.name.count > 8 ? .caption : .title)
                                            .fontWeight(.black)
                                            .padding(10)
                                            .foregroundColor(.white)
                                            .shadow(radius: 15)
                                            .offset(x: -5, y: -5)
                                            .alert("Are you sure you want to delete this photo?", isPresented: $showDeleteAlert) {
                                                Button("Cancel", role: .cancel) {
                                                    showDeleteAlert = false
                                                    showingEditor = true
                                                }
                                                Button("Delete", role: .destructive) {
                                                    deletePhoto(photo: tappedPhoto)
                                                }
                                            }
                                        } else {
                                            Button () {
                                                showDeleteAlert = true
                                                tappedPhoto = photo
                                                showingEditor = false
                                            } label: {
                                                ZStack {
                                                    photo.image?
                                                        .resizable()
                                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
                                                        .cornerRadius(15)
                                                    
                                                    Image(systemName: "trash.circle.fill")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .foregroundColor(.red)
                                                        .shadow(radius: 15)
                                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
                                                }
                                            }
                                            .wiggling()
                                        }
                                    }
                                }
                            })
                    }
                }
                .padding()
            }
            .padding(.top, 15)
            .sheet(isPresented: $showNameImage, onDismiss: saveImage) {
                EditPhotoName(name: $newImageName)
            }
            .navigationBarTitle("Never Forget")
            .navigationBarItems(
                leading: showingEditor ? Button("Cancel") { showingEditor = false } : Button("Edit") { showingEditor = true },
                
                trailing: Button("Add") {
                    showingEditor = false
                    showImagePicker = true                }
                
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $newImage)
                }
            )
        }
    }
    
    func loadImage() {
        locationFetcher.start()
        showNameImage = true
    }
    
    func deletePhoto(photo: Photo) {
        if let photoIndex = photos.items.firstIndex(where: { $0.id == photo.id }) {
            photos.items[photoIndex].deleteFromSecureDirectory()
            photos.items.remove(at: photoIndex)
        }
        if photos.items.isEmpty {
            showingEditor = false
        }
        showingEditor = true
    }
    
    func saveImage() {
        guard let newImage = newImage else { return }
        var newPhoto = Photo(name: newImageName)
        newPhoto.writeToSecureDirectory(uiImage: newImage)
        if let location = self.locationFetcher.lastKnownLocation {
            newPhoto.setLocation(location: location)
        }
        photos.append(newPhoto)
        newImageName = ""
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
