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

//struct SVGImage: NSViewRepresentable {
//	var svgName: String
//
//	func makeNSView(context: Context) -> SVGView {
//		let svgView = SVGView()
//		svgView.backgroundColor = NSColor(white: 1.0, alpha: 0.0)   // otherwise the background is black
//		svgView.fileName = self.svgName
//		svgView.contentMode = .scaleToFill
//		return svgView
//	}
//
//	func updateNSView(_ uiView: SVGView, context: Context) {
//
//	}
//
//}

struct ContentView: View {
    @ObservedObject var viewModel : ViewModel
    
	init(_ viewModel: ViewModel) {
		self.viewModel = viewModel
    }
    
    var body: some View {
         VStack() {
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
		let vm = ViewModel()
		vm.zipCode = "95136"
		return vm
	}
		
    static var previews: some View {
		Group {
			ContentView(viewModel)
		
		}.frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
