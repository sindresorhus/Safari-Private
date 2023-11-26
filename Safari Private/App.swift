import SwiftUI

@main
struct AppMain: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

	var body: some Scene {
		Settings {}
	}
}

private final class AppDelegate: NSObject, NSApplicationDelegate {
	var count: Int = 0

	func terminateIfNecessary() {
		if (count > 0) {
			count -= 1
			delay(seconds: 10) {
				self.terminateIfNecessary()
			}
		} else {
			NSApp.terminate(nil)
		}
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		_ = Permissions.Accessibility.requestAccess()

		count += 1
		terminateIfNecessary()
	}

	func application(_ application: NSApplication, open urls: [URL]) {
		guard Permissions.Accessibility.requestAccess() else {
			let alert = NSAlert()
			alert.messageText = "You need to allow Accessibility and Automation access in “System Preferences › Security & Privacy”."
			alert.runModal()
			NSApp.terminate(nil)
			return
		}

		count += 1
		openPrivateSafariWindow(with: urls)
		terminateIfNecessary()
	}
}
