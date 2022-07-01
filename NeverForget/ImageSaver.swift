//
//  ImageSaver.swift
//  NeverForget
//
//  Created by Carson Gross on 6/30/22.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    func writeToSecureDirectory(uiImage: UIImage, name: String) -> URL? {
        if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
            let url = self.getDocumentsDirectory().appendingPathComponent("\(name).jpg")
            try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
            return url
        }
        return nil
    }
    
    func deleteFromSecureDirectory(name: String) -> Bool {
        let fileUrl = self.getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        let filePath = fileUrl.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            try? fileManager.removeItem(atPath: filePath)
            return true
        } else {
            print("File at path \(filePath) does not exist")
            return false
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
