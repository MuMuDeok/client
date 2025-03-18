//
//  PersistenceController.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/15/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    private let apiService: APIService = .shared

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
    
    func addEvent(event: any Event) {
        let context = container.newBackgroundContext()
        
        context.perform {
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
        let context = container.newBackgroundContext()
        
        context.perform {
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
                print("❌ 수정 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteEvent(event: any Event) {
        let context = container.newBackgroundContext()
        
        context.perform {
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
    
    func addFailedEvent(event: any Event) {
        let context = container.newBackgroundContext()
        
        context.perform {
            let newEvent = Failed_Event(context: context)
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
    }
    
    func reTryFailedEvents() {
        let fetchRequest: NSFetchRequest<Failed_Event> = Failed_Event.fetchRequest()
        
        Task {
            do {
                let failed_events = try context.fetch(fetchRequest)
                print(failed_events)
                for failed_event in failed_events {
                    // 테스트용 userID 4404, 추후 일정별로 case로 나눠서 개발
                    let event = EventToAPIEvent(userId: 4404, failed_event: failed_event)
                    let success = try await apiService.createEvent(event: event)
                    
                    if success {
                        print("🎉 이벤트가 성공적으로 생성되었습니다!")
                        context.delete(failed_event)
                    } else {
                        print("❗️이벤트 생성에 실패했습니다.")
                    }
                }
                
                try context.save()
            } catch {
                print("❌ API 호출 중 오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    // 테스트용으로 추가한 이벤트 제거하기 위한 함수
    func removeAllFailedEvents() {
        let context = container.newBackgroundContext()
        
        context.perform {
            let fetchRequest: NSFetchRequest<Failed_Event> = Failed_Event.fetchRequest()
            
            Task {
                do {
                    let failed_events = try context.fetch(fetchRequest)
                    for failed_event in failed_events {
                        context.delete(failed_event)
                    }
                    
                    try context.save()
                } catch {
                    print("❌ 삭제 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
