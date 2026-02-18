import SwiftUI

struct HomeView: View {
    @ObservedObject var timerVM: TimerViewModel
    @EnvironmentObject var tripStore: TripStore
    @State private var showCreateTimer = false
    @State private var showPaywall = false
    @State private var showSettings = false
    @State private var showCrewInvites = false
    @State private var editingPort: Port? = nil

    private var trip: Trip? { tripStore.currentTrip }
    private var displayPort: Port? { tripStore.todayPort ?? tripStore.nextPort }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SSSpacing.lg) {
                    // Trip header
                    tripHeader

                    // Port day card (today or next)
                    if let port = displayPort {
                        portDayCard(port)
                    }

                    // Active timer banner
                    if let active = timerVM.activeTimer {
                        activeTimerBanner(active)
                    }

                    // Ports needing attention
                    if !tripStore.portsNeedingTimes.isEmpty {
                        portsNeedingTimesSection
                    }

                    // Main CTA
                    if timerVM.activeTimer == nil {
                        SSButton(title: "Start Port Timer", icon: "timer") {
                            if timerVM.purchaseTier == .none {
                                showPaywall = true
                            } else {
                                showCreateTimer = true
                            }
                        }
                    }

                    // Crew action
                    if timerVM.purchaseTier == .crew {
                        SSButton(title: "Manage Crew", style: .outline, icon: "person.3") {
                            showCrewInvites = true
                        }
                    }

                    // All ports overview
                    if let ports = trip?.ports, !ports.isEmpty {
                        allPortsSection(ports)
                    }

                    // Ship time info
                    shipTimeCard
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.vertical, SSSpacing.screenVertical)
            }
            .background(Color.ssSurface)
            .navigationTitle("ShoreSafe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.ssNavy.opacity(0.6))
                    }
                }
            }
            .sheet(isPresented: $showCreateTimer) {
                CreateTimerView(timerVM: timerVM)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(
                    currentTier: $timerVM.purchaseTier,
                    onPurchase: { tier in
                        timerVM.purchaseTier = tier
                        showPaywall = false
                        showCreateTimer = true
                    }
                )
            }
            .sheet(isPresented: $showCrewInvites) {
                CrewInvitesView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(item: $editingPort) { port in
                EditPortTimeSheet(port: port, tripStore: tripStore) {
                    editingPort = nil
                }
            }
        }
    }

    // MARK: - Trip Header

    private var tripHeader: some View {
        VStack(alignment: .leading, spacing: SSSpacing.sm) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    if let name = trip?.name, !name.isEmpty {
                        Text(name.uppercased())
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)
                    }

                    if let line = trip?.cruiseLine {
                        Text(line)
                            .font(.ssHeadline)
                            .foregroundStyle(Color.ssTextPrimary)
                    } else {
                        Text("My Cruise")
                            .font(.ssHeadline)
                            .foregroundStyle(Color.ssTextPrimary)
                    }
                }

                Spacer()

                if let config = trip?.shipTimeConfig, !config.isLocal {
                    SSBadge(text: config.displayLabel, color: .ssWarning)
                }
            }
        }
        .padding(SSSpacing.cardPadding)
        .background(Color.ssCard)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
        .shadow(color: SSShadow.card, radius: 12, x: 0, y: 4)
    }

    // MARK: - Port Day Card

    private func portDayCard(_ port: Port) -> some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    let isToday = port.date.map { Calendar.current.isDateInToday($0) } ?? false
                    Text(isToday ? "TODAY" : "NEXT PORT DAY")
                        .font(.ssOverline)
                        .foregroundStyle(.white.opacity(0.5))
                        .tracking(1.5)

                    Text(port.name)
                        .font(.ssDisplaySmall)
                        .foregroundStyle(.white)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: SSSpacing.xs) {
                    Text(port.displayDate)
                        .font(.ssBodySmall)
                        .foregroundStyle(.white.opacity(0.6))

                    SSBadge(
                        text: port.mode.rawValue,
                        color: port.mode == .tender ? .ssWarning : .ssSea
                    )
                }
            }
            .padding(SSSpacing.cardPadding)

            if let allAboard = port.allAboardTime {
                let buffer = port.customBufferMinutes ?? trip?.bufferPersona.dockBuffer ?? 60
                let beBackBy = allAboard.addingTimeInterval(-Double(buffer) * 60)

                HStack(spacing: 0) {
                    VStack(spacing: SSSpacing.xs) {
                        Text("ALL ABOARD")
                            .font(.ssOverline)
                            .foregroundStyle(.white.opacity(0.4))
                            .tracking(1)
                        Text(allAboard.formatted(date: .omitted, time: .shortened))
                            .font(.ssSubheadline)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)

                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 1, height: 36)

                    VStack(spacing: SSSpacing.xs) {
                        Text("BE BACK BY")
                            .font(.ssOverline)
                            .foregroundStyle(.white.opacity(0.4))
                            .tracking(1)
                        Text(beBackBy.formatted(date: .omitted, time: .shortened))
                            .font(.ssSubheadline)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)

                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 1, height: 36)

                    VStack(spacing: SSSpacing.xs) {
                        Text("BUFFER")
                            .font(.ssOverline)
                            .foregroundStyle(.white.opacity(0.4))
                            .tracking(1)
                        Text("\(buffer) min")
                            .font(.ssSubheadline)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, SSSpacing.md)
                .padding(.bottom, SSSpacing.cardPadding)
            } else {
                Button {
                    editingPort = port
                } label: {
                    HStack(spacing: SSSpacing.sm) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 16, weight: .medium))
                        Text("Add all-aboard time")
                            .font(.ssBodyMedium)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(Color.ssSunrise)
                    .padding(.horizontal, SSSpacing.cardPadding)
                    .padding(.vertical, 12)
                    .background(Color.ssSunrise.opacity(0.1))
                }
                .buttonStyle(.plain)
            }
        }
        .background(LinearGradient.ssOceanGradient)
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
    }

    // MARK: - Ports Needing Times

    private var portsNeedingTimesSection: some View {
        VStack(alignment: .leading, spacing: SSSpacing.sm) {
            HStack(spacing: SSSpacing.sm) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.ssSunrise)
                Text("PORTS NEED TIMES")
                    .font(.ssOverline)
                    .foregroundStyle(Color.ssTextMuted)
                    .tracking(1.5)
            }

            ForEach(tripStore.portsNeedingTimes) { port in
                Button {
                    editingPort = port
                } label: {
                    HStack(spacing: SSSpacing.sm) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.ssSunrise)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(port.name)
                                .font(.ssBodyMedium)
                                .foregroundStyle(Color.ssTextPrimary)
                            Text(port.displayDate)
                                .font(.ssCaptionSmall)
                                .foregroundStyle(Color.ssTextMuted)
                        }

                        Spacer()

                        Text("Add time")
                            .font(.ssChip)
                            .foregroundStyle(Color.ssCoral)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.ssTextMuted)
                    }
                    .padding(SSSpacing.md)
                    .background(Color.ssCard)
                    .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                    .shadow(color: SSShadow.card, radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Active Timer Banner

    private func activeTimerBanner(_ timer: PortTimer) -> some View {
        NavigationLink {
            ActiveTimerView(timerVM: timerVM)
        } label: {
            HStack(spacing: SSSpacing.md) {
                Circle()
                    .fill(Color.ssCoral)
                    .frame(width: 10, height: 10)
                    .overlay {
                        Circle()
                            .stroke(Color.ssCoral.opacity(0.4), lineWidth: 2)
                            .frame(width: 18, height: 18)
                    }

                VStack(alignment: .leading, spacing: SSSpacing.xs) {
                    Text("ACTIVE")
                        .font(.ssOverline)
                        .foregroundStyle(.white.opacity(0.6))
                        .tracking(1.5)
                    Text(timer.portName)
                        .font(.ssSubheadline)
                        .foregroundStyle(.white)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: SSSpacing.xs) {
                    Text("BE BACK BY")
                        .font(.ssOverline)
                        .foregroundStyle(.white.opacity(0.5))
                        .tracking(1)
                    Text(timer.beBackBy.formatted(date: .omitted, time: .shortened))
                        .font(.ssCountdownSmall)
                        .foregroundStyle(.white)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(SSSpacing.cardPadding)
            .background(LinearGradient.ssOceanGradient)
            .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
        }
    }

    // MARK: - All Ports

    private func allPortsSection(_ ports: [Port]) -> some View {
        VStack(alignment: .leading, spacing: SSSpacing.md) {
            Text("YOUR ITINERARY")
                .font(.ssOverline)
                .foregroundStyle(Color.ssTextMuted)
                .tracking(1.5)

            ForEach(ports) { port in
                HStack(spacing: SSSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(port.hasRequiredTimes ? Color.ssSea.opacity(0.1) : Color.ssSunrise.opacity(0.1))
                            .frame(width: 40, height: 40)
                        Image(systemName: port.mode == .tender ? "ferry" : "mappin.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(port.hasRequiredTimes ? Color.ssSea : Color.ssSunrise)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(port.name)
                            .font(.ssBodyMedium)
                            .foregroundStyle(Color.ssTextPrimary)
                        HStack(spacing: SSSpacing.xs) {
                            Text(port.displayDate)
                            if let time = port.allAboardTime {
                                Text("\u{00B7}")
                                Text("All aboard \(time.formatted(date: .omitted, time: .shortened))")
                            }
                        }
                        .font(.ssBodySmall)
                        .foregroundStyle(Color.ssTextSecondary)
                    }

                    Spacer()

                    if !port.hasRequiredTimes {
                        Button {
                            editingPort = port
                        } label: {
                            Text("Add")
                                .font(.ssChip)
                                .foregroundStyle(Color.ssCoral)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.ssCoral.opacity(0.08))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.ssSuccess)
                            .font(.system(size: 16))
                    }
                }
                .padding(SSSpacing.md)
                .background(Color.ssCard)
                .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                .shadow(color: SSShadow.card, radius: 6, x: 0, y: 2)
            }
        }
    }

    // MARK: - Ship Time Card

    private var shipTimeCard: some View {
        HStack(spacing: SSSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.ssWarning.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: "clock.badge.exclamationmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.ssWarning)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Ship Time Reminder")
                    .font(.ssBodyMedium)
                    .foregroundStyle(Color.ssTextPrimary)
                if let config = trip?.shipTimeConfig, !config.isLocal {
                    Text("Ship is \(config.displayLabel). All countdowns account for this offset.")
                        .font(.ssBodySmall)
                        .foregroundStyle(Color.ssTextSecondary)
                } else {
                    Text("Ship time matches local time. All-aboard is always in ship time.")
                        .font(.ssBodySmall)
                        .foregroundStyle(Color.ssTextSecondary)
                }
            }
        }
        .padding(SSSpacing.cardPadding)
        .background(Color.ssWarning.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: SSRadius.xl))
        .overlay {
            RoundedRectangle(cornerRadius: SSRadius.xl)
                .stroke(Color.ssWarning.opacity(0.15), lineWidth: 1)
        }
    }
}

