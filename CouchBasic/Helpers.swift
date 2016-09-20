//
//  Helpers.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/18/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation
import UIKit

@warn_unused_result
public func Init<Type>(value : Type, @noescape block: (object: Type) -> Void) -> Type
{
    block(object: value)
    return value
}

extension NSLayoutConstraint {
    convenience init(item: AnyObject, toItem: AnyObject, attribute: NSLayoutAttribute) {
        self.init(item: item, attribute: attribute, relatedBy: .Equal, toItem: toItem, attribute: attribute, multiplier: 1.0, constant: 0.0)
    }
    
    convenience init(item: AnyObject, attribute attribute1: NSLayoutAttribute, toItem: AnyObject, attribute attribute2: NSLayoutAttribute) {
        self.init(item: item, attribute: attribute1, relatedBy: .Equal, toItem: toItem, attribute: attribute2, multiplier: 1.0, constant: 0.0)
    }
}

extension UIView {
    func constrainAttribute(attribute: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant);
        self.addConstraint(constraint);
        return constraint
    }
    
    func constrainToItem(item: AnyObject, attributes: [NSLayoutAttribute]) -> [NSLayoutConstraint] {
        let constraints = attributes.map() {return NSLayoutConstraint(item: self, toItem: item, attribute: $0)}
        item.addConstraints(constraints)
        return constraints
    }
    
}
