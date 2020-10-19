//
//  File.swift
//  
//
//  Created by Thomas Willson on 2020-10-18.
//

import Foundation

public extension Date {
	func toString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale.current
		
		return dateFormatter.string(from: self)
	}
}
