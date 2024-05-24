//
//  ViewModel.swift
//  LCTO-14
// See DT/LCTO-14.txt

//  Created by thomasperez on 5/13/24.
// VM is UI PRESENTATION LOGIC AND STATE
// "MODEL" IS BUSINESS_LOGIC and DATA_MODEL
// See LCTO-14.txt

import Foundation                                                               //O cgpt
import CloudKit
import os.log

final class ViewModel: ObservableObject {   // Typically, ObsObj used w @Published to create observable objs. Exposes VM props for V UI.
    @Published var userInput: String = ""                                       // This will store the user's input from the text field
    @Published var userInput2: String = ""
    @Published var userInput3: String = ""                                      // For text-wise Search
    
    private var database: CKDatabase {
        return CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-14").publicCloudDatabase  //Set to Pub if examining Git/inSights
    }

    
    
    
                                                        // POST
    func postComment(productName: String, comment: String) {
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = productName
        record["comment"] = comment
        
        database.save(record) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.handleError(error)
                } else {
                    print("Product and Comment posted successfully!")           // Prints to console
                    self.userInput = ""                                         // Clear the inputs after posting
                    self.userInput2 = ""
                }
            }
        }
    }
 
    
                                                        // SEARCH       Try/ 5-23-24)1925 searching
    
    // Function to fetch product names matching a given search term
    /*
        func fetchProductNames(searchTerm: String, completion: @escaping ([String]) -> Void) {
            let predicate = NSPredicate(format: "productName BEGINSWITH %@", searchTerm)
            let query = CKQuery(recordType: "ProductComment", predicate: predicate)

            database.perform(query, inZoneWith: nil) { [weak self] records, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.handleError(error)
                        completion([])
                    } else {
                        let productNames = records?.compactMap { $0["productName"] as? String }
                        // Filter for unique names if necessary
                        let uniqueNames = Set(productNames ?? [])
                        completion(Array(uniqueNames))
                        self?.userInput3 = "" // Optionally clear search field
                    }
                }
            }
        }
    */
    // CGPT >>> Function to fetch product names matching a given search term. ||         (( still try/   5-23-24)1925    searching ))
       func fetchProductNames(searchTerm: String, completion: @escaping ([String]) -> Void) {   // CGPT 5-24-24)1530
           let predicate = NSPredicate(format: "productName BEGINSWITH %@", searchTerm)
           let query = CKQuery(recordType: "ProductComment", predicate: predicate)

           database.perform(query, inZoneWith: nil) { [weak self] records, error in
               DispatchQueue.main.async {
                   if let error = error {
                       self?.handleError(error)
                       completion([])
                   } else {
                       let productNames = records?.compactMap { $0["productName"] as? String }
                       // Filter for unique names if necessary
                       let uniqueNames = Set(productNames ?? [])
                       completion(Array(uniqueNames))
                       self?.userInput3 = "" // Optionally clear search field
                       print("\nSearch complete, found \(uniqueNames.count) comments")
                   }
               }
           }
       }

    
    
                                                        // ERROR HANDING
    /*
    private func handleError(_ error: Error) {
        guard let ckError = error as? CKError else {                            // Guear d forces early exit if conditions not met.
            print("Error: \(error.localizedDescription)")
            return
        }

        switch ckError.code {
        case .networkUnavailable, .networkFailure:
            print("Network error: Please check your internet connection.")
        default:
            print("Error: \(ckError.localizedDescription)")
        }
    }
}
*/
// CGPT 5-24-24)1536        >>>
    // Generic error handler for CloudKit operations
    private func handleError(_ error: Error) {
        guard let ckError = error as? CKError else {
            print("Error: \(error.localizedDescription)")
            return
        }

        switch ckError.code {
        case .networkUnavailable, .networkFailure:
            print("Network error: Please check your internet connection.")
        default:
            print("Unhandled error: \(ckError.localizedDescription)")
        }
    }
}

