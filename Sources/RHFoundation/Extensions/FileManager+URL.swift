//
//  FileManager+URL.swift
//  RHFoundation
//
//  Created by Robert Hedin on 11/13/24.
//

import Foundation

public extension FileManager {
    
    /// Returns a Boolean value that indicates whether a file or directory exists at a specified URL.
    ///
    /// - Parameters:
    ///     - url: The file URL for the file or directory.
    func fileExists(at url: URL) -> Bool {
        return self.fileExists(at: url, isDirectory: nil)
    }
    
    
    /// Returns a Boolean value that indicates whether a file or directory exists at a specified URL.
    ///
    /// - Parameters:
    ///     - url: The file URL for the file or directory.
    ///     - isDirectory: Upon return, contains true if the URL is a directory, or false if it is a file.
    ///                 If the URL is a file that does not exist, the value of this parameter is undefined.
    ///                 Pass nil if you do not need this information.
    func fileExists(at url: URL, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        return self.fileExists(atPath: url.path, isDirectory: isDirectory)
    }
}
