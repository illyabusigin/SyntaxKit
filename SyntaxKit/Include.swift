//
//  Include.swift
//  SyntaxKit
//
//  Created by Illya Busigin on 2/10/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import Foundation

internal struct Include {
    let name: String
    
    init?(dictionary: [NSObject: AnyObject]) {
        guard let name = dictionary["include"] as? String else { return nil}
        self.name = name.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "#"))
    }
}