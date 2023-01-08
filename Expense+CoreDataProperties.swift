//
//  Expense+CoreDataProperties.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 07.01.23.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var category: Category?

}

extension Expense : Identifiable {

}
