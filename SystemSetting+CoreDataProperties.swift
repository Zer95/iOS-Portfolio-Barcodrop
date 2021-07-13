//
//  SystemSetting+CoreDataProperties.swift
//  
//
//  Created by SG on 2021/07/13.
//
//

import Foundation
import CoreData


extension SystemSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SystemSetting> {
        return NSFetchRequest<SystemSetting>(entityName: "SystemSetting")
    }

    @NSManaged public var dateLanguage: String?

}