// MARK: - Edit Port Time Sheet

struct EditPortTimeSheet: View {
    @State var port: Port
    @ObservedObject var tripStore: TripStore
    let onDismiss: () -> Void
    @State private var allAboardTime = Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: .now) ?? .now
    @State private var hasLastTender = false
    @State private var lastTenderTime = Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: .now) ?? .now
    @State private var portMode: PortMode = .dock

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SSSpacing.lg) {
                    VStack(spacing: SSSpacing.sm) {
                        Text(port.name)
                            .font(.ssHeadline)
                            .foregroundStyle(Color.ssTextPrimary)
                        Text(port.displayDate)
                            .font(.ssBody)
                            .foregroundStyle(Color.ssTextSecondary)
                    }
                    .padding(.top, SSSpacing.lg)

                    // Port mode
                    VStack(alignment: .leading, spacing: SSSpacing.sm) {
                        Text("PORT TYPE")
                            .font(.ssOverline)
                            .foregroundStyle(Color.ssTextMuted)
                            .tracking(1.5)

                        HStack(spacing: SSSpacing.sm) {
                            ForEach(PortMode.allCases) { mode in
                                Button {
                                    withAnimation { portMode = mode }
                                } label: {
                                    VStack(spacing: SSSpacing.xs) {
                                        Image(systemName: mode.icon)
                                            .font(.system(size: 20, weight: .medium))
                                        Text(mode.rawValue)
                                            .font(.ssChip)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, SSSpacing.md)
                                    .foregroundStyle(portMode == mode ? Color.ssCoral : Color.ssTextPrimary)
                                    .background(portMode == mode ? Color.ssCoral.opacity(0.08) : Color.ssSurface)
                                    .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: SSRadius.lg)
                                            .stroke(portMode == mode ? Color.ssCoral : Color.ssNavy.opacity(0.08), lineWidth: 1)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // All aboard time
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
                            selection: $allAboardTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(height: 120)
                    }

                    // Last tender
                    if portMode == .tender {
                        VStack(alignment: .leading, spacing: SSSpacing.sm) {
                            Toggle(isOn: $hasLastTender.animation()) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Last Tender Back")
                                        .font(.ssBodyMedium)
                                    Text("If your ship posted a last-tender time")
                                        .font(.ssCaptionSmall)
                                        .foregroundStyle(Color.ssTextSecondary)
                                }
                            }
                            .tint(Color.ssCoral)

                            if hasLastTender {
                                DatePicker(
                                    "Last tender",
                                    selection: $lastTenderTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .frame(height: 120)
                            }
                        }
                        .padding(SSSpacing.md)
                        .background(Color.ssWarning.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: SSRadius.lg))
                    }

                    SSButton(title: "Save", icon: "checkmark") {
                        var updated = port
                        updated.allAboardTime = allAboardTime
                        updated.mode = portMode
                        updated.lastTenderTime = (portMode == .tender && hasLastTender) ? lastTenderTime : nil
                        tripStore.updatePort(updated)
                        onDismiss()
                    }
                }
                .padding(.horizontal, SSSpacing.screenHorizontal)
                .padding(.bottom, SSSpacing.xxl)
            }
            .background(Color.ssSurface)
            .navigationTitle("Set Port Times")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .foregroundStyle(Color.ssTextSecondary)
                }
            }
        }
        .onAppear {
            portMode = port.mode
            if let t = port.allAboardTime { allAboardTime = t }
            if let t = port.lastTenderTime {
                hasLastTender = true
                lastTenderTime = t
            }
        }
    }
}
