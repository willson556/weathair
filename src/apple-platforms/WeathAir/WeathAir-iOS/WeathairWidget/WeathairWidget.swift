//
//  WeathairWidget.swift
//  WeathairWidget
//
//  Created by Thomas Willson on 2020-10-24.
//

import WidgetKit
import SwiftUI
import Intents
import WeathAirShared

struct Provider: IntentTimelineProvider {
	let api = ObservationAPIService()
	
	func placeholder(in context: Context) -> AQIEntry {
		AQIEntry(date: Date(), observation: Observation(), configuration: ConfigurationIntent())
	}
	
	func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (AQIEntry) -> ()) {
		if let zipCodeString = configuration.ZipCode, let zipCode = Int(zipCodeString) {
			api.getObservationsForZipCode(zipCode: zipCode) { (error, observations) in
				guard let observations = observations else {
					print(error!)
					return
				}
				
				let observation = observations.first(where: {o in o.type == "O" && o.primaryPollutant})
				completion(AQIEntry(date: observation!.validDate, observation: observation!, configuration: configuration))
			}
		} else {
			let entry = AQIEntry(date: Date(), observation: Observation() , configuration: configuration)
			completion(entry)
		}
	}
	
	func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		getSnapshot(for: configuration, in: context) { (entry) in
			let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(byAdding: .minute, value: 30, to: Date())!))
			completion(timeline)
		}
	}
}

struct AQIEntry: TimelineEntry {
	let date: Date
	let observation: Observation
	let configuration: ConfigurationIntent
}

struct WeathairWidgetEntryView : View {
	var entry: Provider.Entry
	
	var body: some View {
		HStack {
			Spacer()
			VStack {
				Spacer()
				Text(entry.configuration.ZipCode ?? "")
				Text("AQI: \(entry.observation.aqiValue)")
				Spacer()
			}
			Spacer()
		}
		.padding()
		.background(ContainerRelativeShape().fill(Color(entry.observation.color)))
	}
}

@main
struct WeathairWidget: Widget {
	let kind: String = "WeathairWidget"
	
	var body: some WidgetConfiguration {
		IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
			WeathairWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("My Widget")
		.description("This is an example widget.")
	}
}

struct WeathairWidget_Previews: PreviewProvider {
	static var previews: some View {
		WeathairWidgetEntryView(entry: AQIEntry(date: Date(), observation: Observation(), configuration: ConfigurationIntent()))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}
