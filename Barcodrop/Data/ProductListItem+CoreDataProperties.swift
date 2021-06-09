//
//  ProductListItem+CoreDataProperties.swift
//  
//
//  Created by SG on 2021/06/09.
//
//

import Foundation
import CoreData


extension ProductListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductListItem> {
        return NSFetchRequest<ProductListItem>(entityName: "ProductListItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var createDay: Date?

}
