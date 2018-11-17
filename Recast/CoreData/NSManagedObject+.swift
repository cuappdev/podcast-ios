//
//  NSManagedObject+.swift
//  Recast
//
//  Created by Mindy Lou on 11/14/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import CoreData

/// Protocol that allows for NSManagedObjects to not be attached to a context.
/// Extend NSManagedObjects to this protocol if you do not wish to save the managed object immediately.
protocol DisconnectedEntityProtocol { }

extension DisconnectedEntityProtocol where Self: NSManagedObject {
    static func disconnectedEntity() -> Self {
        // swiftlint:disable:next force_cast
        return NSManagedObject(entity: self.entity(), insertInto: nil) as! Self
    }
}
