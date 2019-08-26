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
    let hypeText: String
    let timestamp: Date
    
    init(hypeText: String, timestamp: Date = Date()) {
        self.hypeText = hypeText
        self.timestamp = timestamp
    }
}

extension CKRecord {
    // Create a CKRecord from a Hype object.
    convenience init(hype: Hype) {
        self.init(recordType: Constants.recordTypeKey)
        self.setValue(hype.hypeText, forKey: Constants.recordTextKey)
        self.setValue(hype.timestamp, forKey: Constants.recordTimestampKey)
    }
}

extension Hype {
    // Create a Hype object from a CKRecord.
    convenience init?(ckRecord: CKRecord) {
        guard let hypeText = ckRecord[Constants.recordTextKey] as? String,
            let timestamp = ckRecord[Constants.recordTimestampKey] as? Date else { return nil }
        self.init(hypeText: hypeText, timestamp: timestamp)
    }
}
