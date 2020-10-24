//
//  File.swift
//  
//
//  Created by Thomas Willson on 2020-10-24.
//

import Foundation

class SettingsStore {
	static let defaultZipCodeKey = "DefaultZipCode"
	
	static func setDefaultZipCode(_ zipCode: String) {
		UserDefaults.standard.set(zipCode, forKey: defaultZipCodeKey)
	}
	
	static func getDefaultZipCode() -> String? {
		return UserDefaults.standard.string(forKey: defaultZipCodeKey)
	}
}
