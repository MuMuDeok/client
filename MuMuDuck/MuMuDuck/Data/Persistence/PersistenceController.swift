//
//  PersistenceController.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/15/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MuMuDuck")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // DIP 법칙을 통해 받아와서 memo처럼 타입별로 있는 부가적인 데이터는 별도의 인자로 전달해주기
    func addEvent(event: any Event) {
        let newEvent = CD_Event(context: context)
        newEvent.id = event.id
        newEvent.title = event.title
        newEvent.isAllDay = event.isAllDay
        newEvent.startDate = event.startDate
        newEvent.endDate = event.endDate
        if let alertTime = event.alertTime {
            newEvent.alertTime = Int16(alertTime)
        }
        newEvent.type = event.type.rawValue
        
        if event.type == .personal { // 나중에 다른 타입의 일정 생성시 switch case로 변경하기
            newEvent.memo = (event as! PersonalEvent).memo
        }
        
        do {
            try context.save()
            print("✅ 저장 완료: \(event.title)")
        } catch {
            print("❌ 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func fetchEvents() -> [CD_Event] {
        let fetchRequest: NSFetchRequest<CD_Event> = CD_Event.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("❌ 데이터 가져오기 실패: \(error.localizedDescription)")
            return []
        }
    }

    // 수정의 경우 일정의 타입은 안 바뀌므로 id와 type을 제외한 프로퍼티 수정하기
    func updateEvent(event: any Event) {
        let fetchRequest: NSFetchRequest<CD_Event> = CD_Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
        
        do {
            let cd_events = try context.fetch(fetchRequest)
            for cd_event in cd_events {
                cd_event.title = event.title
                cd_event.isAllDay = event.isAllDay
                cd_event.startDate = event.startDate
                cd_event.endDate = event.endDate
                if let alertTime = event.alertTime {
                    cd_event.alertTime = Int16(alertTime)
                }
                
                if event.type == .personal { // 나중에 다른 타입의 일정 생성시 switch case로 변경하기
                    cd_event.memo = (event as! PersonalEvent).memo
                }
            }
            
            try context.save()
        } catch {
            print("❌ 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func deleteEvent(event: any Event) {
        let fetchRequest: NSFetchRequest<CD_Event> = CD_Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
        
        do {
            let cd_events = try context.fetch(fetchRequest)
            for cd_event in cd_events {
                context.delete(cd_event)
            }
            
            try context.save()
        } catch {
            print("❌ 삭제 실패: \(error.localizedDescription)")
        }
    }
}
