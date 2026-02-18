import SwiftUI

struct OnboardingPortsView: View {
    @ObservedObject var viewModel: TripSetupViewModel
    @State private var showImport = false
    @State private var newPortName = ""
    @State private var newPortDate: Date = .now

    var body: some View {
        SSOnboardingPage(step: 3, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssSunrise.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssSunrise)
                }

                Text("Your ports")
                    .ssOnboardingTitle()

                Text("Add your port stops. Times can be\nadded later when you have them.")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.md)

            // Quick-add row
            HStack(spacing: SSSpacing.sm) {
                TextField("Port name", text: $newPortName)
                    .font(.ssBody)
                    .foregroundStyle(.white)
                    .padding(.horizontal, SSSpacing.md)
                    .padding(.vertical, 12)
                    .background(Color.ssGlass)
                    .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
                    .overlay {
                        RoundedRectangle(cornerRadius: SSRadius.md)
                            .stroke(Color.ssGlassBorder, lineWidth: 1)
                    }

                Button {
                    guard !newPortName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.addPort(name: newPortName.trimmingCharacters(in: .whitespaces))
                        newPortName = ""
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.ssCoral)
                }
                .buttonStyle(.plain)
            }

            // Import button
            Button {
                withAnimation { showImport.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 14, weight: .medium))
                    Text("Paste itinerary")
                        .font(.ssBodySmall)
                        .fontWeight(.medium)
                }
                .foregroundStyle(Color.ssSea)
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)

            // Import area (expanded)
            if showImport {
                VStack(spacing: SSSpacing.sm) {
                    Text("Paste your itinerary text below. We'll extract port names.")
                        .font(.ssCaptionSmall)
                        .foregroundStyle(Color.ssTextMuted)
                        .multilineTextAlignment(.center)

                    TextEditor(text: $viewModel.importText)
                        .font(.ssBodySmall)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .frame(height: 100)
                        .padding(SSSpacing.sm)
                        .background(Color.ssGlass)
                        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
                        .overlay {
                            RoundedRectangle(cornerRadius: SSRadius.md)
                                .stroke(Color.ssGlassBorder, lineWidth: 1)
                        }

                    SSButton(title: "Import ports", style: .glass, icon: "arrow.down.doc", isCompact: true) {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.parseImportedItinerary()
                            showImport = false
                            viewModel.importText = ""
                        }
                    }
                    .frame(maxWidth: 200)
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            // Port list
            if !viewModel.ports.isEmpty {
                ScrollView {
                    VStack(spacing: SSSpacing.xs) {
                        ForEach(Array(viewModel.ports.enumerated()), id: \.element.id) { index, port in
                            PortRow(port: port, onDelete: {
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.removePort(at: index)
                                }
                            })
                        }
                    }
                }
                .frame(maxHeight: 200)
            }

            if viewModel.ports.isEmpty {
                SSGlassCard(padding: SSSpacing.md) {
                    HStack(spacing: SSSpacing.sm) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(Color.ssSea)
                        Text("No ports added yet. Add at least one port, or skip and add them later.")
                            .font(.ssCaptionSmall)
                            .foregroundStyle(Color.ssTextMuted)
                    }
                }
            }

            Spacer()

            SSOnboardingNav(
                backLabel: "Back",
                nextLabel: viewModel.ports.isEmpty ? "Skip" : "Next",
                onBack: { viewModel.back() },
                onNext: { viewModel.next() }
            )
        }
    }
}

// MARK: - Port Row

private struct PortRow: View {
    let port: Port
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: SSSpacing.sm) {
            Image(systemName: port.mode == .tender ? "ferry" : "mappin.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.ssSea)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(port.name)
                    .font(.ssBodyMedium)
                    .foregroundStyle(.white)

                HStack(spacing: SSSpacing.xs) {
                    Text(port.displayDate)
                        .font(.ssCaptionSmall)
                        .foregroundStyle(Color.ssTextMuted)

                    if !port.hasRequiredTimes {
                        Text("Times TBD")
                            .font(.ssCaptionSmall)
                            .foregroundStyle(Color.ssSunrise.opacity(0.8))
                    }
                }
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.ssTextMuted.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, SSSpacing.md)
        .padding(.vertical, 10)
        .background(Color.ssGlass)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.md)
                .stroke(Color.ssGlassBorder, lineWidth: 1)
        }
    }
}
