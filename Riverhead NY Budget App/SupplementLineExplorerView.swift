//
//  SupplementLineExplorerView.swift
//  Riverhead NY Budget App
//
//  Browsable line-item ledger from the 2025 + 2026 Budget Supplements: every
//  expenditure account with four years of actuals and budgets, its 2026 tentative,
//  and how far that tentative sits above or below its trailing run-rate. This is
//  the actual-vs-budget detail the fund drilldown (adopted-budget columns only)
//  never had. Data is bundled from the shared ETL via SupplementData.
//
//  Swift 6 · iOS 17+
//

import SwiftUI

@MainActor
struct SupplementLineExplorerView: View {
    @State private var query = ""
    @State private var fundFilter = "All"
    @State private var controlFilter = "All"
    @State private var overBudgetOnly = false

    private var expenditureLines: [SupplementLine] {
        SupplementData.lines.filter { $0.kind == "expenditure" }
    }

    private var funds: [String] {
        ["All"] + Set(expenditureLines.map(\.fund)).sorted()
    }
    private let controls = ["All", "controllable", "personnel", "mandated"]

    private var filtered: [SupplementLine] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        return expenditureLines.filter { line in
            (fundFilter == "All" || line.fund == fundFilter)
            && (controlFilter == "All" || line.control == controlFilter)
            && (!overBudgetOnly || (line.overBudget2026 ?? 0) > 0)
            && (q.isEmpty || line.name.lowercased().contains(q) || line.account.lowercased().contains(q))
        }
        .sorted { ($0.overBudget2026 ?? -.greatestFiniteMagnitude) > ($1.overBudget2026 ?? -.greatestFiniteMagnitude) }
    }

    var body: some View {
        List {
            Section {
                Picker("Fund", selection: $fundFilter) {
                    ForEach(funds, id: \.self) { Text($0).tag($0) }
                }
                Picker("Category", selection: $controlFilter) {
                    Text("All").tag("All")
                    Text("Controllable").tag("controllable")
                    Text("Personnel").tag("personnel")
                    Text("Mandated").tag("mandated")
                }
                Toggle("Over-budget only", isOn: $overBudgetOnly)
            } header: {
                Text("\(filtered.count) of \(expenditureLines.count) expenditure lines")
            } footer: {
                Text("\"Over run-rate\" is the 2026 Tentative minus the trailing full-year run-rate (the larger of 2024 Actual and annualized 2025 YTD). Positive means the line is budgeted above what it has recently spent.")
            }

            Section {
                ForEach(filtered.prefix(300)) { line in
                    lineRow(line)
                }
                if filtered.count > 300 {
                    Text("Showing the first 300. Narrow with search or filters.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .searchable(text: $query, prompt: "Search account name or code")
        .navigationTitle("Line-Item Ledger")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func lineRow(_ line: SupplementLine) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(line.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer(minLength: 8)
                controlBadge(line.control)
            }
            Text("\(line.fund) · \(line.account)")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 0) {
                col("2023 act", line.actual2023)
                col("2024 act", line.actual2024)
                col("2025 bud", line.budget2025)
                col("2026 tent", line.tentative2026, tint: RiverheadTheme.brandBlue)
            }

            if let ob = line.overBudget2026, abs(ob) >= 1 {
                let over = ob > 0
                Label(
                    "\(over ? "+" : "")\(ob.formatted(.currency(code: "USD").precision(.fractionLength(0)))) vs run-rate",
                    systemImage: over ? "arrow.up.right" : "arrow.down.right"
                )
                .font(.caption.weight(.semibold))
                .foregroundStyle(over ? RiverheadTheme.brandCoral : RiverheadTheme.brandMint)
            }
        }
        .padding(.vertical, 3)
    }

    private func col(_ label: String, _ value: Double?, tint: Color = .primary) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption2).foregroundStyle(.secondary)
            Text(value == nil ? "—" : (value!).formatted(.currency(code: "USD").notation(.compactName).precision(.fractionLength(0...1))))
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func controlBadge(_ c: String) -> some View {
        let (label, tint): (String, Color) = {
            switch c {
            case "controllable": return ("CONTROLLABLE", RiverheadTheme.brandSky)
            case "personnel": return ("PERSONNEL", RiverheadTheme.brandNavy)
            case "mandated": return ("MANDATED", .secondary)
            default: return (c.uppercased(), .secondary)
            }
        }()
        return Text(label)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(tint.opacity(0.15), in: Capsule())
            .foregroundStyle(tint)
    }
}

#Preview {
    NavigationStack { SupplementLineExplorerView() }
}
