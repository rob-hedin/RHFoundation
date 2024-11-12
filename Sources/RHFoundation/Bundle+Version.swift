//
//  Bundle+Version.swift
//  
//
//  Created by Robert Hedin on 11/12/24.
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
            let version = Version(version: value)
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
