//
//  Locale+Language.swift
//  RHFoundation
//
//  Created by Robert Hedin on 11/13/24.
//

import Foundation


extension Locale {
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
}
