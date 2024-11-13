//
//  AppVersion.swift
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


public final class AppVersion {
    
    // MARK: - Singleton Accessor
    
    /// Accessor for the Singleton instance.
    nonisolated(unsafe) public static let shared = {
        return AppVersion()
    }()
    
    
    // MARK: - Public Properties
    
    /// The version number used for the last session of the app.
    public var lastVersion: Version {
        versionInfo.lastVersion
    }
    
    /// The total number of times the application was started.
    public var totalNumberOfLaunches: Int {
        versionInfo.totalNumberOfLaunches
    }
    
    /// The number of times this version of the app was started.
    public var numberOfLaunchesForThisVersion: Int {
        versionInfo.numberOfLaunchesForThisVersion
    }
    
    /// The total number of discrete user sessions since the initial install of the app.
    public var totalNumberOfSessions: Int {
        versionInfo.totalNumberOfSessions
    }
    
    /// The number of discrete user sessions since this specific version of the app was installed.
    public var numberOfSessionsForThisVersion: Int {
        versionInfo.numberOfSessionsForThisVersion
    }
    
    /// The date the app was initially installed.
    public var dateFirstInstalled: Date  {
        versionInfo.dateFirstInstalled
    }
    
    /// The date this specific version of the app was installed.
    public var dateThisVersionInstalled: Date  {
        versionInfo.dateThisVersionInstalled
    }
    
    /// The date the app was last used before the current session.
    public var appLastUsedOn: Date  {
        versionInfo.appLastUsedOn
    }
    
    /// Indicates if this session is during the First Time Launch of the app.
    public private(set) var firstTimeLaunch = true
    
    
    /// Indicates if this session is during an Upgrade Launch of the app.
    /// (i.e. the first launch after the app was upgraded)
    public private(set) var launchAfterUpgrade = false
    
    
    
    
    // MARK: - Initializers
    
    /// The designated initializer.
    fileprivate init() {
        // load any data we've had in the past
        self.versionInfo = VersionInfo.load()
        
        // get the date for later use
        let today = Date.now

        // setup the current version
        let currentVersion = Bundle.applicationVersionNumber
        
        // is this our first time launch?
        if self.lastVersion.isValid {
            // we already have a last version so we're not a first time launch
            firstTimeLaunch = false
        } else {
            // must be a first time launch
            versionInfo.lastVersion = currentVersion
            versionInfo.dateFirstInstalled = today
            versionInfo.dateThisVersionInstalled = today
        }
        
        // setup launch counts
        versionInfo.totalNumberOfLaunches += 1
        versionInfo.numberOfLaunchesForThisVersion += 1
        
        // determine if this is an upgrade
        // an initial install is not considered an upgrade
        if ( !firstTimeLaunch )
        {
            // ok, we've been ran before, have we upgraded
            if ( currentVersion > lastVersion )
            {
                // this is an upgrade
                launchAfterUpgrade = true
                
                // and reset our counts...
                versionInfo.numberOfLaunchesForThisVersion = 1
                versionInfo.numberOfSessionsForThisVersion = 1
                
                // ...and dates
                versionInfo.dateThisVersionInstalled = today
            }
        }
        
        // now update today's info
        versionInfo.appLastUsedOn = today

        // make sure to update the last version ran to be the current version
        versionInfo.lastVersion = currentVersion
        
        // and save the info
        versionInfo.save()
    }
    
    
    
    // MARK: - Public Methods
    
    public func enterForeground() {
        // update our use counts
        versionInfo.totalNumberOfSessions += 1
        versionInfo.numberOfSessionsForThisVersion += 1
        
        // and store it
        versionInfo.save()
    }
    
    
    
    public func enterBackground() {
        // update the last ran version whenever the app goes to the background
        versionInfo.lastVersion = Bundle.applicationVersionNumber
        
        // we can no longer be performing a first time
        // launch or an upgrade launch if we're going to the
        // background
        self.firstTimeLaunch = false
        self.launchAfterUpgrade = false
        
        // update the date this version was used
        versionInfo.appLastUsedOn = Date.now
        
        // and store it
        versionInfo.save()
    }
    
    
    
    // MARK: - Private Properties
    
    private var versionInfo: VersionInfo
}
