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
import Foil
import UIKit


@MainActor
public final class AppVersion {
    
    // MARK: - Singleton Accessor
    
    /// Accessor for the Singleton instance.
    public static let shared = {
        return AppVersion()
    }()
    
    
    // MARK: - Public Properties
    
    /// The version number used for the last session of the app.
    var lastVersion: Version = Version()
    
    /// The version number used by the current session of the app.
    var currentVersion: Version = Version()
    
    /// The total number of times the application was started.
    @FoilDefaultStorage(key: "totalNumberOfLaunches")
    private(set) var totalNumberOfLaunches: Int = 0
    
    /// The number of times this version of the app was started.
    @FoilDefaultStorage(key: "numberOfLaunchesForThisVersion")
    private(set) var numberOfLaunchesForThisVersion: Int = 0
    
    /// The total number of discrete user sessions since the initial install of the app.
    @FoilDefaultStorage(key: "totalNumberOfSessions")
    private(set) var totalNumberOfSessions: Int = 0
    
    /// The number of discrete user sessions since this specific version of the app was installed.
    @FoilDefaultStorage(key: "numberOfSessionsForThisVersion")
    private(set) var numberOfSessionsForThisVersion: Int = 0
    
    /// The date the app was initially installed.
    private(set) var dateFirstInstalled: Date = Date.now
    
    /// The date this specific version of the app was installed.
    private(set) var dateThisVersionInstalled: Date = Date.now
    
    /// The date the app was last used before the current session.
    private(set) var appLastUsedOn: Date = Date.now

    
    /// Indicates if this session is during the First Time Launch of the app.
    public private(set) var firstTimeLaunch = true
    
    
    /// Indicates if this session is during an Upgrade Launch of the app.
    /// (i.e. the first launch after the app was upgraded)
    public private(set) var launchAfterUpgrade = false
    
    
    
    
    // MARK: - Initializers
    
    /// The designated initializer.
    fileprivate init() {
        // Load any previous version info
        lastVersion = Version(normalizedVersionNumber: self.normalizedLastVersion)
        currentVersion = Version(normalizedVersionNumber: self.normalizedCurrentVersion)
        
        // get the date for later use
        let today = Date.now

        // setup the current version
        currentVersion = Bundle.applicationVersionNumber
        normalizedCurrentVersion = currentVersion.normalizedVersionNumber
        
        // is this our first time launch?
        if self.lastVersion.isValid {
            // we already have a last version so we're not a first time launch
            firstTimeLaunch = false
        } else {
            // must be a first time launch
            self.lastVersion = currentVersion
            dateFirstInstalled = today
            dateThisVersionInstalled = today
        }
        
        // setup launch and session counts
        totalNumberOfLaunches += 1
        numberOfLaunchesForThisVersion += 1
        totalNumberOfSessions += 1
        numberOfSessionsForThisVersion += 1
        
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
                numberOfLaunchesForThisVersion = 1
                numberOfSessionsForThisVersion = 1
                
                // ...and dates
                dateThisVersionInstalled = today
            }
        }
        
        // now update today's info
        appLastUsedOn = today

        // and make sure to update the last version ran to be the current version
        self.lastVersion = currentVersion
        normalizedLastVersion = lastVersion.normalizedVersionNumber
    }
    
    
    
    // MARK: - Public Methods
    
    public func enterForeground() {
        // update our use counts
        self.totalNumberOfSessions += 1
        self.numberOfSessionsForThisVersion += 1
    }
    
    
    
    public func enterBackground() {
        // update the last ran version whenever the app goes to the background
        self.lastVersion = self.currentVersion
        
        // we can no longer be performing a first time
        // launch or an upgrade launch if we're going to the
        // background
        self.firstTimeLaunch = false
        self.launchAfterUpgrade = false
        
        // and update the date this version was used
        self.appLastUsedOn = Date.now
    }
    
    
    
    // MARK: - Private Properties
    
    /// The normalized version number used for the last session of the app.
    @FoilDefaultStorage(key: "normalizedLastVersion")
    private var normalizedLastVersion: Int = 0

    /// The normalized version number used by the current session of the app.
    @FoilDefaultStorage(key: "normalizedCurrentVersion")
    private var normalizedCurrentVersion: Int = 0 
}
