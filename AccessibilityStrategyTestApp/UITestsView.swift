import SwiftUI
import WebKit


// shit hack to make TextEditor stop changing quotes to smart quotes
// and all the other text replacements that make the tests fail in GHA.
// there's currently no way to do this on TextEditor itself :dumb:
extension NSTextView {

    open override var frame: CGRect {
        didSet {
            self.font = NSFont.userFixedPitchFont(ofSize: 16)

            self.isAutomaticQuoteSubstitutionEnabled = false
            self.isAutomaticSpellingCorrectionEnabled = false
            self.isAutomaticDataDetectionEnabled = false
            self.isAutomaticLinkDetectionEnabled = false
            self.isAutomaticTextCompletionEnabled = false
            self.isAutomaticDashSubstitutionEnabled = false
            self.isAutomaticTextReplacementEnabled = false
        }
    }

}

// shit to create an HTML textarea so that we can test the PGR natively aww
struct WebView: NSViewRepresentable {

    @Binding var text: String

    func makeNSView(context: Context) -> some WKWebView {
        return WKWebView()
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.loadHTMLString(text, baseURL: nil)
    }

}


struct UITestsView: View {

    @State var textFieldValue = ""
    @State var textViewValue = ""
    @State var toggle = false
    @State var webViewValue = "<textarea rows=20 cols=60></textarea>"

    var body: some View {
        VStack {
            TextField("single line text field for test", text: $textFieldValue)
                .focusable(false)
                .disableAutocorrection(true)

            TextEditor(text: $textViewValue)
                .focusable(false)
                .disableAutocorrection(true)

            Toggle("wot", isOn: $toggle)
            Button("wo'hevah", action: { NSApp.keyWindow?.makeFirstResponder(nil)})
            WebView(text: $webViewValue)
        }
        .font(.system(size: 16, weight: .regular, design: .monospaced))
        .frame(width: 250, height: 500, alignment: .leading)
        .fixedSize(horizontal: true, vertical: true)
        .padding()
    }

}


struct UITestsView_Previews: PreviewProvider {
    static var previews: some View {
        UITestsView()
    }
}
