//
//  Extensions.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/20/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

extension CBLDocument {
    func setProperties(props: [String: AnyObject], put: Bool = true) {
        var properties: [String: AnyObject] = self.properties ?? [:]
        for prop in props.keys {
            properties[prop] = props[prop]
        }
        if put {
            try! putProperties(properties) // Set properties to be synced with CouchBase
        }
    }
}