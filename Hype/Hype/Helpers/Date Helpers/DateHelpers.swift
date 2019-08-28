//
//  DateHelpers.swift
//  Hype
//
//  Created by Apps on 8/27/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    
    private init() {}
    
    let dateFormatter = DateFormatter()
    
    func mediumStringForDateAndTime(date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
