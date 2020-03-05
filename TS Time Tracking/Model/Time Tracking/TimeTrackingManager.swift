//
//  TimeTrackingManager.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 04.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import CoreData

class TimeTrackingManager: ObservableObject {
    
    // MARK: - Properties
    
    static let shared = TimeTrackingManager()
    
    var selectedTimeTracking: TSTimeTracking?
    
    var runningTimeTracking: TSTimeTracking? {
        for timeTracking in timeTrackings {
            if timeTracking.hasActiveTimeInterval {
                return timeTracking
            }
        }
        return nil
    }
    
    var runningTimeTrackingWithoutGroup: TSTimeTracking? {
        if let timeTracking = runningTimeTracking, timeTracking.group == nil {
            return timeTracking
        }
        return nil
    }
    
    var runningTimeTrackingAvailable: Bool {
        runningTimeTracking != nil
    }
    
    var runningTimeTrackingWithoutGroupAvailable: Bool {
        runningTimeTrackingWithoutGroup != nil
    }
    
    var areTimeTrackingsAvailable: Bool {
        timeTrackings.count > 0
    }
    
    var areUnfinishedTimeTrackingsAvailable: Bool {
        unfinishedTimeTrackings.count > 0
    }
    
    var areTimeTrackingsWithGroupAvailable: Bool {
        timeTrackingsWithGroup.count > 0
    }
    
    var areTimeTrackingsWithoutGroupAvailable: Bool {
        timeTrackingsWithoutGroup.count > 0
    }
    
    var areNotRunningTimeTrackingsWithoutGroupAvailable: Bool {
        notRunningTimeTrackingsWithoutGroup.count > 0
    }
    
    var areFinishedTimeTrackingsWithoutGroupAvailable: Bool {
        finishedTimeTrackingsWithoutGroup.count > 0
    }
    
    var timeTrackings: [TSTimeTracking] {
        if let timeTrackings = try? CoreDataManager.shared.managedObjectContext.fetch(timeTrackingsFetchRequest) {
            return timeTrackings
        }
        return [TSTimeTracking]()
    }
    
    var unfinishedTimeTrackings: [TSTimeTracking] {
        if let unfinishedTimeTrackings = try? CoreDataManager.shared.managedObjectContext.fetch(unfinishedTimeTrackingsFetchRequest) {
            return unfinishedTimeTrackings
        }
        return [TSTimeTracking]()
    }
    
    var timeTrackingsWithGroup: [TSTimeTracking] {
        if let timeTrackingsWithGroup = try? CoreDataManager.shared.managedObjectContext.fetch(timeTrackingsWithGroupFetchRequest) {
            return timeTrackingsWithGroup
        }
        return [TSTimeTracking]()
    }
    
    var timeTrackingsWithoutGroup: [TSTimeTracking] {
        if let timeTrackingsWithoutGroup = try? CoreDataManager.shared.managedObjectContext.fetch(timeTrackingsWithoutGroupFetchRequest) {
            return timeTrackingsWithoutGroup
        }
        return [TSTimeTracking]()
    }
    
    var notRunningTimeTrackingsWithoutGroup: [TSTimeTracking] {
        var notRunningTimeTrackingsWithoutGroup = [TSTimeTracking]()
        for timeTracking in timeTrackingsWithoutGroup {
            if !timeTracking.hasActiveTimeInterval && !timeTracking.isFinished {
                notRunningTimeTrackingsWithoutGroup.append(timeTracking)
            }
        }
        return notRunningTimeTrackingsWithoutGroup
    }
    
    var finishedTimeTrackingsWithoutGroup: [TSTimeTracking] {
        var finishedTimeTrackingsWithoutGroup = [TSTimeTracking]()
        for timeTracking in timeTrackingsWithoutGroup {
            if timeTracking.isFinished {
                finishedTimeTrackingsWithoutGroup.append(timeTracking)
            }
        }
        return finishedTimeTrackingsWithoutGroup
    }
    
    var timeTrackingsFetchRequest: NSFetchRequest<TSTimeTracking> {
        timeTrackingsFetchRequest(withPredicate: nil)
    }
    
    var unfinishedTimeTrackingsFetchRequest: NSFetchRequest<TSTimeTracking> {
        timeTrackingsFetchRequest(withPredicate: NSPredicate(format: "isFinished == false"))
    }
    
    var timeTrackingsWithGroupFetchRequest: NSFetchRequest<TSTimeTracking> {
        timeTrackingsFetchRequest(withPredicate: NSPredicate(format: "group != nil"))
    }
    
    var timeTrackingsWithoutGroupFetchRequest: NSFetchRequest<TSTimeTracking> {
        timeTrackingsFetchRequest(withPredicate: NSPredicate(format: "group == nil"))
    }
    
    // MARK: - Methods
    
    private func timeTrackingsFetchRequest(withPredicate predicate: NSPredicate?) -> NSFetchRequest<TSTimeTracking> {
        let timeTrackingsFetchRequest = NSFetchRequest<TSTimeTracking>(entityName: TSTimeTracking.entityName)
        timeTrackingsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        timeTrackingsFetchRequest.predicate = predicate
        return timeTrackingsFetchRequest
    }
    
    func createTimeTracking(withTitle title: String, group: TSTimeTrackingGroup? = nil) -> TSTimeTracking {
        let timeTracking = TSTimeTracking(context: CoreDataManager.shared.managedObjectContext)
        timeTracking.id = UUID()
        timeTracking.title = title
        timeTracking.group = group
        CoreDataManager.shared.saveContext()
        objectWillChange.send()
        TimeTrackingGroupManager.shared.objectWillChange.send()
        return timeTracking
    }
    
    func deleteTimeTracking(_ timeTracking: TSTimeTracking) {
        if let selectedTimeTracking = self.selectedTimeTracking, selectedTimeTracking == timeTracking {
            self.selectedTimeTracking = nil
        }
        CoreDataManager.shared.managedObjectContext.delete(timeTracking)
        CoreDataManager.shared.saveContext()
        objectWillChange.send()
        TimeTrackingGroupManager.shared.objectWillChange.send()
    }
    
    func stopAnyRunningTimeTracking() {
        let runningTimeTrackingsFetchRequest = NSFetchRequest<TSTimeInterval>(entityName: TSTimeInterval.entityName)
        runningTimeTrackingsFetchRequest.predicate = NSPredicate(format: "endTime == nil")
        let runningTimeTrackings = try? CoreDataManager.shared.managedObjectContext.fetch(runningTimeTrackingsFetchRequest)
        if runningTimeTrackings != nil {
            for timeTrackingTimeInterval in runningTimeTrackings! {
                timeTrackingTimeInterval.timeTracking?.endTimeTracking()
            }
        }
        CoreDataManager.shared.saveContext()
    }
    
    func deleteAllTimeTrackings() {
        for timeTracking in timeTrackings {
            deleteTimeTracking(timeTracking)
        }
    }
    
}
