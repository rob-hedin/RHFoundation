//
//  Locale+Language.swift
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


public extension Locale {
    /// retrieves the (friendly) language name for the current locale.
    ///
    /// - Returns: the language name for the current locale.
    ///
    /// - Note: `en_US` will return "English"
    var localizedCurrentLanguageName: String? {
        guard let languageCode = language.languageCode?.identifier else {
            return nil
        }
        return localizedString(forLanguageCode: languageCode)
    }


    /// retrieves the (friendly) region name for the current locale.
    ///
    /// - Returns: the language name for the current locale.
    ///
    /// - Note: `en_US` will return "English"
    var localizedCurrentRegionName: String? {
        guard let regionCode = language.region?.identifier else {
            return nil
        }
        return localizedString(forRegionCode: regionCode)
    }
    
    
    /// Returns a friendly description for the local (eg, instead of `en_US` it will return "English (United States)").
    var friendlyDescription: String {
        let languageName: String = localizedCurrentLanguageName ?? language.languageCode?.identifier ?? ""
        let regionName: String = localizedCurrentRegionName ?? region?.identifier ?? ""
        return "\(languageName) (\(regionName))"
    }
}
