import SwiftUI


extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}


@main
struct AccessibilityStrategyTestAppApp: App {

    var body: some Scene {
        WindowGroup {
            UITestsView()
        }
        .windowResizabilityContentSize()
    }
    
}

