//
//  VersionInfo.swift
//  RHFoundation
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
        if FileManager.default.fileExists(atPath: Self.path.absoluteString) {
            do {
                let data: Data = try Data(contentsOf: path)
                let decodedVersionInfo: VersionInfo = try decoder.decode(VersionInfo.self, from: data)
                return decodedVersionInfo
            } catch {
                logger.error("Failed to decode JSON data: \(error.localizedDescription)")
            }
        }
        return VersionInfo()
    }
    
    
    // MARK: - Private Properties
    
    private static let path: URL = URL.documentsDirectory.appendingPathComponent("VersionInfo.json")
}
