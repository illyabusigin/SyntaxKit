//
//  Language.swift
//  SyntaxKit
//
//  Created by Sam Soffes on 9/18/14.
//  Copyright © 2014-2015 Sam Soffes. All rights reserved.
//

import Foundation

public struct Language {
    
    // MARK: - Properties
    
    public let UUID: String
    public let name: String
    public let scopeName: String
    public let patterns: [Pattern]
    
    
    // MARK: - Initializers
    
    public init?(dictionary: [NSObject: AnyObject]) {
        guard let UUID = dictionary["uuid"] as? String,
            name = dictionary["name"] as? String,
            scopeName = dictionary["scopeName"] as? String
            else { return nil }
        
        self.UUID = UUID
        self.name = name
        self.scopeName = scopeName
        
        // Associate patterns in the repo
        var repository = [String: Pattern]()
        if let repo = dictionary["repository"] as? [String: [NSObject: AnyObject]] {
            for (key, value) in repo {
                if let pattern = Pattern(dictionary: value) {
                    repository[key] = pattern
                }
            }
        }
        
        // Link associations
        for (_, pattern) in repository {
            pattern.resolveIncludes(repository)
        }
        
        // Unpack all patterns
        var patterns = [Pattern]()
        if let array = dictionary["patterns"] as? [[NSObject: AnyObject]] {
            for value in array {
                if let include = value["include"] as? String {
                    let key = include.substringFromIndex(include.startIndex.successor())
                    if let pattern = repository[key] {
                        patterns.append(pattern)
                        continue
                    }
                }
                
                if let pattern = Pattern(dictionary: value) {
                    patterns.append(pattern)
                }
            }
        }
        
        // Resolve pattern includes
        // NOTE: Need to break cyclical dependencies
        for pattern in patterns {
            pattern.resolveIncludes(repository)
        }
        
        print("patterns = \(patterns.count), lang = \(self.name)")
        self.patterns = patterns
    }
}
