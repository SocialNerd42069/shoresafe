import SwiftUI

struct PaywallView: View {
    @Binding var currentTier: PurchaseTier
    let onPurchase: (PurchaseTier) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTier: PurchaseTier = .solo

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SSSpacing.lg) {
                    // Hero
                    VStack(spacing: SSSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.ssCoral.opacity(0.2), Color.clear],
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 70
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .blur(radius: 10)

                            Image(systemName: "sun.and.horizon.fill")
                                .font(.system(size: 44, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.ssCoral, .ssSunrise],
                                        startPoint: .bottomLeading,
                                        endPoint: .topTrailing
                                    )
                                )
                        }

                        Text("Unlock ShoreSafe")
                            .font(.ssDisplayMedium)
                            .foregroundStyle(Color.ssTextPrimary)

                        Text("One purchase per cruise. No subscriptions.\nWorks offline, always.")
                            .font(.ssBody)
                            .foregroundStyle(Color.ssTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                    .padding(.top, SSSpacing.xl)

                    // Tier cards
                    VStack(spacing: SSSpacing.md) {
                        TierCard(
                            title: "Solo Cruise Pass",
                            price: "$4.99",
                            features: [
                                "Ship-time countdown",
                                "Dock & tender mode",
                                "Escalating port-day alerts",
                                "Fully offline",
                            ],
                            isSelected: selectedTier == .solo,
                            isBestValue: false
                        ) {
                            selectedTier = .solo
                        }

                        TierCard(
                            title: "Crew Pass",
                            price: "$10.99",
                            features: [
                                "Everything in Solo, plus:",
                                "Invite up to 3 travel companions",
                                "Everyone gets synced alerts",
                                "Share via link or QR",
                            ],
                            isSelected: selectedTier == .crew,
                            isBestValue: true
                        ) {
                            selectedTier = .crew
                        }
                    }

                    // Value props
                    VStack(spacing: SSSpacing.md) {
                        ValuePropRow(icon: "wifi.slash", text: "Works without Wi-Fi or data")
                        ValuePropRow(icon: "clock.badge.checkmark", text: "Ship-time clarity built in")
                        ValuePropRow(icon: "ferry", text: "Tender-port buffer mode")
                        ValuePropRow(icon: "bell.badge", text: "Escalating alerts you control")
                    }
                    .padding(.vertical, SSSpacing.sm)

                    // Purchase button
                    SSButton(
                        title: selectedTier == .solo ? "Get Solo Pass \u{2014} $4.99" : "Get Crew Pass \u{2014} $10.99",
                        icon: "lock.open"
                    ) {
                        onPurchase(selectedTier)
                    }

                    // Restore
                    Button {
                        // Placeholder
                    } label: {
                        Text("Restore purchase")
                            .font(.ssBodySmall)
                            .foregroundStyle(Color.ssTextMuted)
                    }

                    Text("7-day access per cruise. No auto-renewal.")
                        .font(.ssCaptionSmall)
                        .foregroundStyle(Color.ssTextMuted)
                        .padding(.bottom, SSSpacing.lg)
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
            }
            .background(Color.ssSurface)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.ssTextMuted.opacity(0.5))
                    }
                }
            }
        }
    }
}

// MARK: - Tier Card

private struct TierCard: View {
    let title: String
    let price: String
    let features: [String]
    let isSelected: Bool
    let isBestValue: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: SSSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: SSSpacing.xs) {
                        if isBestValue {
                            Text("BEST VALUE")
                                .font(.ssOverline)
                                .foregroundStyle(Color.ssCoral)
                                .tracking(1.5)
                        }
                        Text(title)
                            .font(.ssHeadline)
                            .foregroundStyle(Color.ssTextPrimary)
                    }

                    Spacer()

                    Text(price)
                        .font(.ssDisplayMedium)
                        .foregroundStyle(isSelected ? Color.ssCoral : Color.ssTextPrimary)
                }

                Rectangle()
                    .fill(Color.ssNavy.opacity(0.06))
                    .frame(height: 1)

                ForEach(features, id: \.self) { feature in
                    HStack(spacing: SSSpacing.sm) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.ssSuccess)
                        Text(feature)
                            .font(.ssBody)
                            .foregroundStyle(Color.ssTextSecondary)
                    }
                }
            }
            .padding(SSSpacing.cardPadding)
            .background(Color.ssCard)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
            .overlay {
                RoundedRectangle(cornerRadius: SSRadius.xl)
                    .stroke(
                        isSelected ? Color.ssCoral : Color.ssNavy.opacity(0.06),
                        lineWidth: isSelected ? 2 : 1
                    )
            }
            .shadow(color: isSelected ? SSShadow.glow : SSShadow.card, radius: isSelected ? 16 : 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Value Prop Row

private struct ValuePropRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: SSSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.ssSea.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.ssSea)
            }
            Text(text)
                .font(.ssBody)
                .foregroundStyle(Color.ssTextPrimary)
            Spacer()
        }
    }
}
