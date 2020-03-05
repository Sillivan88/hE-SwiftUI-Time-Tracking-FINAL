//
//  TimeTrackingGroup+CoreDataClass.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 04.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import CoreData

public class TSTimeTrackingGroup: NSManagedObject, Identifiable {
    
    // MARK: - Properties
    
    static let entityName = "TSTimeTrackingGroup"
    
    static let noGroupIndex = -1
    
    var currentlyActiveTimeTracking: TSTimeTracking? {
        if let timeTrackings = timeTrackings {
            for timeTracking in timeTrackings {
                if (timeTracking as! TSTimeTracking).hasActiveTimeInterval {
                    return (timeTracking as! TSTimeTracking)
                }
            }
        }
        return nil
    }
    
    var hasActiveTimeTracking: Bool {
        if currentlyActiveTimeTracking != nil {
            return true
        }
        return false
    }
    
    var sortedTimeTrackings: [TSTimeTracking] {
        if let timeTrackings = timeTrackings {
            let timeTrackingsSortedByTitle = timeTrackings.sorted { ($0 as! TSTimeTracking).title! < ($1 as! TSTimeTracking).title! } as! [TSTimeTracking]
            return timeTrackingsSortedByTitle.sorted { (firstTimeTracking, secondTimeTracking) -> Bool in
                if let firstTimeTrackingStartTime = firstTimeTracking.latestTimeInterval?.startTime, let secondTimeTrackingStartTime = secondTimeTracking.latestTimeInterval?.startTime {
                    return firstTimeTrackingStartTime > secondTimeTrackingStartTime
                } else if firstTimeTracking.latestTimeInterval?.startTime != nil {
                    return true
                }
                return false
            }
        }
        return [TSTimeTracking]()
    }
    
    var finishedTimeTrackings: [TSTimeTracking] {
        var finishedTimeTrackings = sortedTimeTrackings
        finishedTimeTrackings.removeAll { (timeTracking) -> Bool in
            timeTracking.isFinished == false
        }
        return finishedTimeTrackings
    }
    
    var hasFinishedTimeTrackings: Bool {
        finishedTimeTrackings.count > 0
    }
    
    var sortedTimeTrackingsWithoutActiveTimeTracking: [TSTimeTracking] {
        var sortedTimeTrackingsWithoutActiveTimeTracking = sortedTimeTrackings
        sortedTimeTrackingsWithoutActiveTimeTracking.removeAll { (timeTracking) -> Bool in
            timeTracking.hasActiveTimeInterval || timeTracking.isFinished
        }
        return sortedTimeTrackingsWithoutActiveTimeTracking
    }
    
    var hasTimeTrackingsWithoutActiveTimeTracking: Bool {
        sortedTimeTrackingsWithoutActiveTimeTracking.count > 0
    }
    
}
