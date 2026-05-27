//
//  Task+CoreDataProperties.swift
//  ToDoListTask
//
//  Created by Иван on 26.05.2026.
//
//

import Foundation
import CoreData

@objc(TodoTask)
public class TodoTask: NSManagedObject {}

extension TodoTask {

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var descTask: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var beginDate: Date
    
}

extension TodoTask : Identifiable {

}
