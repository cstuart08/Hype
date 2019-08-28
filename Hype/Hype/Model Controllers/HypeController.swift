//
//  HypeController.swift
//  Hype
//
//  Created by Apps on 8/26/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    
    // MARK: - Singleton
    static let sharedInstance = HypeController()
    
    // MARK: - S.O.T
    var hypes: [Hype] = []
    let publicDB = CKContainer(identifier: "iCloud.com.CameronStuart.Hype").publicCloudDatabase
    
    // MARK: - CRUD
    // Create
    
    func saveHype(text: String, completion: @escaping (Bool) -> Void) {
        
        let hype = Hype(hypeText: text)
        let hypeRecord = CKRecord(hype: hype)
        
        self.hypes.insert(hype, at: 0)
        
        publicDB.save(hypeRecord) { (_, error) in
            if let error = error {
                print("There was an error saving the Hype: \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        completion(true)
    }
    // Read
    
    func fetchHypes(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Constants.recordTypeKey, predicate: predicate)
        
        let sortDescriptors = NSSortDescriptor(key: Constants.recordTimestampKey, ascending: false)
        query.sortDescriptors = [sortDescriptors]
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fething our Hypes: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            let hypes = records.compactMap({Hype(ckRecord: $0)})
            self.hypes = hypes
            completion(true)
        }

    }
    // Update
    
    func updateHype(hype: Hype, newText: String, completion: @escaping (Bool) -> Void) {
        hype.hypeText = newText
        hype.timestamp = Date()
        
        let modificationOp = CKModifyRecordsOperation(recordsToSave: [CKRecord(hype: hype)], recordIDsToDelete: nil)
        modificationOp.savePolicy = .changedKeys
        modificationOp.queuePriority = .veryHigh
        modificationOp.qualityOfService = .userInteractive
        modificationOp.modifyRecordsCompletionBlock = { (_, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
        self.publicDB.add(modificationOp)
    }
    
        // Subrscription
    func subscribeToHypes(completion: @escaping (Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: Constants.recordTypeKey, predicate: predicate, options: [.firesOnRecordCreation, .firesOnRecordUpdate])
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "HYPE!"
        notificationInfo.alertBody = "There's a new Hype!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("There was an error with the subscription. \(error.localizedDescription)")
                return
            }
        }
    }
    // Delete
    
    func remove(hype: Hype, completion: @escaping (Bool) -> Void) {
        
        guard let hypeRecordID = hype.ckRecordID else { return }
        
        guard let index = self.hypes.firstIndex(of: hype) else { return }
        self.hypes.remove(at: index)
        
        publicDB.delete(withRecordID: hypeRecordID) { (recordID, error) in
            if let error = error {
                print("Error removing Hype. Error: \(#function)\(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
