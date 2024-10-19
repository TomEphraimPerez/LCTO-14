//
//  ViewModelImages.swift
//  LCTO-14
//
//  Created by thomasperez on 10/17/24.
//

import Foundation


import SwiftUI
import CloudKit

class ViewModelImages: ObservableObject {
    @Published var beforeImage: UIImage?
    @Published var afterImage: UIImage?

    // CloudKit references (use your actual container ID)
    let container = CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-14")
    let publicDatabase = CKContainer.default().publicCloudDatabase

    // Upload Before Image to CloudKit
    func uploadBeforeImage() {
        guard let image = beforeImage else { return }
        uploadImageToCloudKit(image: image, field: "Image")
    }

    // Upload After Image to CloudKit
    func uploadAfterImage() {
        guard let image = afterImage else { return }
        uploadImageToCloudKit(image: image, field: "Image2")
    }

    // Core function to upload images to CloudKit
    private func uploadImageToCloudKit(image: UIImage, field: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let record = CKRecord(recordType: "ProductComment")
        let imageURL = saveImageToTemporaryURL(data: imageData)
        
        let asset = CKAsset(fileURL: imageURL)
        record[field] = asset

        publicDatabase.save(record) { record, error in
            if let error = error {
                print("Error saving \(field): \(error.localizedDescription)")
            } else {
                print("Successfully uploaded image for field \(field)")
            }
        }
    }

    // Helper function to save the image to a temporary URL
    private func saveImageToTemporaryURL(data: Data) -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = temporaryDirectory.appendingPathComponent(fileName)
        
        try? data.write(to: fileURL)
        return fileURL
    }
}
