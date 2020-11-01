//
//  SwiftUIView.swift
//  
//
//  Created by Thomas Willson on 2020-10-24.
//

import SwiftUI

public struct SimpleConfigView: View {
	@ObservedObject var viewModel : ViewModel
	
	public init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}
	
    public var body: some View {
		Group() {
			Spacer()
			HStack() {
				Spacer()
				TextField("Zip Code", text: $viewModel.zipCode)
				Button("􀋒", action: { self.viewModel.useCurrentLocation() })
				Spacer()
			}
			Spacer()
			Group {
				if let observation = self.viewModel.observation {
					Text("AQI \(observation.aqiValue)")
					Text("Observation From: \(observation.validDate.toString())")
					
					if let refreshTime = self.viewModel.observationsRefreshed {
						Text("Loaded from Server: \(refreshTime.toString())")
					}
				} else if !self.viewModel.zipCode.isEmpty {
					Text("No observation for \(self.viewModel.zipCode)")
				}
			}
		}
    }
}

struct SimpleConfigView_Previews: PreviewProvider {
	static var viewModel : ViewModel {
		let vm = ViewModel(settingsStore: DefaultsSettingsStore())
		vm.zipCode = "95136"
		return vm
	}
	
    static var previews: some View {
        SimpleConfigView(viewModel: viewModel)
    }
}
