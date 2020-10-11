//
//  ContentView.swift
//  WeathAir-macOS
//
//  Created by Thomas Willson on 2020-10-04.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : ViewModel
    
    init() {
        viewModel = ViewModel()
    }
    
    var body: some View {
        VStack() {
            TextField("Zip Code", text: Binding<String>(
                        get: {self.viewModel.zipCode},
                        set: { self.viewModel.zipCode = $0
                            self.viewModel.loadData()}))
            Group {
                if let observation = self.viewModel.observation {
                    Text("AQI: \(observation.aqiValue)")
                } else {
                    Text("No observation for \(self.viewModel.zipCode)")
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
