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

import Foundation
import CloudKit

import UIKit                                                                                            //

final class ViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var userInput2: String = ""
    @Published var userInput3: String = ""
    @Published var userInput4: String = ""
    @Published var searchResults: [String] = []
    @Published var searchMessage: String = ""
    @Published var averageRating: Double = 0.0
    

    private var database: CKDatabase {
        return CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-14").publicCloudDatabase
    }
    
    
                                                            // POST
    
    func postComment(productName: String, comment: String, rating: String) {
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = productName
        record["comment"] = comment
        record["Stars"] = Int(rating) ?? 0                  // Note training '0' after '??' OW er-> 'amniguous w/o more content'
        
        database.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleError(error)
                } else {
                    print("Product, Comment, and # Stars posted OK!")
                    self?.userInput = ""
                    self?.userInput2 = ""
                    self?.userInput4 = ""
                }
            }
        }
    }

    
                                                            // SEARCH
    func fetchProductNames(searchTerm: String) {
        guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchResults = []
            self.searchMessage = "Please enter a search term."
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.searchMessage = ""
            }
            return
        }

        let predicate = NSPredicate(format: "productName BEGINSWITH %@", searchTerm)    // O. OK, just case-sensitive. %@ see blw.
        // ||=  =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =  =||
        // let predicate = NSPredicate(format: "productName lowercased(CONTAINS  %@")                   // No
        //let predicate = NSPredicate(format: "productName CONTAINS[c] (IN, %@", searchTerm)            // Apple bug. ...
        //let predicate = NSPredicate(format: "productName CONTAINS[c] (IN, ANY) %@", searchTerm)       // OSX/XC BUG W/WO [C]
        // let predicate = NSPredicate(format: "productName BEGINSWITH %@".lowercased(), searchTerm)    // No
        // let predicate = NSPredicate(format: "productName contains(_:) %@", searchTerm)               //  Fails.
        // let trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        // let predicate = NSPredicate(format: "productName CONTAINS[c] %@", trimmedSearchTerm)
        // SELF in the format string means each individual element in the array.
        //   let containPredicate = NSPredicate(format: "SELF CONTAINS %@", "Kim")
        /* For Xc version 16. >>>
           @Query(filter: #Predicate<Movie> { movie in
           movie.name.localizedStandardContains("JAWS")
           }) var movies: [Movie]
         */
        //let predicate = NSPredicate(format: "productName CONTAINS  %@", searchTerm) // Rtns NOTHING w "CONTAINS" sans [c]. OW CRASH.
        //let predicate = NSPredicate(format: "productName.localizedStandardContains %@", searchTerm)   // ??? >>> NO.
        
        let query = CKQuery(recordType: "ProductComment", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                    self?.searchResults = []
                } else {
                    let comments = records?.compactMap { $0["comment"] as? String } ?? []
                    self?.searchResults = Array(Set(comments))
                    print("Search complete. Found: \(self?.searchResults ?? [])")
                }
            }
        }
    }

    
    
                                                            // CALCULATE RATINGS FOR STARS
    
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

    
                                                            // ERROR HANDLING
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
