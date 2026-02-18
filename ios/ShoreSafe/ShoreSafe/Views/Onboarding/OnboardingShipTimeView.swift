import SwiftUI

struct OnboardingShipTimeView: View {
    @ObservedObject var viewModel: TripSetupViewModel
    @State private var showExplainer = false

    var body: some View {
        SSOnboardingPage(step: 2, totalSteps: viewModel.totalSteps) {
            VStack(spacing: SSSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.ssWarning.opacity(0.12))
                        .frame(width: 72, height: 72)
                    Image(systemName: "clock.badge.exclamationmark")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(Color.ssWarning)
                }

                Text("Ship time setup")
                    .ssOnboardingTitle()
                    .multilineTextAlignment(.center)

                Text("Does the ship follow a different\ntime than your phone at port?")
                    .ssOnboardingBody()
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: SSSpacing.lg)

            // Option A: Same time
            VStack(spacing: SSSpacing.sm) {
                ShipTimeOptionCard(
                    title: "Ship time = local time",
                    subtitle: "Most common. The ship adjusts clocks to match each port.",
                    icon: "checkmark.circle",
                    isSelected: viewModel.offsetHours == 0
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.offsetHours = 0
                    }
                }

                ShipTimeOptionCard(
                    title: "Ship time differs",
                    subtitle: "The ship keeps a fixed time zone that doesn't match the port.",
                    icon: "clock.arrow.2.circlepath",
                    isSelected: viewModel.offsetHours != 0
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        if viewModel.offsetHours == 0 {
                            viewModel.offsetHours = 1
                        }
                    }
                }
            }

            // Offset picker (shown when "differs")
            if viewModel.offsetHours != 0 {
                SSGlassCard(padding: SSSpacing.md) {
                    VStack(spacing: SSSpacing.sm) {
                        Text("SHIP TIME OFFSET")
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)

                        HStack {
                            Text("Ship is")
                                .font(.ssBody)
                                .foregroundStyle(.white.opacity(0.7))

                            Picker("Hours", selection: $viewModel.offsetHours) {
                                ForEach(-12...12, id: \.self) { h in
                                    if h != 0 {
                                        Text(h > 0 ? "+\(h)h" : "\(h)h")
                                            .tag(h)
                                    }
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100, height: 100)
                            .clipped()

                            Text("from phone")
                                .font(.ssBody)
                                .foregroundStyle(.white.opacity(0.7))
                        }

                        Text("Example: If ship says 5 PM but your phone says 4 PM, set +1h")
                            .font(.ssCaptionSmall)
                            .foregroundStyle(Color.ssSunrise.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            // Explainer toggle
            Button {
                withAnimation { showExplainer.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 14))
                    Text("What is ship time?")
                        .font(.ssBodySmall)
                }
                .foregroundStyle(Color.ssSea)
            }
            .buttonStyle(.plain)
            .padding(.top, SSSpacing.sm)

            if showExplainer {
                SSGlassCard(padding: SSSpacing.md) {
                    VStack(alignment: .leading, spacing: SSSpacing.sm) {
                        Text("Cruise ships set their own clocks. At some ports, your phone auto-adjusts to local time but the ship doesn't change.")
                            .font(.ssBodySmall)
                            .foregroundStyle(.white.opacity(0.7))
                        Text("If ship says all-aboard at 4:30 PM but your phone shows 3:30 PM, you might think you have an extra hour.")
                            .font(.ssBodySmall)
                            .foregroundStyle(Color.ssSunrise)
                        Text("ShoreSafe adjusts for this so your countdown is always correct.")
                            .font(.ssBodySmall)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Spacer()

            SSOnboardingNav(
                backLabel: "Back",
                nextLabel: "Next",
                onBack: { viewModel.back() },
                onNext: { viewModel.next() }
            )
        }
    }
}

// MARK: - Ship Time Option Card

private struct ShipTimeOptionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: SSSpacing.md) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.ssCoral.opacity(0.15) : Color.ssGlass)
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted)
                }

                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    Text(title)
                        .font(.ssSubheadline)
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.ssCaptionSmall)
                        .foregroundStyle(Color.ssTextMuted)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextMuted.opacity(0.4))
                    .font(.title3)
            }
            .padding(SSSpacing.md)
            .background(isSelected ? Color.ssCoral.opacity(0.08) : Color.ssGlass)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: SSRadius.lg)
                    .stroke(isSelected ? Color.ssCoral.opacity(0.4) : Color.ssGlassBorder, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}
