import SwiftUI


struct UITestsView: View {

    @State var textFieldValue = ""
    @State var textViewValue = ""

    var body: some View {
        VStack {
            TextField("single line text field for test", text: $textFieldValue)
                .focusable(false)
            TextEditor(text: $textViewValue)
                .focusable(false)

            Button("wo'hevah", action: {})
        }
        .font(.system(size: 16, weight: .regular, design: .monospaced))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

}


struct UITestsView_Previews: PreviewProvider {
    static var previews: some View {
        UITestsView()
    }
}
