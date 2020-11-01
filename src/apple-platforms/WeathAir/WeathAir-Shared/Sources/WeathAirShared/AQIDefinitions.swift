//
//  File.swift
//  
//
//  Created by Thomas Willson on 2020-10-31.
//

import SwiftUI

public struct AQICategory {
	let name: String
	let color: CGColor
	let range: ClosedRange<Int>
}

public struct AQIDefinitions {
	public static let categories = [
		AQICategory(name: "Good", color: convertColor(rgb: 0x00e400), range: 0...50),
		AQICategory(name: "Moderate", color: convertColor(rgb: 0xffff00), range: 51...100),
		AQICategory(name: "Unhealthy for Sensitive Groups", color: convertColor(rgb: 0xff7e00), range: 101...150),
		AQICategory(name: "Unhealthy", color: convertColor(rgb: 0xff0000), range: 151...200),
		AQICategory(name: "Very Unhealthy", color: convertColor(rgb: 0x8f3f97), range: 201...300),
		AQICategory(name: "Hazardous", color: convertColor(rgb: 0x7e0023), range: 301...500),
	]
	
	private static func convertColor(rgb: Int32) -> CGColor {
		return CGColor(red: CGFloat(rgb >> 16) / 255.0, green: CGFloat((rgb >> 8) & 0xFF) / 255.0, blue: CGFloat(rgb & 0xFF) / 255.0, alpha: 1.0)
	}
}
