//
//  Pattern.swift
//  SyntaxKit
//
//  Created by Sam Soffes on 9/18/14.
//  Copyright © 2014-2015 Sam Soffes. All rights reserved.
//

import Foundation

final class Pattern {

	// MARK: - Properties

	let name: String?
	let match: String?
	let captures: CaptureCollection?
	let begin: String?
	let beginCaptures: CaptureCollection?
	let end: String?
	let endCaptures: CaptureCollection?
	private weak var parent: Pattern?
	private let patterns: [Pattern]

	var superpattern: Pattern? {
		return parent
	}

	var subpatterns: [Pattern] {
		return patterns
	}

	// MARK: - Initializers

    init?(dictionary: [NSObject: AnyObject], repo: [String: [NSObject: AnyObject]] = [String: [NSObject: AnyObject]](), parent: Pattern? = nil) {
		self.parent = parent
		self.name = dictionary["name"] as? String
		self.match = dictionary["match"] as? String
		self.begin = dictionary["begin"] as? String
		self.end = dictionary["end"] as? String
        

		if let dictionary = dictionary["beginCaptures"] as? [NSObject: AnyObject] {
			self.beginCaptures = CaptureCollection(dictionary: dictionary)
		} else {
			self.beginCaptures = nil
		}

		if let dictionary = dictionary["captures"] as? [NSObject: AnyObject] {
			self.captures = CaptureCollection(dictionary: dictionary)
		} else {
			self.captures = nil
		}

		if let dictionary = dictionary["endCaptures"] as? [NSObject: AnyObject] {
			self.endCaptures = CaptureCollection(dictionary: dictionary)
		} else {
			self.endCaptures = nil
		}
        
        var patterns = [Pattern]()
        
        // Check to see if this an include only
        if let patternLink = PatternLink(dictionary: dictionary) {
            if let patternData = repo[patternLink.name] {
                if let pattern = Pattern(dictionary: patternData, repo: repo, parent: parent) {
                    patterns.append(pattern)
                }
            }
        } else if let array = dictionary["patterns"] as? [[NSObject: AnyObject]] {
            // If we have pattern links, follow them and instantiate patterns
			for value in array {
                if let link = PatternLink(dictionary: value) {
                    
                    if let patternData = repo[link.name] {
                        if let pattern = Pattern(dictionary: patternData, repo: repo, parent: parent) {
                            patterns.append(pattern)
                        }
                    }
                } else {
                    // This is just a plain old pattern, probably
                    if let pattern = Pattern(dictionary: value, repo: repo, parent: parent) {
                        patterns.append(pattern)
                    }
                }
			}
		}
        
		self.patterns = patterns
        
        // If name AND match is empty, return nil
        if self.name == nil && self.match == nil && patterns.count == 0 {
            return nil
        }
        
        //guard let _ = dictionary["name"] as? String  else { return nil }
	}
}
