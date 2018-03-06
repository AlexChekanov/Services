//
//  PList.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 11/21/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//

import Foundation

public extension Service {
    
    final class PropertyList {
        
        // TODO: - Is needed?
        lazy var dictionary: NSDictionary = {
            
            //TODO: Add error handling
            let path = Bundle.main.path(forResource: "Dictionary", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            
            return dictionary!
        }()
        
    }
    
    
}
