//
//  AppDelegate.swift
//  WeathAir-macOS
//
//  Created by Thomas Willson on 2020-10-04.
//

import Cocoa
import SwiftUI
import WeathAirShared

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var sub : Any?
    
    @State var observation: Observation?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView()

        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 250, height: 100)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover

        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
            button.title = "AQI"
             button.action = #selector(togglePopover(_:))
            
            sub = contentView.viewModel
                .objectWillChange
                .receive(on: DispatchQueue.main)
                .sink { () in
                    if let observation = contentView.viewModel.observation {
                        button.title = "AQI: \(observation.aqiValue ?? -1)"
                    }
                }
        }
	}
    
    @objc func togglePopover(_ sender: AnyObject?) {
         if let button = self.statusBarItem.button {
              if self.popover.isShown {
                   self.popover.performClose(sender)
              } else {
                   self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
              }
         }
    }

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

