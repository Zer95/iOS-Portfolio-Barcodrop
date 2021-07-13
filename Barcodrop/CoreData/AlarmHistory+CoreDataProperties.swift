//
//  AlarmHistory+CoreDataProperties.swift
//  
//
//  Created by SG on 2021/06/20.
//
//

import Foundation
import CoreData


extension AlarmHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmHistory> {
        return NSFetchRequest<AlarmHistory>(entityName: "AlarmHistory")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var alarmTime: Date?

}
