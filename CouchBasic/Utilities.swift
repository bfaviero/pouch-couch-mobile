//
//  Utilities.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/18/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

extension CBLView {
    // Just reorders the parameters to take advantage of Swift's trailing-block syntax.
    func setMapBlock(version: String, mapBlock: CBLMapBlock) -> Bool {
        return setMapBlock(mapBlock, version: version)
    }
}

extension NSDate {
    class func withJSONObject(jsonObj: AnyObject) -> NSDate? {
        return CBLJSON.dateWithJSONObject(jsonObj)
    }
}