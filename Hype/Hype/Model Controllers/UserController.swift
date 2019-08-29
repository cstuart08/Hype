//
//  UserController.swift
//  Hype
//
//  Created by Apps on 8/29/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    var currentUser: User?
    let privateDB = CKContainer.default().privateCloudDatabase
    // MARK: - CRUD
        // Create
    func createUser(firstName: String, lastName:String, email: String, completion: @escaping (Bool) -> Void) {
        // Step 2 -- Do this second because the only way to get a Reference is to access the CKRecord first.
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            // Step 3
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            // Step 4
            guard let recordID = recordID else { completion(false); return }
            // Step 5
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            // Step 1 -- Do this first so we know what we need for a new User.
            let newUser = User(firstName: firstName, lastName: lastName, email: email, appleUserRef: reference)
            // Step 6
            let userRecord = CKRecord(user: newUser)
            // Step 7
            self.privateDB.save(userRecord, completionHandler: { (record, error) in
                // Step 8
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                // Step 9
                guard let record = record else { completion(false); return }
                // Step 10
                let savedUser = User(record: record)
                self.currentUser = savedUser
                completion(true)
            })
        }
    }
    
        // Fetching
    func fetchAUser(completion: @escaping (Bool) -> Void) {
        
        // Step 3
        let predicate = NSPredicate(value: true)
        // Step 2
        let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
        // Step 1
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            // Step 4
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            // Step 5
            if let record = records?.first {
                let foundUser = User(record: record)
                self.currentUser = foundUser
                completion(true)
            }
        }
    }
    
}
