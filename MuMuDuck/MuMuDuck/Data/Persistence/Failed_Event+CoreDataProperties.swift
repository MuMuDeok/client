//
//  Failed_Event+CoreDataProperties.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//
//

import Foundation
import CoreData


extension Failed_Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Failed_Event> {
        return NSFetchRequest<Failed_Event>(entityName: "Failed_Event")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var isAllDay: Bool
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var alertTime: Int16
    @NSManaged public var memo: String?
    @NSManaged public var type: String

}

extension Failed_Event : Identifiable {

}
