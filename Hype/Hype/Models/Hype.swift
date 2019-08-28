//
//  Hype.swift
//  Hype
//
//  Created by Apps on 8/26/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let recordTypeKey = "Hype"
    static let recordTextKey = "Text"
    static let recordTimestampKey = "Timestamp"
}

class Hype {
    var hypeText: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID?
    
    init(hypeText: String, timestamp: Date = Date()) {
        self.hypeText = hypeText
        self.timestamp = timestamp
    }
}

extension CKRecord {
    // Create a CKRecord from a Hype object.
    convenience init(hype: Hype) {
        self.init(recordType: Constants.recordTypeKey, recordID: hype.ckRecordID ?? CKRecord.ID(recordName: UUID().uuidString))
        self.setValue(hype.hypeText, forKey: Constants.recordTextKey)
        self.setValue(hype.timestamp, forKey: Constants.recordTimestampKey)
        hype.ckRecordID = recordID
    }
}

extension Hype {
    // Create a Hype object from a CKRecord.
    convenience init?(ckRecord: CKRecord) {
        guard let hypeText = ckRecord[Constants.recordTextKey] as? String,
            let timestamp = ckRecord[Constants.recordTimestampKey] as? Date else { return nil }
        self.init(hypeText: hypeText, timestamp: timestamp)
        ckRecordID = ckRecord.recordID
    }
}

extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
        return lhs.hypeText == rhs.hypeText && lhs.timestamp == rhs.timestamp && lhs.ckRecordID == rhs.ckRecordID
    }
}
