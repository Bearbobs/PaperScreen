import SwiftUI

/// Simple UI to add/remove bundle identifiers for which the overlay should be disabled.
struct AppExclusionEditor: View {
    @Binding var excludedBundleIdentifiers: Set<String>

    @State private var newBundleID: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Disable overlay for apps:")
                .font(.subheadline)

            if excludedBundleIdentifiers.isEmpty {
                Text("No apps excluded.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(Array(excludedBundleIdentifiers).sorted(), id: \.self) { id in
                    HStack {
                        Text(id)
                            .font(.system(.body, design: .monospaced))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Spacer()
                        Button(role: .destructive) {
                            excludedBundleIdentifiers.remove(id)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            HStack {
                TextField("com.example.App", text: $newBundleID)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    let trimmed = newBundleID.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    excludedBundleIdentifiers.insert(trimmed)
                    newBundleID = ""
                }
                .disabled(newBundleID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview {
    AppExclusionEditor(excludedBundleIdentifiers: .constant(["com.apple.Safari"]))
        .padding()
        .frame(width: 400)
}
