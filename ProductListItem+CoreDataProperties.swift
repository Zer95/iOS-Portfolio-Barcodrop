//
//  ProductListItem+CoreDataProperties.swift
//  
//
//  Created by SG on 2021/07/02.
//
//

import Foundation
import CoreData


extension ProductListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductListItem> {
        return NSFetchRequest<ProductListItem>(entityName: "ProductListItem")
    }

    @NSManaged public var buyDay: Date?
    @NSManaged public var category: String?
    @NSManaged public var endDay: Date?
    @NSManaged public var imgURL: String?
    @NSManaged public var productName: String?
    @NSManaged public var saveTime: Date?
    @NSManaged public var alarmSend: Bool

}
