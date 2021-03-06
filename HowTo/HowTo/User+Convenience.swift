//
//  User+Convenience.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 29/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRepresentation: UserRepresentation? {
        guard let username = username,
            let password = password else { return nil }

        return UserRepresentation(username: username, password: password)
    }

    @discardableResult convenience init(username: String,
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.username = username
        self.password = password
    }

    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(username: userRepresentation.username,
                  password: userRepresentation.password,
                  context: context)
    }
}
