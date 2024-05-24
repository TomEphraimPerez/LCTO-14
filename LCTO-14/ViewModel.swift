//
//  ViewModel.swift
//  LCTO-14
//
//  Created by thomasperez on 5/13/24.
// VM is UI PRESENTATION LOGIC AND STATE
// "MODEL" IS BUSINESS_LOGIC and DATA_MODEL
// See LCTO-14.txt

import Foundation                                               //o cgpt
import CloudKit
import os.log

final class ViewModel: ObservableObject {   // Typically, ObsObj used w @Published to create observable objs. Exposes VM props for V UI.
    @Published var userInput: String = ""                       // This will store the user's input from the text field
    @Published var userInput2: String = ""
    
    private var database: CKDatabase {
        return CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-14").publicCloudDatabase
    }

    /*                                                          // O but from 5-23-24)1834
    func postComment(productName: String, comment: String) {
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = productName
        record["comment"] = comment
        
        database.save(record) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.handleError(error)
                } else {
                    print("Comment posted successfully!")
                    self.userInput = ""                         // Clear the input after posting
                }
            }
        }
    }
    */
    func postComment(productName: String, comment: String) {
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = productName
        record["comment"] = comment
        
        database.save(record) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.handleError(error)
                } else {
                    print("Product and Comment posted successfully!")
                    self.userInput = ""                         // Clear the input after posting
                    self.userInput2 = ""
                }
            }
        }
    }
    /*
    private func handleError(_ error: Error) {
        // Error handling code here
        print("An error occurred: \(error.localizedDescription)")
    }
    */
    
    
    
    func fetchComments(for productName: String, completion: @escaping ([String]) -> Void) {
        let predicate = NSPredicate(format: "productName == %@", productName)
        let query = CKQuery(recordType: "ProductComment", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { [weak self] records, error in // See notes (LCTO-14). 'weak' kywd is for mem leaks
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleError(error)
                    completion([])
                } else {
                    let comments = records?.compactMap { $0["comment"] as? String } ?? []
                    completion(comments)
                }
            }
        }
    }
    
    
    private func handleError(_ error: Error) {
        guard let ckError = error as? CKError else {                // Guear d forces early exit if conditions not met.
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


