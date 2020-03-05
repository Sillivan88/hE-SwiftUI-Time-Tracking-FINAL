//
//  TimeTrackingTimeInterval+CoreDataClass.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 28.01.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import CoreData

public class TSTimeInterval: NSManagedObject, Identifiable {
    
    // MARK: - Properties
    
    static let entityName = "TSTimeInterval"
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    var duration: TimeInterval {
        if startTime != nil && endTime != nil {
            return endTime!.timeIntervalSince(startTime!)
        }
        if startTime != nil && endTime == nil {
            return Date().timeIntervalSince(startTime!)
        }
        return 0
    }
    
    var period: String {
        var period = ""
        if let startTime = startTime {
            period.append(formattedDate(startTime))
        }
        period.append(" - ")
        if let endTime = endTime {
            period.append(formattedDate(endTime))
        }
        return period
    }
    
    private func formattedDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
}
