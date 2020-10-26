//
//  File.swift
//  
//
//  Created by Thomas Willson on 2020-10-24.
//

import Foundation

public protocol SettingsStore {
	func setDefaultZipCode(_ zipCode: String)
	
	func getDefaultZipCode() -> String?
}

public class DefaultsSettingsStore: SettingsStore {
	let defaultZipCodeKey = "DefaultZipCode"
	
	public init() {}
	
	public func setDefaultZipCode(_ zipCode: String) {
		UserDefaults.standard.set(zipCode, forKey: defaultZipCodeKey)
	}
	
	public func getDefaultZipCode() -> String? {
		return UserDefaults.standard.string(forKey: defaultZipCodeKey)
	}
}
