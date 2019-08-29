//
//  User.swift
//  Hype
//
//  Created by Apps on 8/29/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import Foundation
import CloudKit

struct UserStrings {
    static let recordTypeKey = "User"
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let emailKey = "email"
    static let appleUserRefKey = "appleUserRef"
}

class User {
    
    var firstName: String
    var lastName: String
    var email: String
    var appleUserRef: CKRecord.Reference
    var ckRecordID: CKRecord.ID
    
    
    init(firstName: String, lastName: String, email: String, appleUserRef: CKRecord.Reference, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.appleUserRef = appleUserRef
        self.ckRecordID = ckRecordID
    }
    
    init?(record: CKRecord) {
        guard let firstName = record[UserStrings.firstNameKey] as? String,
            let lastName = record[UserStrings.lastNameKey] as? String,
            let email = record[UserStrings.emailKey] as? String,
            let appleUserRef = record[UserStrings.appleUserRefKey] as? CKRecord.Reference else { return nil }
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.appleUserRef = appleUserRef
        self.ckRecordID = record.recordID
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.ckRecordID)
        self.setValue(user.firstName, forKey: UserStrings.firstNameKey)
        self.setValue(user.lastName, forKey: UserStrings.lastNameKey)
        self.setValue(user.email, forKey: UserStrings.emailKey)
    }
}
