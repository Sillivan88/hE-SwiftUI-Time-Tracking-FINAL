//
//  TimeIntervalManager.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 05.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import Foundation

class TimeIntervalManager {
    
    // MARK: - Properties
    
    static let shared = TimeIntervalManager()
    
    // MARK: - Methods
    
    func createTimeInterval(forTimeTracking timeTracking: TSTimeTracking, startTime: Date, endTime: Date? = nil) -> TSTimeInterval {
        let timeInterval = TSTimeInterval(context: CoreDataManager.shared.managedObjectContext)
        timeInterval.id = UUID()
        timeInterval.timeTracking = timeTracking
        timeInterval.startTime = startTime
        timeInterval.endTime = endTime
        CoreDataManager.shared.saveContext()
        return timeInterval
    }
    
    func deleteTimeInterval(_ timeInterval: TSTimeInterval) {
        CoreDataManager.shared.managedObjectContext.delete(timeInterval)
        CoreDataManager.shared.saveContext()
    }
    
}
