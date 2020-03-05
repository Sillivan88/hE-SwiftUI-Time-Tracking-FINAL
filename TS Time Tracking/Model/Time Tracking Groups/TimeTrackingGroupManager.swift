//
//  TimeTrackingGroupManager.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 04.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import CoreData

class TimeTrackingGroupManager: ObservableObject {
    
    // MARK: - Properties
    
    static let shared = TimeTrackingGroupManager()
    
    var areTimeTrackingGroupsAvailable: Bool {
        timeTrackingGroups.count > 0
    }
    
    var isDefaultGroupAvailable: Bool {
        TimeTrackingManager.shared.areTimeTrackingsWithoutGroupAvailable
    }
    
    var timeTrackingGroups: [TSTimeTrackingGroup] {
        if let timeTrackingGroups = try? CoreDataManager.shared.managedObjectContext.fetch(timeTrackingGroupsFetchRequest) {
            return timeTrackingGroups
        }
        return [TSTimeTrackingGroup]()
    }
    
    var timeTrackingGroupsFetchRequest: NSFetchRequest<TSTimeTrackingGroup> {
        let timeTrackingGroupsFetchRequest = NSFetchRequest<TSTimeTrackingGroup>(entityName: TSTimeTrackingGroup.entityName)
        timeTrackingGroupsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return timeTrackingGroupsFetchRequest
    }
    
    // MARK: - Methods
    
    func timeTrackingGroup(atIndex index: Int) -> TSTimeTrackingGroup? {
        let groups = timeTrackingGroups
        if index < groups.count {
            return groups[index]
        }
        return nil
    }
    
    func index(forTimeTrackingGroup timeTrackingGroup: TSTimeTrackingGroup) -> Int {
        timeTrackingGroups.firstIndex(of: timeTrackingGroup)!
    }
    
    func createTimeTrackingGroup(withTitle title: String) -> TSTimeTrackingGroup {
        let timeTrackingGroup = TSTimeTrackingGroup(context: CoreDataManager.shared.managedObjectContext)
        timeTrackingGroup.id = UUID()
        timeTrackingGroup.title = title
        CoreDataManager.shared.saveContext()
        objectWillChange.send()
        TimeTrackingManager.shared.objectWillChange.send()
        return timeTrackingGroup
    }
    
    func deleteTimeTrackingGroup(_ timeTrackingGroup: TSTimeTrackingGroup) {
        CoreDataManager.shared.managedObjectContext.delete(timeTrackingGroup)
        CoreDataManager.shared.saveContext()
        objectWillChange.send()
        TimeTrackingManager.shared.objectWillChange.send()
    }
    
    func deleteAllTimeTrackingGroups() {
        for timeTrackingGroup in timeTrackingGroups {
            deleteTimeTrackingGroup(timeTrackingGroup)
        }
    }
    
}
