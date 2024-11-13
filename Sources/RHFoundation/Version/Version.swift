//
//  Version.swift
//
//  Copyright © 2024-2025 Robert Hedin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import os



/// defines a standard way of looking at version numbers using semantic versioning
public class Version: Codable {
    
    // MARK: - Public Properties
    /// A string representation of a version number.
    /// This always consists of a major, a minor , and a release number
    /// separated by a decimal point.
    /// All values must be non-negative and all will be present.
    public var versionNumber: String {
        let version = toString()
        return version
    }
    
    /// A short version number suppresses any trailing release values of 0.
    /// This allows 1.0.0 to be represented as 1.0
    public var shortVersionNumber: String {
        let version = toString(stripReleaseIfZero: true)
        return version
    }
    
    /// A normalized version number, useful for comparing two versions
    /// Normalized versions are numeric, and are in the form: [M]Mmmrr so
    /// version 7.9.1 would be represented as: 70901
    public let normalizedVersionNumber: Int
    
    
    public var isValid: Bool {
        return normalizedVersionNumber >= 0
    }
    
    
    
    
    // MARK: - Initializers
    
    /// Creates a new, empty version number
    public init() {
        normalizedVersionNumber = 0
    }
    
    
    /// Creates a new, empty version number
    public init(normalizedVersionNumber: Int) {
        // sanity check
        guard normalizedVersionNumber > 0 else {
            logger.warning( "Attempt to create a version number with a negative normalized version number: \(normalizedVersionNumber)" )
            self.normalizedVersionNumber = 0
            return
        }

        self.normalizedVersionNumber = normalizedVersionNumber
    }

    
    
    
    /// Attempt to create a new version based on the specified string. If the string cannot be parsed
    /// a 0 version will be returned
    ///
    /// - Parameters:
    ///     - version: The string representation of the version number to be converted
    public init( _ version: String? ) {
        var realVersion = 0
        if let version {
            realVersion = Version.normalizeVersionNumber(version)
        }
        normalizedVersionNumber = realVersion
    }

    
    
    
    // MARK: - Private Methods
    
    ///  Creates a normalized version number of the form MMmmrr from the passed values
    ///
    ///  - Parameters:
    ///     - str: The string to convert
    ///
    ///  - Returns: A normalized version number, or a version of 0 if the input is invalid
    private static func normalizeVersionNumber( _ str: String ) -> Int {
        
        // let's get rid of any leading and/or trailing whitespace
        let trimmed = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // an empty version is invalid
        guard trimmed.isEmpty == false else {
            logger.warning( "Input Version is empty after trimming, assuming a version of 0.0.0" )
            return 0
        }
        
        // ok, now let's break the string on decimal point boundaries
        let components = trimmed.components(separatedBy: ".")
        
        guard components.count > 0 else {
            // no components
            logger.warning( "No version components found, assuming a version of 0.0.0" )
            return 0
        }
        
        // setup our default values
        var major: Int = 0
        var minor: Int = 0
        var release: Int = 0
        
        // process major (we know we have at least one component from the above check)
        if let value = Int(components[0]) {
            major = value
        }
        
        // process minor
        if components.count > 1,
            let value = Int(components[1]) {
            minor = value
        }

        // process release
        if components.count > 2,
           let value = Int(components[2]) {
            release = value
        }
        
        let normalized = ( 10000 * major ) + ( 100 * minor ) + release
        return normalized
    }
    
    
    
    /// Splits the version number into its component parts
    ///
    /// - Returns: A  string representation of the version number
    private func toString(stripReleaseIfZero: Bool = false) -> String {
        var major: Int = 0
        var minor: Int = 0
        var release: Int = 0
        
        major = normalizedVersionNumber / 10000
        minor = (normalizedVersionNumber % 10000) / 100
        release = normalizedVersionNumber % 100

//        let minorString = minor.formatted(.number.precision(.integerLength(2)))

        // now output the version number
        if release == 0,
           stripReleaseIfZero == true {
            return "\(major).\(minor)"
        }
        
        // we are outputting the release
//        let releaseString = release.formatted(.number.precision(.integerLength(2)))
        return "\(major).\(minor).\(release)"
    }
}

    
    
// MARK: - CustomStringConvertible Conformance
extension Version: CustomStringConvertible {
    public var description: String {
        return self.versionNumber
    }
}



// MARK: - CustomDebugStringConvertible Conformance
extension Version: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "Object Version-\n"
        description += "  versionNumber:           \(versionNumber)\n"
        description += "  normalizedVersionNumber: \(normalizedVersionNumber)\n"
        return description
    }
}



// MARK: - Equatable Conformance
extension Version: Equatable {
    public static func ==(lhs: Version, rhs: Version) -> Bool {
        return lhs.normalizedVersionNumber == lhs.normalizedVersionNumber
    }
}



// MARK: - Hashable Conformance

extension Version: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(normalizedVersionNumber)
    }
}



// MARK: - Comparable Conformance
extension Version: Comparable {
    public static func < (lhs: Version, rhs:Version) -> Bool {
        return lhs.normalizedVersionNumber < rhs.normalizedVersionNumber
    }
}
