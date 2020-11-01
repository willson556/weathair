//
//  SwiftUIView.swift
//  
//
//  Created by Thomas Willson on 2020-10-31.
//

import SwiftUI

fileprivate let totalDegrees = 235.0
fileprivate let offset = 90.0 + (360.0 - totalDegrees) / 2.0
fileprivate let startDegrees = offset
fileprivate let endDegreees = totalDegrees + offset

fileprivate var minAQI: Int { AQIDefinitions.categories.min { (a, b) in a.range.lowerBound < b.range.lowerBound }!.range.lowerBound }
fileprivate var maxAQI: Int { AQIDefinitions.categories.max { (a, b) in a.range.upperBound > b.range.upperBound }!.range.upperBound }
fileprivate var aqiRange: Int { maxAQI - minAQI }

fileprivate func aqiToDegrees(_ aqi: Int) -> Double {
	Double(aqi) / Double(aqiRange) * (totalDegrees / 10) + offset
}

fileprivate extension AQICategory {
	var startAngle: Angle { Angle(degrees: aqiToDegrees(range.lowerBound) - (range.lowerBound == 0 ? 0 : 1)) }
	var endAngle: Angle { Angle(degrees: aqiToDegrees(range.upperBound)) }
}

fileprivate struct AQIGaugeSlice: View {
	var center: CGPoint
	var radius: CGFloat
	var category: AQICategory
	
	var path: Path {
		var path = Path()

		path.addArc(center: center, radius: radius * 0.75, startAngle: category.startAngle, endAngle: category.endAngle, clockwise: false)

		return path
	}
	
	public var body: some View {
		path.stroke(Color(NSColor(cgColor: category.color)!), lineWidth: radius / 2)
	}
}

fileprivate struct Needle: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: rect.width, y: rect.height / 2))
		path.addLine(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: 0, y: rect.height))
		return path
	}
}

struct AQIGauge: View {
	@Binding var primaryObservation: Observation
	@Binding var secondaryObservation: Observation
	
	private func calcDimensions(_ geometry: GeometryProxy) -> (center: CGPoint, radius: CGFloat) {
		let chartSize = min(geometry.size.width, geometry.size.height)
		let radius = chartSize / 2.5
		let centerX = geometry.frame(in: .local).standardized.width / 2
		let centerY = geometry.frame(in: .local).standardized.height / 2
		let center = CGPoint(x: centerX, y: centerY)
		
		return (center, radius)
	}
	
    var body: some View {
		GeometryReader { geometry in
			self.makeGauge(geometry)
		}
    }
	
	private func makeGauge(_ geometry: GeometryProxy) -> some View {
		let (center, radius) = calcDimensions(geometry)
		
		return ZStack {
			ForEach(0..<AQIDefinitions.categories.count, id: \.self) { index in
				AQIGaugeSlice(center: center, radius: radius, category: AQIDefinitions.categories[index])
			}
			
			makeCenterDot(center: center, radius: radius)
			makeBorder(center: center, radius: radius)
			drawNeedle(center: center, radius: radius)
		}
	}
	
	private func makeCenterDot(center: CGPoint, radius: CGFloat) -> some View {
		var path = Path()
		
		path.move(to: center)
		path.addArc(center: center, radius: radius * 0.1, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: false)
		
		return path.fill(Color.black)
	}
	
	private func drawNeedle(center: CGPoint, radius: CGFloat) -> some View {
		Needle()
			.fill(Color.black)
			.frame(width: radius*1.0, height: radius * 0.1)
			.offset(x: radius * 0.35, y: 0)
			.rotationEffect(.init(degrees: aqiToDegrees(primaryObservation.aqiValue)), anchor: .center)
			.animation(.linear)
	}
	
	private func makeBorder(center: CGPoint, radius: CGFloat) -> some View {
		var path = Path()
		path.addArc(center: center, radius: radius * 1.125, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: false)
		
		return path.stroke(Color.blue, lineWidth: radius * 0.1)
	}
}

struct AQIGauge_Previews: PreviewProvider {
	@State static var primaryObservation: Observation = Observation()
	@State static var secondaryObservation: Observation = Observation()
	
    static var previews: some View {
		Group {
			AQIGauge(primaryObservation: $primaryObservation, secondaryObservation: $secondaryObservation)
				.frame(width: 600, height: 300)
			AQIGauge(primaryObservation: $primaryObservation, secondaryObservation: $secondaryObservation)
				.frame(width: 100.0, height: 100.0)
			AQIGauge(primaryObservation: $primaryObservation, secondaryObservation: $secondaryObservation)
				.frame(width: 100.0, height: 300.0)
		}
    }
}
