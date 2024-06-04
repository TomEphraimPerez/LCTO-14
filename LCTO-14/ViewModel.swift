//
// ViewModel.swift
// LCTO-14
// See DT/LCTO-14.txt

// Created by thomasperez on 5/13/24.
// VM is UI PRESENTATION LOGIC AND STATE
// "MODEL" IS BUSINESS_LOGIC and DATA_MODEL
// See LCTO-14.txt

import Foundation                                                               //O cgpt
import CloudKit
import os.log                                                                   // StkOvr or Apple GitHub

final class ViewModel: ObservableObject {   // Typically, ObsObj used w @Published to create observable objs. Exposes VM props for V UI.
    @Published var userInput: String = ""                                       // This will store the user's input from the text field
    @Published var userInput2: String = ""
    @Published var userInput3: String = ""                                      // For text-wise Search
    @Published var searchResults: [String] = []                                 // Array to store search results
    @Published var searchMessage: String = ""                                   // For UI, a Guard block in VM when Search_ing [nil]
    @Published var averageRating: Double = 0.0 
    
    private var database: CKDatabase {
        return CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-14").publicCloudDatabase  //Set to Pub if examining Git/inSights
    }

    
                                                // POST        SEARCH FOR ->  5-24-24)1600  , = search obj wh has a comment
                                                // POST        SEARCH FOR ->  5-24-24)1600  , = search obj wh has a comment
    
    func postComment(productName: String, comment: String) {
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = productName
        record["comment"] = comment
        
        database.save(record) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.handleError(error)
                } else {
                    print("\nProduct and Comment posted successfully!")         // Prints to console
                    self.userInput = ""                                         // Clear the inputs after posting
                    self.userInput2 = ""
                }
            }
        }
    }
    
                                                // SEARCH   // SEARCH   SEARCH FOR ->  5-24-24)1600  , = search obj wh has a comment
                                                // SEARCH   // SEARCH   SEARCH FOR ->  5-26-24)1930  , = search obj wh has a comment
    
    func fetchProductNames(searchTerm: String) {
                                                // Check if the search term is empty and return immediately if true - Guard() nx line
        guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchResults = []             // Optionally clear previous results or leave as is
            print("No search term provided.")                                   // Only console out
            self.searchMessage = "Please enter a search term."                  // Now console + + UI for UX
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {               // C L E A R the message after 2 S E C. CGPT 5-31-24
                self.searchMessage = ""
            } // DispatchQueue.main.asyncAfter
            
            return
        }
        
        
        let predicate = NSPredicate(format: "productName BEGINSWITH %@", searchTerm)    // productName in PREDICATE
        let query = CKQuery(recordType: "ProductComment", predicate: predicate)         // productName in PREDICATE
        
        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("\nSearch error: \(error.localizedDescription)")
                    self?.searchResults = []                                        // Clear results on error
                } else {
                    let comment = records?.compactMap { $0["comment"] as? String }  // Chg 'productName' to 'comment'
                    //self?.searchResults = Array(Set(products))
                    print("\nSearch complete Found: \(comment ?? [])" )               // Chg 'productName' to 'comment'
                          self?.searchResults = Array(Set(comment ?? []) ) //Update srch res & rmv dupes. Chg 'productName' to 'comment'
                } // else
                    
            } // Dispatch
        } // DB.perform
    } // func
    
    
    
    
    
    
    
    
    func calculateAverageRating(for productName: String) {
        let ratings: [Int] = [0, 1, 2, 3, 4, 1]  // Example: replace with fetch from CloudKit
        let total = ratings.reduce(0, +)
        let count = ratings.count
        
        DispatchQueue.main.async {
            self.averageRating = count > 0 ? Double(total) / Double(count) : 0.0
            print("\nCalculated average rating: \(self.averageRating)")
        }
    }

    
    
    
    
    
    
    
    
    
                                                // ERROR HANDING                //  5-24-24) ~ 1400
                                                // ERROR HANDING                //  5-24-24) ~ 1400
                                    // search FOR ->  5-24-24)1600  , = search obj wh has a comment
    
                                                                                // Generic error handler for CloudKit operations
    private func handleError(_ error: Error) {
        guard let ckError = error as? CKError else {                            // Guard forces early exit if conditions not met.
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
} // final class                                // SEARCH FOR ->   5-24-24)1600  , = search obj wh has a comment

// //
