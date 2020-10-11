//
//  ContentView.swift
//  WeathAir-macOS
//
//  Created by Thomas Willson on 2020-10-04.
//

import SwiftUI
import WeathAirShared

struct ContentView: View {
    @ObservedObject var viewModel : ViewModel
    
    init() {
        viewModel = ViewModel()
    }
    
    var body: some View {
        HStack() {
            Spacer()
            VStack() {
                Spacer()
                HStack() {
                    TextField("Zip Code", text: Binding<String>(
                                get: {self.viewModel.zipCode},
                                set: { self.viewModel.zipCode = $0
                                    self.viewModel.loadData()}))
                    Button(action: { self.viewModel.useCurrentLocation() } , label: {
                        Image("location.fill").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    })
                }
                Spacer()
                Group {
                    if let observation = self.viewModel.observation {
                        Text("AQI: \(observation.aqiValue)")
                    } else {
                        Text("No observation for \(self.viewModel.zipCode)")
                    }
                }
                Spacer()
            }
            VStack(alignment: HorizontalAlignment.trailing, spacing: nil) {
                Button("Quit") {
                    NSApp.terminate(self)
                }
            }
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
