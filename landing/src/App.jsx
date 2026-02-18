function App() {
  return (
    <div className="bg-navy text-mist">
      <div className="relative overflow-hidden">
        <div className="pointer-events-none absolute -top-40 right-[-10%] h-[420px] w-[420px] animate-float rounded-full bg-coral/25 blur-[140px]" />
        <div className="pointer-events-none absolute top-24 -left-24 h-[320px] w-[320px] rounded-full bg-sand/10 blur-[120px]" />
        <div className="pointer-events-none absolute bottom-0 left-1/2 h-[280px] w-[520px] -translate-x-1/2 animate-float rounded-full bg-coral/15 blur-[160px]" />

        <header className="mx-auto flex w-full max-w-6xl items-center justify-between px-6 py-6">
          <div className="flex items-center gap-3">
            <div className="flex h-11 w-11 items-center justify-center rounded-full border border-coral/40 bg-coral/10 text-sm font-semibold text-coral">
              SS
            </div>
            <div>
              <p className="text-lg font-semibold text-white">ShoreSafe</p>
              <p className="text-xs uppercase tracking-[0.3em] text-coral">Port day timing</p>
            </div>
          </div>
          <nav className="hidden items-center gap-8 text-sm text-mist/80 md:flex">
            <a className="transition hover:text-white" href="#features">
              Features
            </a>
            <a className="transition hover:text-white" href="#how">
              How it works
            </a>
            <a className="transition hover:text-white" href="#pricing">
              Pricing
            </a>
            <a className="transition hover:text-white" href="#faq">
              FAQ
            </a>
          </nav>
          <a
            className="rounded-full bg-coral px-5 py-2 text-sm font-semibold text-navy shadow-glow transition hover:-translate-y-0.5"
            href="#pricing"
          >
            Get alerts
          </a>
        </header>

        <section className="mx-auto grid w-full max-w-6xl gap-12 px-6 pb-20 pt-12 lg:grid-cols-[1.1fr_0.9fr] lg:items-center lg:pt-20">
          <div>
            <p className="text-xs uppercase tracking-[0.35em] text-coral">ShoreSafe port day alarm app</p>
            <h1 className="mt-4 text-4xl font-semibold text-white md:text-6xl">
              Ship time vs local time, last tender time, and every port day alarm in one calm view.
            </h1>
            <p className="mt-6 text-lg text-mist/80">
              Stop juggling time zones. ShoreSafe keeps ship time vs local time locked, highlights last tender time, and fires a port day alarm app
              schedule built for shore days.
            </p>
            <div className="mt-8 flex flex-col gap-4 sm:flex-row">
              <a
                className="rounded-full bg-white px-6 py-3 text-sm font-semibold text-navy shadow-glow transition hover:-translate-y-0.5"
                href="#pricing"
              >
                Plan my port day
              </a>
              <a
                className="rounded-full border border-mist/30 px-6 py-3 text-sm font-semibold text-mist transition hover:border-coral hover:text-white"
                href="#how"
              >
                See how it works
              </a>
            </div>
            <div className="mt-10 h-[2px] w-full max-w-md bg-[linear-gradient(90deg,rgba(255,106,90,0.1),rgba(255,106,90,0.8),rgba(255,106,90,0.1))] bg-[length:200%_200%] animate-shimmer" />
            <div className="mt-10 grid gap-4 text-xs uppercase tracking-[0.3em] text-mist/60 sm:grid-cols-3">
              <span>Offline friendly</span>
              <span>Ship time locked</span>
              <span>Last tender alerts</span>
            </div>
          </div>

          <div className="relative">
            <div className="absolute inset-0 rounded-3xl bg-gradient-to-br from-coral/20 via-transparent to-transparent blur-2xl" />
            <div className="relative rounded-3xl border border-mist/10 bg-white/5 p-6 shadow-card">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs uppercase tracking-[0.3em] text-mist/60">Tomorrow in port</p>
                  <p className="mt-2 text-2xl font-semibold text-white">Cozumel</p>
                </div>
                <span className="rounded-full bg-coral/20 px-3 py-1 text-xs font-semibold text-coral">08:00 AM ship time</span>
              </div>
              <div className="mt-6 space-y-4">
                <div className="rounded-2xl border border-mist/10 bg-navy/70 p-4">
                  <p className="text-xs uppercase tracking-[0.25em] text-mist/60">Ship time vs local time</p>
                  <p className="mt-2 text-lg font-semibold text-white">Ship time 08:00 AM | Local time 07:00 AM</p>
                </div>
                <div className="rounded-2xl border border-mist/10 bg-navy/70 p-4">
                  <p className="text-xs uppercase tracking-[0.25em] text-mist/60">Last tender time</p>
                  <p className="mt-2 text-lg font-semibold text-white">Last tender 5:30 PM ship time</p>
                </div>
                <div className="rounded-2xl border border-mist/10 bg-navy/70 p-4">
                  <p className="text-xs uppercase tracking-[0.25em] text-mist/60">Port day alarm app</p>
                  <p className="mt-2 text-lg font-semibold text-white">Alarm set for 4:45 PM ship time</p>
                </div>
              </div>
              <div className="mt-6 rounded-2xl border border-coral/40 bg-coral/10 p-4 text-sm text-mist">
                ShoreSafe syncs the day plan, so you never lose track of ship time vs local time.
              </div>
            </div>
          </div>
        </section>
      </div>

      <main>
        <section id="features" className="mx-auto w-full max-w-6xl px-6 py-16">
          <div className="flex flex-col gap-6 md:flex-row md:items-end md:justify-between">
            <div>
              <p className="text-xs uppercase tracking-[0.35em] text-coral">Timing clarity</p>
              <h2 className="mt-4 text-3xl font-semibold text-white md:text-4xl">
                Port days are different. ShoreSafe keeps them simple.
              </h2>
            </div>
            <p className="max-w-xl text-sm text-mist/70">
              ShoreSafe is built for the ship time vs local time problem, last tender time changes, and the one port day alarm app you can trust when
              schedules shift.
            </p>
          </div>

          <div className="mt-10 grid gap-6 md:grid-cols-3">
            {[
              {
                title: "Ship time vs local time",
                copy: "See both clocks side by side and lock alarms to ship time so you never guess.",
              },
              {
                title: "Last tender time",
                copy: "Highlighted with bold alerts and a countdown so you stay ahead of the pier.",
              },
              {
                title: "Port day alarm app",
                copy: "Schedule return reminders in ship time, even if the local timezone changes.",
              },
            ].map((item) => (
              <div key={item.title} className="rounded-3xl border border-mist/10 bg-white/5 p-6 shadow-card">
                <h3 className="text-xl font-semibold text-white">{item.title}</h3>
                <p className="mt-3 text-sm text-mist/70">{item.copy}</p>
              </div>
            ))}
          </div>
        </section>

        <section id="how" className="mx-auto w-full max-w-6xl px-6 py-16">
          <div className="grid gap-10 md:grid-cols-[0.8fr_1.2fr] md:items-center">
            <div>
              <p className="text-xs uppercase tracking-[0.35em] text-coral">How it works</p>
              <h2 className="mt-4 text-3xl font-semibold text-white md:text-4xl">
                A calm briefing for every port day.
              </h2>
              <p className="mt-4 text-sm text-mist/70">
                Drop in your itinerary, confirm ship time vs local time, and let ShoreSafe set the last tender time alerts with a simple port day alarm app
                flow.
              </p>
            </div>
            <div className="space-y-4">
              {[
                {
                  step: "01",
                  title: "Add the port day",
                  copy: "Choose your arrival, all-aboard, and last tender time in ship time.",
                },
                {
                  step: "02",
                  title: "Verify local time",
                  copy: "Confirm the local timezone once so ship time vs local time stays clear.",
                },
                {
                  step: "03",
                  title: "Set alerts",
                  copy: "Pick your port day alarm app reminders and a backup alarm.",
                },
              ].map((item) => (
                <div key={item.step} className="flex gap-4 rounded-2xl border border-mist/10 bg-navy/80 p-4">
                  <span className="text-sm font-semibold text-coral">{item.step}</span>
                  <div>
                    <p className="text-base font-semibold text-white">{item.title}</p>
                    <p className="mt-1 text-sm text-mist/70">{item.copy}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section id="pricing" className="mx-auto w-full max-w-6xl px-6 py-16">
          <div className="text-center">
            <p className="text-xs uppercase tracking-[0.35em] text-coral">Pricing</p>
            <h2 className="mt-4 text-3xl font-semibold text-white md:text-4xl">Simple, per sailing pricing.</h2>
            <p className="mt-4 text-sm text-mist/70">Pay once for the trip. No subscriptions. No surprise charges.</p>
          </div>
          <div className="mt-10 grid gap-6 md:grid-cols-2">
            <div className="rounded-3xl border border-mist/10 bg-white/5 p-6 shadow-card">
              <p className="text-sm uppercase tracking-[0.3em] text-mist/60">Solo</p>
              <p className="mt-4 text-4xl font-semibold text-white">$0.99</p>
              <p className="mt-2 text-sm text-mist/70">Solo .99 (no sharing).</p>
              <ul className="mt-6 space-y-3 text-sm text-mist/70">
                <li>Ship time vs local time view</li>
                <li>Last tender time alerts</li>
                <li>Port day alarm app reminders</li>
              </ul>
              <button
                className="mt-6 inline-flex w-full items-center justify-center rounded-full bg-white px-4 py-2 text-sm font-semibold text-navy"
                type="button"
              >
                Choose Solo
              </button>
            </div>
            <div className="rounded-3xl border border-coral/60 bg-coral/10 p-6 shadow-card">
              <p className="text-sm uppercase tracking-[0.3em] text-coral">Crew</p>
              <p className="mt-4 text-4xl font-semibold text-white">$0.99</p>
              <p className="mt-2 text-sm text-mist/70">Crew .99 (invite up to 3 guests).</p>
              <ul className="mt-6 space-y-3 text-sm text-mist/70">
                <li>Share the same port day alarms</li>
                <li>Ship time vs local time for everyone</li>
                <li>Last tender time group reminders</li>
              </ul>
              <button
                className="mt-6 inline-flex w-full items-center justify-center rounded-full bg-coral px-4 py-2 text-sm font-semibold text-navy"
                type="button"
              >
                Choose Crew
              </button>
            </div>
          </div>
        </section>

        <section id="faq" className="mx-auto w-full max-w-6xl px-6 py-16">
          <div className="grid gap-10 md:grid-cols-[0.9fr_1.1fr]">
            <div>
              <p className="text-xs uppercase tracking-[0.35em] text-coral">FAQ</p>
              <h2 className="mt-4 text-3xl font-semibold text-white md:text-4xl">Quick answers before you go ashore.</h2>
              <p className="mt-4 text-sm text-mist/70">Still have questions? We are happy to help the moment you step onboard.</p>
            </div>
            <div className="space-y-6">
              {[
                {
                  q: "What does ship time vs local time mean?",
                  a: "Ship time is the official time for departures and all-aboard calls. ShoreSafe keeps ship time vs local time visible together so you stay on schedule.",
                },
                {
                  q: "How do last tender time alerts work?",
                  a: "Set the last tender time once and ShoreSafe fires reminders in ship time, even if the local time changes during the day.",
                },
                {
                  q: "No guarantees?",
                  a: "Correct. ShoreSafe is a helper, not a promise. Always follow the ship announcements and port authority updates.",
                },
                {
                  q: "Can I share with my group?",
                  a: "Yes. Crew lets you invite up to 3 guests to the same port day alarm app schedule.",
                },
              ].map((item) => (
                <div key={item.q} className="rounded-2xl border border-mist/10 bg-white/5 p-5">
                  <p className="text-base font-semibold text-white">{item.q}</p>
                  <p className="mt-2 text-sm text-mist/70">{item.a}</p>
                </div>
              ))}
            </div>
          </div>
        </section>
      </main>

      <footer className="border-t border-mist/10">
        <div className="mx-auto flex w-full max-w-6xl flex-col items-start justify-between gap-6 px-6 py-10 md:flex-row md:items-center">
          <div>
            <p className="text-lg font-semibold text-white">ShoreSafe</p>
            <p className="mt-2 text-sm text-mist/70">
              A calm port day alarm app for ship time vs local time, last tender time, and confident returns.
            </p>
          </div>
          <div className="text-xs uppercase tracking-[0.3em] text-mist/60">Always confirm official announcements.</div>
        </div>
      </footer>
    </div>
  )
}

export default App
