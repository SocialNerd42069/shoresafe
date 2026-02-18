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
                                .fill(Color.ssSea.opacity(0.15))
                                .frame(width: 80, height: 80)
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.ssSea)
                        }

                        Text("Your Crew")
                            .font(.ssHeadline)
                            .foregroundStyle(Color.ssTextPrimary)

                        Text("\(slotsRemaining) invite\(slotsRemaining == 1 ? "" : "s") remaining")
                            .font(.ssBody)
                            .foregroundStyle(Color.ssTextSecondary)
                    }
                    .padding(.top, SSSpacing.md)

                    // Invite link / QR
                    VStack(spacing: SSSpacing.md) {
                        Text("SHARE YOUR CREW PASS")
                            .font(.ssCaption)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1)

                        // QR placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: SSRadius.md)
                                .fill(Color.ssSurface)
                                .frame(width: 180, height: 180)

                            VStack(spacing: SSSpacing.sm) {
                                Image(systemName: "qrcode")
                                    .font(.system(size: 80))
                                    .foregroundStyle(Color.ssNavy)
                                Text("Crew invite code")
                                    .font(.ssCaptionSmall)
                                    .foregroundStyle(Color.ssTextMuted)
                            }
                        }

                        HStack(spacing: SSSpacing.md) {
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
                    .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                    .shadow(color: SSShadow.card, radius: 8, x: 0, y: 2)

                    // Crew list
                    VStack(alignment: .leading, spacing: SSSpacing.md) {
                        Text("CREW MEMBERS")
                            .font(.ssCaption)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1)

                        ForEach(crewMembers) { member in
                            HStack(spacing: SSSpacing.md) {
                                ZStack {
                                    Circle()
                                        .fill(member.isHost ? Color.ssCoral.opacity(0.15) : Color.ssSea.opacity(0.15))
                                        .frame(width: 40, height: 40)
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
                            .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
                        }

                        // Empty slots
                        ForEach(0..<slotsRemaining, id: \.self) { _ in
                            HStack(spacing: SSSpacing.md) {
                                ZStack {
                                    Circle()
                                        .strokeBorder(Color.ssTextMuted.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "plus")
                                        .font(.caption)
                                        .foregroundStyle(Color.ssTextMuted)
                                }

                                Text("Open slot")
                                    .font(.ssBody)
                                    .foregroundStyle(Color.ssTextMuted)

                                Spacer()
                            }
                            .padding(SSSpacing.md)
                            .background(Color.ssSurface)
                            .clipShape(RoundedRectangle(cornerRadius: SSRadius.md))
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
                    .foregroundStyle(Color.ssCoral)
                }
            }
        }
    }
}
