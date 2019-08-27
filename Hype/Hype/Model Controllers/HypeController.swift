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
        publicDB.save(hypeRecord) { (_, error) in
            if let error = error {
                print("There was an error saving the Hype: \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        hypes.append(hype)
        completion(true)
    }
    // Read
    
    func fetchHypes(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Constants.recordTypeKey, predicate: predicate)
        
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
    
        // Subrscription
    func subscribeToHypes() {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: Constants.recordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "HYPE!"
        notificationInfo.alertBody = "There's a new Hype!"
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("There was an error with the subscription. \(error.localizedDescription)")
                return
            }
            print("success")
        }
    }
    // Delete
}
