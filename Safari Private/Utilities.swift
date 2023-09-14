import SwiftUI


func openPrivateSafariWindow(with urls: [URL]) {
	runAppleScript(
		#"""
		tell application "Safari" to activate

		tell application "System Events" to tell its application process "Safari"
			set frontmost to true
			keystroke "n" using {shift down, command down}
		end tell

		tell application "Safari"
			delay 0.1
			\#(urls.map { #"open location "\#($0.absoluteString)""# }.joined(separator: "\n"))
		end tell
		"""#
	)
}


@discardableResult
func runAppleScript(_ source: String) -> String? {
	NSAppleScript(source: source)?.executeAndReturnError(nil).stringValue
}


enum Permissions {
	enum Accessibility {
		static var hasAccess: Bool { AXIsProcessTrusted() }

		static func requestAccess() -> Bool {
			AXIsProcessTrustedWithOptions([
				kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true
			] as CFDictionary)
		}
	}
}
