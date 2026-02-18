import SwiftUI

struct CreateTimerView: View {
    @ObservedObject var timerVM: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SSSpacing.lg) {
                    // Port name
                    VStack(alignment: .leading, spacing: SSSpacing.sm) {
                        Text("PORT NAME")
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)

                        TextField("e.g. Cozumel", text: $timerVM.portName)
                            .font(.ssBody)
                            .padding(SSSpacing.md)
                            .background(Color.ssSurface)
                            .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                            .overlay {
                                RoundedRectangle(cornerRadius: SSRadius.lg)
                                    .stroke(Color.ssNavy.opacity(0.08), lineWidth: 1)
                            }
                    }

                    // All Aboard Time
                    VStack(alignment: .leading, spacing: SSSpacing.sm) {
                        HStack {
                            Text("ALL ABOARD TIME")
                                .font(.ssOverline)
                                .foregroundStyle(Color.ssTextMuted)
                                .tracking(1.5)
                            Spacer()
                            SSBadge(text: "Ship Time", color: .ssSea)
                        }

                        DatePicker(
                            "All aboard",
                            selection: $timerVM.allAboardTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(height: 120)
                    }

                    // Port Mode
                    VStack(alignment: .leading, spacing: SSSpacing.sm) {
                        Text("PORT TYPE")
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)

                        HStack(spacing: SSSpacing.sm) {
                            ForEach(PortMode.allCases) { mode in
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        timerVM.portMode = mode
                                        timerVM.bufferMinutes = mode.defaultBuffer
                                    }
                                } label: {
                                    VStack(spacing: SSSpacing.sm) {
                                        ZStack {
                                            Circle()
                                                .fill(timerVM.portMode == mode ? Color.ssCoral.opacity(0.12) : Color.ssSurface)
                                                .frame(width: 48, height: 48)
                                            Image(systemName: mode.icon)
                                                .font(.system(size: 20, weight: .medium))
                                        }
                                        Text(mode.rawValue)
                                            .font(.ssSubheadline)
                                        Text(mode.description)
                                            .font(.ssCaptionSmall)
                                            .foregroundStyle(Color.ssTextSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, SSSpacing.md)
                                    .foregroundStyle(
                                        timerVM.portMode == mode ? Color.ssCoral : Color.ssTextPrimary
                                    )
                                    .background(Color.ssCard)
                                    .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: SSRadius.lg)
                                            .stroke(
                                                timerVM.portMode == mode ? Color.ssCoral : Color.ssNavy.opacity(0.08),
                                                lineWidth: timerVM.portMode == mode ? 1.5 : 1
                                            )
                                    }
                                    .shadow(color: timerVM.portMode == mode ? SSShadow.glow : .clear, radius: 8, x: 0, y: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Buffer
                    VStack(alignment: .leading, spacing: SSSpacing.sm) {
                        Text("BUFFER")
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)

                        HStack(spacing: SSSpacing.sm) {
                            ForEach(timerVM.bufferOptions, id: \.self) { minutes in
                                Button {
                                    withAnimation { timerVM.bufferMinutes = minutes }
                                } label: {
                                    SSChip(
                                        label: "\(minutes) min",
                                        isSelected: timerVM.bufferMinutes == minutes
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Last Tender (conditional)
                    if timerVM.portMode == .tender {
                        VStack(alignment: .leading, spacing: SSSpacing.sm) {
                            Toggle(isOn: $timerVM.hasLastTender.animation()) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Last Tender Back")
                                        .font(.ssBodyMedium)
                                    Text("If your ship posted a last-tender time")
                                        .font(.ssCaptionSmall)
                                        .foregroundStyle(Color.ssTextSecondary)
                                }
                            }
                            .tint(Color.ssCoral)

                            if timerVM.hasLastTender {
                                DatePicker(
                                    "Last tender",
                                    selection: $timerVM.lastTenderTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .frame(height: 120)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding(SSSpacing.md)
                        .background(Color.ssWarning.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                        .overlay {
                            RoundedRectangle(cornerRadius: SSRadius.lg)
                                .stroke(Color.ssWarning.opacity(0.15), lineWidth: 1)
                        }
                    }

                    Spacer().frame(height: SSSpacing.sm)

                    // Start button
                    SSButton(title: "Start Port Timer", icon: "play.fill") {
                        timerVM.createTimer()
                        dismiss()
                    }
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.vertical, SSSpacing.screenVertical)
            }
            .background(Color.ssCard)
            .navigationTitle("New Port Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.ssTextSecondary)
                }
            }
        }
    }
}
