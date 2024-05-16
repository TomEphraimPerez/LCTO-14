//
//  ViewModel.swift
//  LCTO-14
//
//  Created by thomasperez on 5/13/24.
//

import Foundation                                               //o

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

//@MainActor                                                        // Commented out 5-15-24)1433, OW Build fails and no Sim.
final class ViewModel: ObservableObject {
    
    
    func postComment(productName: String, comment: String) {
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = productName
        record["comment"] = comment
        
        let database = CKContainer.default().publicCloudDatabase    //xxxxxxxxxxxxxxxxxxxxxxxxxxx >>>
                        // >>> Thread 1: EXC_BREAKPOINT (code=1, subcode=0x184c69410) | Same error when selecting SEARCH button.
        database.save(record) { record, error in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
            } else {
                print("Comment posted successfully!")
            }
        }
    }
    
    
    //                                                          SEARCH O--
    
    func fetchComments(for productName: String, completion: @escaping ([String]) -> Void) {
        let predicate = NSPredicate(format: "productName == %@", productName)
        let query = CKQuery(recordType: "ProductComment", predicate: predicate)
        
        let database = CKContainer.default().publicCloudDatabase    //xxxxxxxxxxxxxxxxxxxxxxxxxxx | SAME error as li31 error msg.
        database.perform(query, inZoneWith: nil) { records, error in //o Deprecated error.
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
    
} // final class
//  -   -   -   -   -   -   -   -   -

