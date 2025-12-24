import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSubmit: () -> Void

    var body: some View {
        HStack {
            TextField("Search by parcel ID", text: $text, onCommit: onSubmit)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(10)
            Button(action: onSubmit) {
                Image(systemName: "magnifyingglass")
                    .padding(10)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(radius: 4)
        .frame(maxWidth: 400)
    }
}
