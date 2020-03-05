//
//  TimeTracking+CoreDataClass.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 28.01.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import CoreData

public class TSTimeTracking: NSManagedObject, Identifiable {
    
    // MARK: - Properties
    
    static let entityName = "TSTimeTracking"
    
    var formattedTitle: String {
        if title != nil {
            return title!
        }
        return ""
    }
    
    var sortedTimeIntervals: [TSTimeInterval] {
        if let timeIntervals = timeIntervals {
            return timeIntervals.sorted() { ($0 as! TSTimeInterval).startTime! > ($1 as! TSTimeInterval).startTime!} as! [TSTimeInterval]
        }
        return [TSTimeInterval]()
    }
    
    var activeTimeInterval: TSTimeInterval? {
        if timeIntervals != nil {
            for timeTrackingTimeInterval in timeIntervals! {
                if let timeInterval = timeTrackingTimeInterval as? TSTimeInterval {
                    if timeInterval.endTime == nil {
                        return timeInterval
                    }
                }
            }
        }
        return nil
    }
    
    var latestTimeInterval: TSTimeInterval? {
        if sortedTimeIntervals.count > 0 {
            return sortedTimeIntervals.first!
        }
        return nil
    }
    
    var hasActiveTimeInterval: Bool {
        if activeTimeInterval != nil {
            return true
        }
        return false
    }
    
    var duration: TimeInterval {
        var duration: TimeInterval = 0
        if timeIntervals != nil {
            for timeTrackingTimeInterval in timeIntervals! {
                if let timeInterval = timeTrackingTimeInterval as? TSTimeInterval {
                    duration += timeInterval.duration
                }
            }
        }
        return duration
    }
    
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? ""
    }
    
    // MARK: - Methods
    
    func startTimeTracking() {
        TimeTrackingManager.shared.stopAnyRunningTimeTracking()
        _ = TimeIntervalManager.shared.createTimeInterval(forTimeTracking: self, startTime: Date())
        updateObject()
    }
    
    func endTimeTracking() {
        if activeTimeInterval != nil {
            activeTimeInterval?.endTime = Date()
            CoreDataManager.shared.saveContext()
            updateObject()
        }
    }
    
    func finishTask() {
        endTimeTracking()
        isFinished = true
        updateObject()
        TimeTrackingManager.shared.objectWillChange.send()
    }
    
    func updateObject(withGroup shouldUpdateGroup: Bool = true) {
        objectWillChange.send()
        TimeTrackingManager.shared.objectWillChange.send()
        if shouldUpdateGroup, let group = group {
            group.objectWillChange.send()
        }
    }
    
}
