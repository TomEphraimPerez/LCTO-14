//
//  ViewModel.swift
//  LCTO-14
//
//  Created by thomasperez on 5/13/24.
//

import Foundation                                               //o

import OSLog
import CloudKit


//  -   -   -   -   -   -   -   -   -
//
//  ViewModel.swift
//  (cloudkit-samples) queries
//
//  -   -   -   -
import os.log
import CloudKit

//  -   -   -   -
//                                                              REPORT !

    
func postComment(productName: String, comment: String) {
    let record = CKRecord(recordType: "ProductComment")
    record["productName"] = productName
    record["comment"] = comment
    
    let database = CKContainer.default().publicCloudDatabase
    database.save(record) { record, error in
        if let error = error {
            print("An error occurred: \(error.localizedDescription)")
        } else {
            print("Comment posted successfully!")
        }
    }
}


//                                                              SEARCH O--

func fetchComments(for productName: String, completion: @escaping ([String]) -> Void) {
    let predicate = NSPredicate(format: "productName == %@", productName)
    let query = CKQuery(recordType: "ProductComment", predicate: predicate)
    
    let database = CKContainer.default().publicCloudDatabase
    database.perform(query, inZoneWith: nil) { records, error in                //o deprecated
                        // use; fetch(withQuery:inZoneWith:desiredKeys:resultsLimit:completionHandler:)
    
        if let error = error {
            print("Failed to fetch comments: \(error.localizedDescription)")
            completion([])
        } else {
            let comments = records?.compactMap { $0["comment"] as? String } ?? []
            completion(comments)
        } //else
    } //db
} //func

//  -   -   -   -   -   -   -   -   -

