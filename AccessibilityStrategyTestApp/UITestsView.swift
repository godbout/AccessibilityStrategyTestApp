import SwiftUI


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


struct UITestsView: View {

    @State var textFieldValue = ""
    @State var textViewValue = ""

    var body: some View {
        VStack {
            TextField("single line text field for test", text: $textFieldValue)
                .focusable(false)
                .disableAutocorrection(true)
                
            TextEditor(text: $textViewValue)
                .focusable(false)
                .disableAutocorrection(true)

            Button("wo'hevah", action: {})
        }
        .font(.system(size: 16, weight: .regular, design: .monospaced))
        .frame(width: 250, height: 300, alignment: .leading)
        .fixedSize(horizontal: true, vertical: true)
        .padding()
    }

}


struct UITestsView_Previews: PreviewProvider {
    static var previews: some View {
        UITestsView()
    }
}
