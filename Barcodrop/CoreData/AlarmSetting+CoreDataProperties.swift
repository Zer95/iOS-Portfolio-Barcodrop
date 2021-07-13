//
//  AlarmSetting+CoreDataProperties.swift
//  
//
//  Created by SG on 2021/06/18.
//
//

import Foundation
import CoreData


extension AlarmSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmSetting> {
        return NSFetchRequest<AlarmSetting>(entityName: "AlarmSetting")
    }

    @NSManaged public var dDay6: Bool
    @NSManaged public var dDay5: Bool
    @NSManaged public var dDay4: Bool
    @NSManaged public var dDay3: Bool
    @NSManaged public var dDay2: Bool
    @NSManaged public var dDay1: Bool
    @NSManaged public var dDay0: Bool
    @NSManaged public var onOff: Bool
    @NSManaged public var selectTime: String?
    @NSManaged public var dDay7: Bool

}
