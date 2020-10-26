//
//  ContentView.swift
//  WeathAir-iOS
//
//  Created by Thomas Willson on 2020-10-04.
//

import SwiftUI
import WeathAirShared

struct ContentView: View {
	@ObservedObject var viewModel : ViewModel
	
	init(_ viewModel: ViewModel) {
		self.viewModel = viewModel
	}
	
	var body: some View {
		SimpleConfigView(viewModel: viewModel)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var viewModel : ViewModel {
		let vm = ViewModel(settingsStore: DefaultsSettingsStore())
		vm.zipCode = "95136"
		return vm
	}
	
    static var previews: some View {
        ContentView(viewModel)
    }
}
