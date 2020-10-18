//
//  AppDelegate.swift
//  WeathAir-macOS
//
//  Created by Thomas Willson on 2020-10-04.
//

import Cocoa
import SwiftUI
import WeathAirShared

class CXETextLayer : CATextLayer {
	override init() {
		super.init()
	}
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(layer: aDecoder)
	}
	
	override func draw(in ctx: CGContext) {
		let height = self.bounds.size.height
		let fontSize = self.fontSize
		let yDiff = (height-fontSize)/2 - fontSize/10
		
		ctx.saveGState()
		ctx.translateBy(x: 0.0, y: yDiff)
		super.draw(in: ctx)
		ctx.restoreGState()
	}
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
	
	var window: NSWindow!
	var popover: NSPopover!
	var statusBarItem: NSStatusItem!
	var sub : Any?
	var caLayer: CALayer?
	var textLayer: CATextLayer?
	var systemColorToken: NSKeyValueObservation?
	
	@State var observation: Observation?
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let viewModel = ViewModel()
		let contentView = ContentView(viewModel)
		
		let popover = NSPopover()
		popover.contentSize = NSSize(width: 200, height: 100)
		popover.behavior = .transient
		popover.contentViewController = NSHostingController(rootView: contentView)
		popover.delegate = self
		self.popover = popover
		
		self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		let button = self.statusBarItem.button!
		button.action = #selector(togglePopover(_:))
		button.layerUsesCoreImageFilters = true
		button.title = " WeathAir "
		
		let layer = CALayer()
		layer.contentsGravity = CALayerContentsGravity.resizeAspectFill
		
		button.layer = layer
		
		textLayer = CXETextLayer()
		textLayer!.cornerRadius = 10.0
		textLayer!.masksToBounds = true
		textLayer!.backgroundColor = NSColor.controlAccentColor.cgColor
		textLayer!.borderWidth = 3.0
		textLayer!.string = "WeathAir"
		textLayer!.frame = layer.bounds
		textLayer!.fontSize = 12.0
		textLayer!.foregroundColor = NSColor.black.cgColor
		textLayer!.font = NSFont.systemFont(ofSize: 12.0, weight: .bold)
		textLayer!.alignmentMode = .center

		updateMenuItemColors(popoverShown: false)
		
		layer.addSublayer(textLayer!)
		self.caLayer = layer
		
		sub = contentView.viewModel
			.objectWillChange
			.receive(on: DispatchQueue.main)
			.sink { () in
				if let observation = contentView.viewModel.observation {
					button.title = " AQI \(observation.aqiValue ?? -1) " // Text has padding to make the button bigger
					self.textLayer!.backgroundColor = observation.color
				} else {
					button.title = " WeathAir "
					self.textLayer!.backgroundColor = self.getClearBackgroundColor()
				}
				
				self.textLayer!.frame = button.frame
				self.textLayer!.string = button.title.trimmingCharacters(in: .whitespaces)
			}
		
		systemColorToken = NSApp.observe(\.effectiveAppearance) { (app, value) in
			self.systemColorsChanged()
		}
	}
	
	@objc func togglePopover(_ sender: AnyObject?) {
		if let button = self.statusBarItem.button {
			if self.popover.isShown {
				self.popover.performClose(sender)
			} else {
				updateMenuItemColors(popoverShown: true)
				self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
			}
		}
	}
	
	func isDarkMode() -> Bool {
		return NSApp.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
	}
	
	func systemColorsChanged() {
		updateMenuItemColors(popoverShown: popover.isShown)
	}
	
	func updateMenuItemColors(popoverShown: Bool) {
		if popoverShown {
			let color = NSColor.selectedMenuItemColor.cgColor
			self.textLayer?.borderColor = color
			self.caLayer?.backgroundColor = color
		} else {
			self.caLayer?.backgroundColor = NSColor.clear.cgColor
			self.textLayer?.borderColor = getClearBackgroundColor()
		}
	}
	
	func getClearBackgroundColor() -> CGColor {
		return isDarkMode() ? NSColor.black.cgColor : NSColor.white.cgColor
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		systemColorToken?.invalidate()
	}
	
	func popoverWillClose(_ notification: Notification) {
		updateMenuItemColors(popoverShown: false)
	}
	
}
