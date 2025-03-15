//
//  CD_Event+CoreDataProperties.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/15/25.
//
//

import Foundation
import CoreData


extension CD_Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Event> {
        return NSFetchRequest<CD_Event>(entityName: "CD_Event")
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

extension CD_Event : Identifiable {

}
