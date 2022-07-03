//
//  PhotoView.swift
//  NeverForget
//
//  Created by Carson Gross on 7/3/22.
//

import SwiftUI

struct PhotoView: View {
    var photo: Photo
    var showingEditor: Bool
    
    var body: some View {
        photo.image?
            .resizable()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
            .cornerRadius(15)

        if !showingEditor {
            Text(photo.name)
                .font(photo.name.count > 8 ? .caption : .title)
                .fontWeight(.black)
                .padding(10)
                .foregroundColor(.white)
                .shadow(radius: 15)
                .offset(x: -5, y: -5)
        } else {
            Image(systemName: "trash.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .shadow(radius: 15)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 200)
        }
    }
}

//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView()
//    }
//}
