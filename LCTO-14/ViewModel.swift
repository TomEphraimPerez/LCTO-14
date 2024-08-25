//
// Copyright © 2024 bundle LCTO -14
/*
 VM.swift
 LCTO-14
 See DT/LCTO-14.txt

  Created by thomasperez on 4/17/24. | Swift 5. in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Swift_compiler_Lang/..ver
  For future customer updates/downloads fr AppStore, check their OS version vs my deployment target:

 DEVELOPED BY THOMAS EPHRAIM PEREZ APRIL 2024
 Other Ap = pass to sim
 Record_Type = ProductComment
 Can't use exclamation points on comments

*/

                                                                // IMAGES BRANCH
import Foundation
import CloudKit
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var userInput2: String = ""
    @Published var userInput3: String = ""
    @Published var userInput4: String = ""
    @Published var searchResults: [String] = []
    @Published var searchMessage: String = ""
    @Published var averageRating: Double = 0.0
    @Published var beforeImage: UIImage? = nil
    @Published var afterImage: UIImage? = nil

    private var database: CKDatabase {
        return CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-14").publicCloudDatabase
    }

    func postComment(productName: String, comment: String, rating: String) {
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = productName
        record["comment"] = comment
        record["Stars"] = Int(rating) ?? 0

        if let beforeImage = beforeImage, let afterImage = afterImage {
            let beforeImageAsset = CKAsset(fileURL: saveImageToTemporaryURL(image: beforeImage))
            let afterImageAsset = CKAsset(fileURL: saveImageToTemporaryURL(image: afterImage))
            record["beforeImage"] = beforeImageAsset
            record["afterImage"] = afterImageAsset
        }
        
        database.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleError(error)
                } else {
                    print("Product, Comment, and # Stars posted OK!")
                    self?.userInput = ""
                    self?.userInput2 = ""
                    self?.userInput4 = ""
                    self?.beforeImage = nil
                    self?.afterImage = nil
                }
            }
        }
    }
    
    func fetchProductNames(searchTerm: String) {
        guard !searchTerm.isEmpty else {
            self.searchResults = []
            self.searchMessage = "Please enter a search term."
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.searchMessage = ""
            }
            return
        }

        let predicate = NSPredicate(value: true) // Fetch all records
        let query = CKQuery(recordType: "ProductComment", predicate: predicate)
        print("Performing query with search term: \(searchTerm)")

        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                    self?.searchResults = []
                } else {
                    guard let records = records else {
                        print("No records fetched.")
                        self?.searchResults = []
                        return
                    }
                    print("Records fetched: \(records.count)")
                    
                    let comments = records.compactMap { record -> String? in
                        if let productName = record["productName"] as? String,
                           let comment = record["comment"] as? String,
                           productName.lowercased().hasPrefix(searchTerm.lowercased()) {
                            print("Comment found: \(comment)")
                            return comment
                        }
                        return nil
                    }
                    
                    print("Comments found: \(comments)")
                    self?.searchResults = comments
                    print("Search complete. Found: \(self?.searchResults ?? [])")
                    
                    if self?.searchResults.isEmpty == true {
                        self?.searchMessage = "No results found"
                    } else {
                        self?.searchMessage = ""
                    }
                }
            }
        }
    }

    func calculateAverageRating(for productName: String) {
        let predicate = NSPredicate(format: "productName == %@", productName)
        let query = CKQuery(recordType: "ProductComment", predicate: predicate)

        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.searchMessage = "Failed to fetch stars: \(error.localizedDescription)"
                    self?.averageRating = 0
                } else {
                    let stars = records?.compactMap { $0["Stars"] as? Int } ?? []
                    if !stars.isEmpty {
                        let total = stars.reduce(0, +)
                        let average = Double(total) / Double(stars.count)
                        self?.averageRating = average
                    } else {
                        self?.averageRating = 0
                    }
                }
            }
        }
    }

    func pickImage(isBeforeImage: Bool) {
        let selectedImage = UIImage(systemName: "photo") // Placeholder for actual image selection logic.
        
        if isBeforeImage {
            beforeImage = selectedImage
        } else {
            afterImage = selectedImage
        }
    }

    private func saveImageToTemporaryURL(image: UIImage) -> URL {
        let data = image.jpegData(compressionQuality: 0.8)!
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        try? data.write(to: url)
        return url
    }

    private func handleError(_ error: Error) {
        guard let ckError = error as? CKError else {
            print("Error: \(error.localizedDescription)")
            return
        }

        switch ckError.code {
        case .networkUnavailable, .networkFailure:
            print("\nNetwork error: Please check your internet connection.")
        default:
            print("\nUnhandled error: \(ckError.localizedDescription)")
        }
    }
}





/**
 Format specifiers:
 %d - int Value
 %f - float value
 %ld - long value
 %@ - string value and for many more.
 */
