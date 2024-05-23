//
//  ViewModel.swift
//  LCTO-14
//
//  Created by thomasperez on 5/13/24.
//

import Foundation                                               //o
import CloudKit
import os.log

final class ViewModel: ObservableObject {
    @Published var userInput: String = ""  // This will store the user's input from the text field

    private var database: CKDatabase {
        return CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-14").publicCloudDatabase
    }

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
                    self.userInput = ""  // Clear the input after posting
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
        
        database.perform(query, inZoneWith: nil) { [weak self] records, error in
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
        guard let ckError = error as? CKError else {
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


