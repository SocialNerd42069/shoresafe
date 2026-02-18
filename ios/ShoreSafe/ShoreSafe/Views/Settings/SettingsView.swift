import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var defaultDockBuffer = 60
    @State private var defaultTenderBuffer = 90

    var body: some View {
        NavigationStack {
            List {
                // Defaults
                Section {
                    Stepper("Dock buffer: \(defaultDockBuffer) min", value: $defaultDockBuffer, in: 15...120, step: 15)
                    Stepper("Tender buffer: \(defaultTenderBuffer) min", value: $defaultTenderBuffer, in: 30...180, step: 15)
                } header: {
                    Text("Default Buffers")
                } footer: {
                    Text("Applied when you create a new port timer.")
                }

                // Help
                Section("Help") {
                    NavigationLink {
                        ShipTimeHelpView()
                    } label: {
                        Label("Ship time vs local time", systemImage: "clock.badge.exclamationmark")
                    }
                }

                // Purchase
                Section("Purchase") {
                    Button {
                        // Placeholder: restore purchases
                    } label: {
                        Label("Restore purchase", systemImage: "arrow.clockwise")
                    }
                }

                // About
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } footer: {
                    Text("ShoreSafe is a port-day alarm tool. Timing and schedules are your responsibility — we provide reminders, not guarantees.")
                        .font(.caption)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Ship Time Help

private struct ShipTimeHelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SSSpacing.lg) {
                Text("Ship Time vs Local Time")
                    .font(.ssHeadline)

                Text("When your cruise ship visits a port in a different time zone, your phone automatically adjusts to the local time — but the ship stays on its own schedule.")
                    .font(.ssBody)

                VStack(alignment: .leading, spacing: SSSpacing.md) {
                    InfoRow(icon: "ferry", title: "Ship time", detail: "The time displayed on the ship. All-aboard, meal times, and activities use ship time.")
                    InfoRow(icon: "iphone", title: "Your phone", detail: "Switches to the local time zone automatically. This can be 1–2 hours different from ship time.")
                    InfoRow(icon: "exclamationmark.triangle", title: "The risk", detail: "If your phone says 3:00 PM but ship time is 4:00 PM, you might think you have an extra hour — and miss the ship.")
                }

                Text("ShoreSafe always counts down in ship time so you stay aligned with the ship's schedule.")
                    .font(.ssBody)
                    .foregroundStyle(Color.ssTextSecondary)
            }
            .padding(SSSpacing.screenHorizontal)
        }
        .navigationTitle("Ship Time")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: SSSpacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.ssSea)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: SSSpacing.xs) {
                Text(title)
                    .font(.ssBodyMedium)
                Text(detail)
                    .font(.ssBodySmall)
                    .foregroundStyle(Color.ssTextSecondary)
            }
        }
    }
}
