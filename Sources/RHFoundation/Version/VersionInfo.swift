//
//  VersionInfo.swift
//  RHFoundation
//
//  Created by Robert Hedin on 11/13/24.
//

import Foundation


internal struct VersionInfo: Codable {
    // MARK: - Public Properties
    
    /// The version number used for the last session of the app.
    internal var lastVersion: Version = Version()
    
    /// The total number of times the application was started.
    internal var totalNumberOfLaunches: Int = 0
    
    /// The number of times this version of the app was started.
    internal var numberOfLaunchesForThisVersion: Int = 0
    
    /// The total number of discrete user sessions since the initial install of the app.
    internal var totalNumberOfSessions: Int = 0
    
    /// The number of discrete user sessions since this specific version of the app was installed.
    internal var numberOfSessionsForThisVersion: Int = 0
    
    /// The date the app was initially installed.
    internal var dateFirstInstalled: Date = Date.now
    
    /// The date this specific version of the app was installed.
    internal var dateThisVersionInstalled: Date = Date.now
    
    /// The date the app was last used before the current session.
    internal var appLastUsedOn: Date = Date.now

    
    // MARK: Public Methods

    internal func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let encodedData = try? encoder.encode(self) {
            do {
                try encodedData.write(to: Self.path)
            }
            catch {
                logger.error("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    // MARK: Public Methods
    
    static internal func load() -> VersionInfo {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let data: Data = try Data(contentsOf: path)
            let decodedVersionInfo: VersionInfo = try decoder.decode(VersionInfo.self, from: data)
            return decodedVersionInfo
        } catch {
            logger.error("Failed to decode JSON data: \(error.localizedDescription)")
        }
        return VersionInfo()
    }
    
    
    // MARK: - Private Properties
    
    private static let path: URL = URL.documentsDirectory.appendingPathComponent("VersionInfo.json")
}
