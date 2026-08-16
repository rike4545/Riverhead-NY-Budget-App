//
//  SeparationPayView.swift
//  Riverhead NY Budget App
//
//  What the Town owes its workforce in unused leave, and what leaving costs.
//  Backed by PayrollAnalysis.swift. Mirrors the web Separation Pay tab and the
//  Android SeparationPayScreen.
//
//  Aggregate only, by deliberate choice: every figure derives from records this
//  app already shows per person elsewhere, but presenting named individuals
//  under a payout heading reads as an accusation, and the finding is about
//  whether the Town tracks a liability — not about anyone's conduct.
//
//  Swift 6 · iOS 17+
//

import SwiftUI

struct SeparationPayView: View {

    private let summary = SeparationPay.summary

    var body: some View {
        List {
            framingSection
            liabilitySection
            cashSection
            byGroupSection
            whyNowSection
            caveatsSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Separation Pay")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var framingSection: some View {
        Section {
            Text(SeparationPay.overtimeFinding)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } header: {
            Label("Where end-of-career money shows up", systemImage: "arrow.down.right.circle")
        }
    }

    private var liabilitySection: some View {
        Section {
            Text("Unused leave owed to employees has grown **\(money(SeparationPay.liabilityTwoYearChange))** in two years. This is an audited balance-sheet figure, not an estimate by this app.")
                .font(.footnote)

            let maxAmt = SeparationPay.liability.map(\.amount).max() ?? 1
            ForEach(SeparationPay.liability) { y in
                HStack(spacing: 8) {
                    Text(y.asOf).font(.caption2).foregroundStyle(.secondary).frame(width: 108, alignment: .leading)
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.red.opacity(0.75))
                            .frame(width: max(2, geo.size.width * (y.amount / maxAmt)), height: 14)
                            .frame(maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 16)
                    Text(money(y.amount))
                        .font(.caption2.weight(.bold)).monospacedDigit()
                        .frame(width: 84, alignment: .trailing)
                }
            }

            Text("Read this before quoting the jump: \(SeparationPay.gasb101Note)")
                .font(.caption).foregroundStyle(.secondary)
            Text("Source: \(SeparationPay.liabilitySource)")
                .font(.caption2).foregroundStyle(.tertiary)
        } header: {
            Label("What the Town says it owes", systemImage: "doc.text.magnifyingglass")
        }
    }

    private var cashSection: some View {
        Section {
            HStack(spacing: 14) {
                stat("Separations", summary.separations.formatted())
                stat("Above career avg", money(summary.totalExcess))
            }
            HStack(spacing: 14) {
                stat("Median separation", money(summary.medianFinalYearResidual))
                stat("Largest single year", money(summary.largestFinalYearResidual))
            }
            Text("The median is the important number. At \(money(summary.medianFinalYearResidual)), the typical separation is unremarkable. Precisely **\(summary.concentratedCount) of the \(summary.separations)** people here account for **\(Int((summary.concentratedShare * 100).rounded()))%** of the entire total. This is a tail, not a norm, and any reading that implies most departing employees receive a windfall is wrong.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } header: {
            Label("What separations actually paid out", systemImage: "dollarsign.circle")
        } footer: {
            Text("Everyone with at least three years on the payroll who stopped appearing before 2025, comparing their final year's residual pay against their own career average — so a well-paid career doesn't register as an anomaly.")
        }
    }

    private var byGroupSection: some View {
        Section {
            ForEach(summary.byGroup) { g in
                VStack(alignment: .leading, spacing: 2) {
                    Text(SeparationPay.label(g.group)).font(.footnote.weight(.semibold))
                    Text("\(g.separations) separations · \(money(g.excessOverCareerAverage)) above career average · median year \(money(g.medianFinalYearResidual))")
                        .font(.caption2).foregroundStyle(.secondary)
                }
                .padding(.vertical, 1)
            }
        } header: {
            Label("By group", systemImage: "person.3")
        } footer: {
            Text("Not all of these are unions. CSEA, the PBA and the SOA are bargaining units whose leave and buy-back terms are set in a negotiated contract. Elected, appointed, management and non-represented staff are not union-covered — their leave comes from Board policy or an individual agreement.")
        }
    }

    private var whyNowSection: some View {
        Section {
            Text(SeparationPay.whyItMattersNow).font(.footnote)
        } header: {
            Label("Why this matters in 2026", systemImage: "calendar.badge.exclamationmark")
        }
    }

    private var caveatsSection: some View {
        Section {
            ForEach(SeparationPay.caveats, id: \.self) { c in
                Label(c, systemImage: "info.circle").font(.caption).foregroundStyle(.secondary)
            }
            Text("What's missing: \(SeparationPay.whatWouldSettleIt)")
                .font(.caption).foregroundStyle(.secondary)
        } header: {
            Label("The limits of this analysis", systemImage: "exclamationmark.triangle")
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
}
