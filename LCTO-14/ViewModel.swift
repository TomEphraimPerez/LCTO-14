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
    @Published var hasSearched: Bool = false
    
    private var database: CKDatabase {
        return CKContainer(identifier: "iCloud.com.tomEphraimPerez.LCTO-142").publicCloudDatabase
    }

    func postComment(productName: String, comment: String, rating: String) {
        let sanitizedProductName = productName.replacingOccurrences(
            of: "[\\u0027\\u2019\\.\\-]",
            with: "",
            options: .regularExpression,
            range: nil
        )
        
        let record = CKRecord(recordType: "ProductComment")
        record["productName"] = sanitizedProductName
        record["comment"] = comment
        record["Stars"] = Int(rating) ?? 0
        
        database.save(record) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleError(error)
                } else {
                    print("Product, Comment, and # Stars posted successfully!")
                    self?.userInput = ""
                    self?.userInput2 = ""
                    self?.userInput4 = ""
                }
            }
        }
    }

    func fetchProductNames(searchTerm: String) {
        guard !searchTerm.isEmpty else {
            self.searchResults = []
            self.searchMessage = ""  // Make sure the message is cleared when input is empty
            self.hasSearched = false
            return
        }

        self.hasSearched = true
        let normalizedSearchTerm = searchTerm.replacingOccurrences(of: "'", with: "")
        var allComments: [String] = []

        fetchAllRecords(with: nil, searchTerm: normalizedSearchTerm, allComments: &allComments)
    }




    private func fetchAllRecords(with cursor: CKQueryOperation.Cursor?, searchTerm: String, allComments: inout [String]) {
        var mutableComments = allComments

        let operation: CKQueryOperation

        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: "ProductComment", predicate: predicate)
            operation = CKQueryOperation(query: query)
        }

        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                if let productName = record["productName"] as? String,
                   let comment = record["comment"] as? String {
                    let normalizedProductName = productName.replacingOccurrences(of: "'", with: "")
                    if normalizedProductName.range(of: searchTerm, options: .caseInsensitive) != nil {
                        mutableComments.append(comment)
                    }
                }
            case .failure(let error):
                print("Error fetching record with ID \(recordID): \(error)")
            }
        }

        operation.queryResultBlock = { [weak self] result in
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                    print("Fetching next page of records...")
                    self?.fetchAllRecords(with: cursor, searchTerm: searchTerm, allComments: &mutableComments)
                } else {
                    DispatchQueue.main.async {
                        self?.searchResults = mutableComments
                        self?.searchMessage = mutableComments.isEmpty ? "No results found" : ""
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Search error: \(error.localizedDescription)")
                    self?.searchResults = []
                    self?.searchMessage = "Error fetching results. Please try again."
                }
            }
        }

        database.add(operation)
    }

    func calculateAverageRating(for productName: String) {
        guard !productName.isEmpty else {
            self.averageRating = 0
            return
        }

        let normalizedProductName = productName.replacingOccurrences(of: "'", with: "")
        var allStars: [Int] = []

        fetchAllRatings(with: nil, productName: normalizedProductName, allStars: &allStars)
    }

    private func fetchAllRatings(with cursor: CKQueryOperation.Cursor?, productName: String, allStars: inout [Int]) {
        var mutableStars = allStars

        let operation: CKQueryOperation

        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: "ProductComment", predicate: predicate)
            operation = CKQueryOperation(query: query)
        }

        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                if let name = record["productName"] as? String {
                    let normalizedRecordProductName = name.replacingOccurrences(of: "'", with: "")
                    if normalizedRecordProductName.range(of: productName, options: .caseInsensitive) != nil {
                        if let stars = record["Stars"] as? Int {
                            mutableStars.append(stars)
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch record \(recordID): \(error)")
            }
        }

        operation.queryResultBlock = { [weak self] result in
            switch result {
            case .success(let cursor):
                if let cursor = cursor {
                    self?.fetchAllRatings(with: cursor, productName: productName, allStars: &mutableStars)
                } else {
                    DispatchQueue.main.async {
                        if !mutableStars.isEmpty {
                            let total = mutableStars.reduce(0, +)
                            let average = Double(total) / Double(mutableStars.count)
                            self?.averageRating = average
                        } else {
                            self?.averageRating = 0
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.searchMessage = "Failed to fetch stars: \(error.localizedDescription)"
                    self?.averageRating = 0
                }
            }
        }

        database.add(operation)
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
            print("Unhandled error: \(ckError.localizedDescription)")
        }
    }
}
