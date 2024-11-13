//
//  Bundle+Version.swift
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




// MARK: -
// MARK: Instance Methods

public extension Bundle {
    
    /// retrieves the build number for the application.
    var applicationBuildNumber: String {
        guard let value = self.object(forInfoDictionaryKey: "CFBundleVersion") as! String? else {
            logger.warning("Unable to read key 'CFBundleVersion' from main bundle Info.plist; assuming build number is an empty string.")
            return ""
        }
        return value
    }
    
    
    
    /// The display name for the application.
    var applicationDisplayName: String {
        guard let name = self.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String? else {
            logger.warning("Unable to read key 'CFBundleDisplayName' from main bundle Info.plist; assuming application display name is an empty string.")
            return ""
        }
        return name
    }
    
    
    
    /// the human readable version number for the application.
    var applicationVersionNumber: Version {
        if let value = self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? {
            let version = Version(value)
            return version
        }
        return Version()
    }
}





// MARK: -
// MARK: Class Methods

public extension Bundle {

    /// retrieves the build number for the application.
    static var applicationBuildNumber: String {
        let bundle = Bundle.main
        return bundle.applicationBuildNumber
    }
    
    
    
    /// The display name for the application.
    static var applicationDisplayName: String {
        let bundle = Bundle.main
        return bundle.applicationDisplayName
    }
    
    
    
    /// the human readable version number for the application.
    static var applicationVersionNumber: Version {
        let bundle = Bundle.main
        return bundle.applicationVersionNumber
    }
}
