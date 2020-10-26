//
//  ContentView.swift
//  WeathAir-macOS
//
//  Created by Thomas Willson on 2020-10-04.
//

//import Macaw
import AppKit
import SwiftUI
import WeathAirShared

struct ContentView: View {
    @ObservedObject var viewModel : ViewModel
    
	init(_ viewModel: ViewModel) {
		self.viewModel = viewModel
    }
    
    var body: some View {
         VStack() {
			SimpleConfigView(viewModel: viewModel)
			Spacer()
			VStack() {
				HStack() {
					Spacer()
					Button("Quit") {
						NSApp.terminate(self)
					}.padding(.trailing, 8)
				}
            }
			Spacer()
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	
	static var viewModel : ViewModel {
		let vm = ViewModel(settingsStore: DefaultsSettingsStore())
		vm.zipCode = "95136"
		return vm
	}
		
    static var previews: some View {
		Group {
			ContentView(viewModel)
		
		}.frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
