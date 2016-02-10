//
//  Language.swift
//  SyntaxKit
//
//  Created by Sam Soffes on 9/18/14.
//  Copyright © 2014-2015 Sam Soffes. All rights reserved.
//

import Foundation

internal struct PatternLink {
    let name: String
    
    init?(dictionary: [NSObject: AnyObject]) {
        guard let name = dictionary["include"] as? String  else { return nil }
        self.name = name.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "#")) //name.substringFromIndex(name.startIndex.successor())
    }
}

public struct Language {

	// MARK: - Properties

	public let UUID: String
	public let name: String
	public let scopeName: String
	let patterns: [Pattern]


	// MARK: - Initializers

	public init?(dictionary: [NSObject: AnyObject]) {
		guard let UUID = dictionary["uuid"] as? String,
			name = dictionary["name"] as? String,
			scopeName = dictionary["scopeName"] as? String
			else { return nil }

		self.UUID = UUID
		self.name = name
		self.scopeName = scopeName
        
        /*
        Loop through patterns
        For each link, check to see if has children
        */
        
        // Build up our link and patterns table
        var foundPatterns = [Pattern]()
//        if let patterns = dictionary["patterns"] as? [[NSObject: AnyObject]] {
//            for (value) in patterns {
//                if let link = PatternLink(dictionary: value) {
//                    // We have a link
//                    patternLinks.append(link)
//                } else if let pattern = Pattern(dictionary: value) {
//                    // We have a pattern
//                    foundPatterns.append(pattern)
//                }
//            }
//        }
//        
//        // Iterate through repository
//        // Check each value to make sure it's patterns aren't links
//        if let repo = dictionary["repository"] as? [String: [NSObject: AnyObject]] {
//            for (key, value) in repo {
//                print("key = \(key)")
//                // Istantiate pattern, if available
//                if let pattern = Pattern(dictionary: value) {
//                    print("found pattern for key: \(key)")
//                    foundPatterns.append(pattern)
//                } else {
//                    
//                }
//                
//                if let children = value["patterns"] as? [String: [NSObject: AnyObject]] {
//                    for (childKey, childValue) in children {
//                        if let link = PatternLink(dictionary: childValue) {
//                            print("found link for key: \(childKey)")
//                            if let pattern = Pattern(dictionary: repo[link.name]!) {
//                                foundPatterns.append(pattern)
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
//        func initializePatterns(dictionary: [NSObject: AnyObject]) -> [Pattern] {
//            
//        }
//
//        var repository = [String: Pattern]()
//        if let repo = dictionary["repository"] as? [String: [NSObject: AnyObject]] {
//            for (key, value) in repo {
//                if let pattern = Pattern(dictionary: value, repo: repo) {
//                    repository[key] = pattern
//                }
//            }
//        }
//        
//        if let array = dictionary["patterns"] as? [[NSObject: AnyObject]] {
//            for value in array {
//                if let include = value["include"] as? String {
//                    let key = include.substringFromIndex(include.startIndex.successor())
//                    if let pattern = repository[key] {
//                        foundPatterns.append(pattern)
//                        continue
//                    }
//                }
//                
//                if let pattern = Pattern(dictionary: value) {
//                    foundPatterns.append(pattern)
//                }
//            }
//        }

        
        // Initialize repository as empty value
        var repository =  [String: [NSObject: AnyObject]]()
    
        if let repo = dictionary["repository"] as? [String: [NSObject: AnyObject]] {
            // We have a good repository so let's use it
            repository = repo
        }
        
//        func initializePatterns(dictionary: [NSObject: AnyObject]) -> [Pattern] {
//            var patterns = [Pattern]()
//            
//            // If it's a pattern, unpack it
//            if let pattern = Pattern(dictionary: dictionary, repo: repository) {
//                patterns.append(pattern)
//            } else if let link = PatternLink(dictionary: dictionary) {
//                // We have a link
//                let linkPatterns = patternsFromLink(link)
//                patterns.appendContentsOf(linkPatterns)
//            }
//            return patterns
//        }
//        
//        func patternsFromLink(link: PatternLink) -> [Pattern] {
//            var linkPatterns = [Pattern]()
//            return linkPatterns
//        }
        
        if let array = dictionary["patterns"] as? [[NSObject: AnyObject]] {
            for value in array {
                if let pattern = Pattern(dictionary: value, repo: repository) {
                    foundPatterns.append(pattern)
                }
            }
        }
		self.patterns = foundPatterns
        print("patterncount = \(foundPatterns.count), lang = \(self.name)")
	}
}
