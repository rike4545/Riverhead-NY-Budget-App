//
//  OvertimeStaffingView.swift
//  Riverhead NY Budget App
//
//  Is a police rank staffed by overtime rather than by headcount?
//  Backed by PayrollAnalysis.swift. Mirrors the web Overtime & Staffing tab and
//  the Android OvertimeStaffingScreen.
//
//  Swift 6 · iOS 17+
//

import SwiftUI

struct OvertimeStaffingView: View {

    private let trends = OvertimeStaffing.trends
    private let flagged = OvertimeStaffing.flagged
    private let check = OvertimeStaffing.individualCheck

    var body: some View {
        List {
            framingSection
            noIndividualProblemSection
            if flagged.isEmpty {
                Section { Text("No rank currently meets both conditions.").font(.footnote).foregroundStyle(.secondary) }
            } else {
                ForEach(flagged) { rankSection($0) }
            }
            allRanksSection
            caveatsSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Overtime & Staffing")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var framingSection: some View {
        Section {
            Text("Overtime is paid at **1.5×** the normal rate. So \(money(150_000)) of overtime buys about \(money(100_000)) worth of actual labour hours — roughly one more officer's worth of coverage. When one rank runs a full position or more of overtime year after year, the Town is staffing that rank by premium instead of by headcount.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } header: {
            Label("The question this answers", systemImage: "questionmark.circle")
        }
    }

    // Stated first, on purpose: a test that never fires is broken, not conservative.
    private var noIndividualProblemSection: some View {
        Section {
            Text("The obvious test is to flag any officer whose overtime exceeds \(check.threshold, specifier: "%.1f")× their base salary. Across all \(check.recordsChecked.formatted()) sworn pay records on file, that test flags **\(check.countOverThreshold)**. The highest individual ratio ever recorded is **\(pct(check.highestRatio))** of base (\(check.highestRatioTitle.isEmpty ? "sworn officer" : check.highestRatioTitle), \(String(check.highestRatioYear))), and only \(check.countOverHalfBase) records have ever exceeded even half of base pay.")
                .font(.footnote)
            Text("Whatever is happening in Riverhead's overtime line, it is not a handful of people running up enormous individual totals. The pattern is structural, and it shows up by rank.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } header: {
            Label("First, what this is not", systemImage: "checkmark.shield")
        }
    }

    private func rankSection(_ trend: RankTrend) -> some View {
        Section {
            HStack {
                Text(trend.title).font(.headline)
                Spacer()
                Text("\(trend.latest.headcount) on payroll")
                    .font(.caption).foregroundStyle(.secondary)
            }

            HStack(spacing: 14) {
                stat("Positions' worth", String(format: "%.1f", trend.latest.fteCovered))
                stat("Overtime paid", money(trend.latest.totalOvertime))
                stat("Share of base", pct(trend.latest.otShareOfBase))
            }
            .padding(.vertical, 2)

            let maxFte = max(trend.years.map(\.fteCovered).max() ?? 1, 1)
            ForEach(trend.years) { y in
                HStack(spacing: 8) {
                    Text(String(y.year)).font(.caption2).foregroundStyle(.secondary).frame(width: 34, alignment: .leading)
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(RiverheadTheme.accent)
                            .frame(width: max(2, geo.size.width * (y.fteCovered / maxFte)), height: 12)
                            .frame(maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 14)
                    Text(String(format: "%.1f", y.fteCovered))
                        .font(.caption2.weight(.semibold)).monospacedDigit()
                        .frame(width: 32, alignment: .trailing)
                }
            }
        } header: {
            Label("Flagged rank", systemImage: "exclamationmark.triangle")
        } footer: {
            Text("Flagged because its overtime covers at least one full position's worth of straight-time hours in \(String(trend.latest.year)) and did so in most years on record — a sustained pattern, not a single bad year.")
        }
    }

    private var allRanksSection: some View {
        Section {
            ForEach(trends) { t in
                HStack {
                    Text(t.title).font(.footnote)
                    Spacer()
                    Text(String(format: "%.1f FTE", t.latest.fteCovered))
                        .font(.footnote.weight(t.latest.fteCovered >= 1 ? .bold : .regular))
                        .foregroundStyle(t.latest.fteCovered >= 1 ? RiverheadTheme.accent : .secondary)
                        .monospacedDigit()
                }
            }
        } header: {
            Label("All sworn ranks", systemImage: "list.bullet")
        }
    }

    private var caveatsSection: some View {
        Section {
            ForEach(OvertimeStaffing.caveats, id: \.self) { c in
                Label(c, systemImage: "info.circle").font(.caption).foregroundStyle(.secondary)
            }
            Text(OvertimeStaffing.sourceNote).font(.caption2).foregroundStyle(.tertiary)
        } header: {
            Label("A question to cost out, not a conclusion", systemImage: "questionmark.folder")
        }
    }

    private func stat(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(label.uppercased()).font(.caption2.weight(.bold)).foregroundStyle(.tertiary)
            Text(value).font(.subheadline.weight(.semibold)).monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func money(_ v: Double) -> String {
        v.formatted(.currency(code: "USD").precision(.fractionLength(0)))
    }
    private func pct(_ v: Double) -> String { String(format: "%.1f%%", v * 100) }
}
