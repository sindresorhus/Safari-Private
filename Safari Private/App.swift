import SwiftUI

@main
struct AppMain: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

	var body: some Scene {
		Settings {}
	}
}

private final class AppDelegate: NSObject, NSApplicationDelegate {
	private var task: Task<Void, Never>?

	func applicationDidFinishLaunching(_ notification: Notification) {
		_ = Permissions.Accessibility.requestAccess()
		scheduleQuit()
	}

	func application(_ application: NSApplication, open urls: [URL]) {
		guard Permissions.Accessibility.requestAccess() else {
			let alert = NSAlert()
			alert.messageText = "You need to allow Accessibility and Automation access in “System Settings › Privacy & Security”."
			alert.runModal()
			NSApp.terminate(nil)
			return
		}

		openPrivateSafariWindow(with: urls)
		scheduleQuit()
	}

	@MainActor
	private func scheduleQuit() {
		task?.cancel()

		task = Task {
			do {
				try await Task.sleep(for: .seconds(10))
				NSApp.terminate(nil)
			} catch {}
		}
	}
}
