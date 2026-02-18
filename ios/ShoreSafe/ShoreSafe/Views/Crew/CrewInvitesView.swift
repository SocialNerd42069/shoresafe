import SwiftUI

struct CrewInvitesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var crewMembers = CrewMember.mockCrew
    @State private var showShareSheet = false

    private var slotsRemaining: Int {
        max(0, 3 - crewMembers.filter { !$0.isHost }.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SSSpacing.lg) {
                    // Header
                    VStack(spacing: SSSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.ssSea.opacity(0.2), Color.clear],
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 50
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .blur(radius: 8)

                            Circle()
                                .fill(Color.ssSea.opacity(0.1))
                                .frame(width: 72, height: 72)
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundStyle(Color.ssSea)
                        }

                        Text("Your Crew")
                            .font(.ssHeadline)
                            .foregroundStyle(Color.ssTextPrimary)

                        Text("\(slotsRemaining) invite\(slotsRemaining == 1 ? "" : "s") remaining")
                            .font(.ssBody)
                            .foregroundStyle(Color.ssTextSecondary)
                    }
                    .padding(.top, SSSpacing.lg)

                    // Share section
                    VStack(spacing: SSSpacing.md) {
                        Text("SHARE YOUR CREW PASS")
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)

                        // QR placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: SSRadius.lg)
                                .fill(Color.ssSurface)
                                .frame(width: 180, height: 180)

                            VStack(spacing: SSSpacing.sm) {
                                Image(systemName: "qrcode")
                                    .font(.system(size: 72, weight: .light))
                                    .foregroundStyle(Color.ssNavy.opacity(0.8))
                                Text("Crew invite code")
                                    .font(.ssCaptionSmall)
                                    .foregroundStyle(Color.ssTextMuted)
                            }
                        }

                        HStack(spacing: SSSpacing.sm) {
                            SSButton(title: "Copy Link", style: .outline, icon: "link") {
                                // Placeholder
                            }
                            SSButton(title: "Share", icon: "square.and.arrow.up") {
                                showShareSheet = true
                            }
                        }
                    }
                    .padding(SSSpacing.cardPadding)
                    .background(Color.ssCard)
                    .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
                    .shadow(color: SSShadow.card, radius: 12, x: 0, y: 4)

                    // Crew list
                    VStack(alignment: .leading, spacing: SSSpacing.md) {
                        Text("CREW MEMBERS")
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)

                        ForEach(crewMembers) { member in
                            HStack(spacing: SSSpacing.md) {
                                ZStack {
                                    Circle()
                                        .fill(member.isHost ? Color.ssCoral.opacity(0.1) : Color.ssSea.opacity(0.1))
                                        .frame(width: 44, height: 44)
                                    Text(String(member.name.prefix(1)))
                                        .font(.ssSubheadline)
                                        .foregroundStyle(member.isHost ? Color.ssCoral : Color.ssSea)
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: SSSpacing.sm) {
                                        Text(member.name)
                                            .font(.ssBodyMedium)
                                            .foregroundStyle(Color.ssTextPrimary)
                                        if member.isHost {
                                            SSBadge(text: "Host", color: .ssCoral)
                                        }
                                    }
                                    Text("Joined \(member.joinedAt.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.ssCaptionSmall)
                                        .foregroundStyle(Color.ssTextMuted)
                                }

                                Spacer()
                            }
                            .padding(SSSpacing.md)
                            .background(Color.ssCard)
                            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                            .shadow(color: SSShadow.card, radius: 4, x: 0, y: 2)
                        }

                        // Empty slots
                        ForEach(0..<slotsRemaining, id: \.self) { _ in
                            HStack(spacing: SSSpacing.md) {
                                ZStack {
                                    Circle()
                                        .strokeBorder(Color.ssTextMuted.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Color.ssTextMuted)
                                }

                                Text("Open slot")
                                    .font(.ssBody)
                                    .foregroundStyle(Color.ssTextMuted)

                                Spacer()
                            }
                            .padding(SSSpacing.md)
                            .background(Color.ssSurface)
                            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                        }
                    }
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.bottom, SSSpacing.xxl)
            }
            .background(Color.ssSurface)
            .navigationTitle("Crew Pass")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.ssCoral)
                }
            }
        }
    }
}
