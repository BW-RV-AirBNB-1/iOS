//
//  state+convenience.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

extension State {
    convenience init(stateAbbreviation: String = "",
                     stateName: String = "",
                     id: Int16 = Int16(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.state_abbreviation = stateAbbreviation
        self.state_name = stateName
        self.id = id
    }
    @discardableResult convenience init?(
        stateRepresensation: StateRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(stateAbbreviation: stateRepresensation.stateAbbreviation,
                  stateName: stateRepresensation.stateName,
                  id: stateRepresensation.id,
                  context: context)
    }
}
