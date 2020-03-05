//
//  user+convenience.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(id: Int16 = Int16(),
                     isLandOwner: Bool = false,
                     password: String? = nil,
                     username: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.id = id
            self.password = password
            self.username = username
            self.is_land_owner = isLandOwner
    }
    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            let id = userRepresentation.id
            let isLandOwner = userRepresentation.isLandOwner
            let username = userRepresentation.username
            let password = userRepresentation.password
            self.init(id: id,
                      isLandOwner: isLandOwner,
                      password: password,
                      username: username,
                      context: context)
        }
    var userRepresentation: UserRepresentation? {
        guard let password = password,
            let username = username
        else {return nil}
        let id = self.id
        let isLandOwner = is_land_owner
        return UserRepresentation(id: id, username: username, isLandOwner: isLandOwner, password: password)
    }
}
