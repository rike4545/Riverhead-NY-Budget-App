//
//  BoardElectionsView.swift
//  Riverhead NY Budget App
//
//  How the current Town Board was elected — each member's actual winning vote
//  count against the town's total population and its registered voters. A low
//  share isn't an accusation; it's the normal reality of low-turnout local
//  elections, and a reminder of how few votes decide who controls the budget.
//
//  Swift 6 / iOS 17+
//

import SwiftUI

struct BoardElectionMember: Identifiable {
    let id = UUID()
    let name: String
    let office: String
    let party: String
    let electionLabel: String
    let votes: Int
    let result: String
}

struct ElectionCandidate: Identifiable {
    let id = UUID()
    let name: String
    let party: String
    let votes: Int
    let won: Bool
}

struct ElectionRace: Identifiable {
    let id = UUID()
    let office: String
    let seats: Int
    let note: String?
    let candidates: [ElectionCandidate]   // winners first, then runners-up
}

struct PriorElection: Identifiable {
    let id = UUID()
    let year: Int
    let turnoutNote: String
    let races: [ElectionRace]
}

enum BoardElectionsData {
    static let population = 35_902
    static let registeredVoters = 24_217

    static let members: [BoardElectionMember] = [
        .init(name: "Jerome (Jerry) Halpin", office: "Town Supervisor", party: "D",
              electionLabel: "November 2025", votes: 3_958,
              result: "Defeated incumbent Tim Hubbard 3,958 to 3,921 — a 37-vote margin that held through a full manual recount."),
        .init(name: "Robert \"Bob\" Kern", office: "Councilman", party: "R",
              electionLabel: "November 2025", votes: 3_958,
              result: "Re-elected to a three-year term; his 3,958 votes were the highest total in any Riverhead race that year."),
        .init(name: "Kenneth Rothwell", office: "Councilman", party: "R",
              electionLabel: "November 2025", votes: 3_882,
              result: "Re-elected to a three-year term, defeating Democrat Mark Woolley 3,882 to 3,824 — a 58-vote margin."),
        .init(name: "Joann Waski", office: "Councilwoman", party: "R",
              electionLabel: "November 2023", votes: 4_875,
              result: "Won one of two open council seats with 4,875 votes (29.2%) in a four-way race."),
        .init(name: "Denise Merrifield", office: "Councilwoman", party: "R",
              electionLabel: "November 2023", votes: 4_992,
              result: "Top vote-getter for the two open council seats with 4,992 votes (29.9%) in a four-way race."),
    ]

    static let note = "Vote counts are the winning candidate's own total, from the Suffolk County Board of Elections' final certified results (including the 2025 supervisor recount). The registered-voter denominator is the November 2025 figure; the 2023 winners are compared against it as an approximate reference. Percentages are the winner's votes divided by each denominator — not a turnout rate."

    static let sources = "RiverheadLOCAL / Riverhead News-Review 2025 and 2023 election results · Suffolk County Board of Elections, Election Results (incl. 2019/2021/2025 general-election Riverhead town pages) · U.S. Census Bureau, 2020 Census — Town of Riverhead."

    static let priorElectionsNote = "Prior Riverhead town general-election results from the Suffolk County Board of Elections. Totals combine each candidate's party lines (e.g. Republican + Conservative). Turnout stayed near 39% in 2019 and 2021 and fell to about 32% in 2025 — the same low-participation pattern that decides who controls the Town's budget."

    static let priorElections: [PriorElection] = [
        .init(year: 2025, turnoutNote: "7,879 of 24,429 voted for supervisor (32.3%).", races: [
            .init(office: "Supervisor", seats: 1, note: "Jerry Halpin flipped the seat for the Democrats by 37 votes, confirmed on a full manual recount.", candidates: [
                .init(name: "Jerome (Jerry) Halpin", party: "D/TF", votes: 3_958, won: true),
                .init(name: "Timothy C. Hubbard", party: "R/C", votes: 3_921, won: false),
            ]),
            .init(office: "Council member", seats: 2, note: nil, candidates: [
                .init(name: "Bob Kern", party: "R/C", votes: 3_958, won: true),
                .init(name: "Kenneth Rothwell", party: "R/C", votes: 3_882, won: true),
                .init(name: "Mark A. Woolley", party: "D/TF", votes: 3_824, won: false),
                .init(name: "Kevin M. Shea", party: "D/TF", votes: 3_515, won: false),
            ]),
        ]),
        .init(year: 2021, turnoutNote: "9,142 of 23,133 voted for supervisor (39.5%).", races: [
            .init(office: "Supervisor", seats: 1, note: nil, candidates: [
                .init(name: "Yvette Aguiar", party: "R/C", votes: 5_335, won: true),
                .init(name: "Catherine Kent", party: "D/WF", votes: 3_807, won: false),
            ]),
            .init(office: "Councilman", seats: 2, note: "Current members Kenneth Rothwell and Robert Kern first won their council seats here.", candidates: [
                .init(name: "Kenneth Rothwell", party: "R/C", votes: 5_453, won: true),
                .init(name: "Robert Kern", party: "R/C", votes: 5_206, won: true),
                .init(name: "Evelyn Hobson-Womack", party: "D/WF", votes: 3_760, won: false),
                .init(name: "Juan Micieli-Martinez", party: "D/WF", votes: 3_137, won: false),
            ]),
        ]),
        .init(year: 2019, turnoutNote: "8,587 of 21,798 voted for supervisor (39.4%).", races: [
            .init(office: "Supervisor", seats: 1, note: nil, candidates: [
                .init(name: "Yvette Aguiar", party: "R/C", votes: 4_647, won: true),
                .init(name: "Laura M. Jens-Smith", party: "D/WF/I", votes: 3_940, won: false),
            ]),
            .init(office: "Councilman", seats: 2, note: "Timothy Hubbard — later supervisor, defeated in 2025 — first won a council seat here.", candidates: [
                .init(name: "Timothy C. Hubbard", party: "R/C", votes: 4_924, won: true),
                .init(name: "Frank R. Beyrodt Jr.", party: "R/C", votes: 4_564, won: true),
                .init(name: "Diane E. Tucci", party: "D", votes: 3_634, won: false),
                .init(name: "Patricia A. Snyder", party: "D", votes: 3_130, won: false),
            ]),
        ]),
    ]
}

struct BoardElectionsView: View {
    private func pct(_ votes: Int, _ denom: Int) -> String {
        (Double(votes) / Double(denom)).formatted(.percent.precision(.fractionLength(1)))
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("How the current Town Board was elected")
                        .font(.headline)
                    Text("How many actual votes put each current board member in office — against the town's total population and its registered voters. A low share isn't an accusation; it's the normal reality of low-turnout local elections.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section {
                HStack {
                    statTile("Town population", "\(BoardElectionsData.population.formatted())", "2020 Census")
                    Spacer()
                    statTile("Registered voters", "\(BoardElectionsData.registeredVoters.formatted())", "Nov 2025")
                }
                Text("The percentages below are each winner's own vote total divided by these denominators — not a turnout rate — showing how small a slice of the whole town chose the people who now control its budget.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Section("Current board") {
                ForEach(BoardElectionsData.members) { m in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(m.name)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(RiverheadTheme.brandNavy)
                            Spacer()
                            Text(m.electionLabel)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Text("\(m.office) · \(m.party)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(m.votes.formatted())
                                .font(.title2.weight(.heavy))
                                .foregroundStyle(RiverheadTheme.brandNavy)
                            Text("votes won the seat")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 2)

                        Text("That's \(pct(m.votes, BoardElectionsData.registeredVoters)) of the town's \(BoardElectionsData.registeredVoters.formatted()) registered voters — and \(pct(m.votes, BoardElectionsData.population)) of its \(BoardElectionsData.population.formatted()) residents.")
                            .font(.caption)
                            .foregroundStyle(RiverheadTheme.textSecondary)

                        // Bar: share of registered voters (the meaningful yardstick).
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(RiverheadTheme.Surface.card)
                                .frame(height: 8)
                                .overlay(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(RiverheadTheme.accent)
                                        .frame(width: geo.size.width * (Double(m.votes) / Double(BoardElectionsData.registeredVoters)), height: 8)
                                }
                        }
                        .frame(height: 8)

                        Text(m.result)
                            .font(.caption)
                            .foregroundStyle(RiverheadTheme.textSecondary)
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 4)
                }
            }

            ForEach(BoardElectionsData.priorElections) { election in
                Section("\(yearText(election.year)) General Election") {
                    Text(election.turnoutNote)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    ForEach(election.races) { race in
                        raceView(race)
                    }
                }
            }

            // ---- What the law actually requires of these offices ----
            Section {
                Text("The votes above put these people in office. This is what the law asked of them before they could stand for it — for the Supervisor and every Council member alike, since the qualifications are identical.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(OfficeQualifications.electedRequirements) { requirementRow($0) }
            } header: {
                Label("What the Job Legally Requires", systemImage: "checkmark.seal")
            }

            Section {
                Text(OfficeQualifications.electorLede)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(OfficeQualifications.electorTests) { t in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(t.label).font(.footnote.weight(.semibold))
                        Text(t.detail).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
                Text(OfficeQualifications.electorDisqualified).font(.caption).foregroundStyle(.secondary)
                Text(OfficeQualifications.electorNote).font(.caption).foregroundStyle(.secondary)
                Text(OfficeQualifications.electorSources).font(.caption2).foregroundStyle(.tertiary)
            } header: {
                Label(OfficeQualifications.electorTitle, systemImage: "person.text.rectangle")
            }

            Section {
                ForEach(OfficeQualifications.notRequired, id: \.self) { item in
                    Label(item, systemImage: "xmark")
                        .font(.footnote)
                        .labelStyle(.titleAndIcon)
                }
                Text(OfficeQualifications.notRequiredClosing)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Label(OfficeQualifications.notRequiredTitle, systemImage: "nosign")
            }

            Section {
                Text(OfficeQualifications.termLimitAdopted).font(.caption2).foregroundStyle(.tertiary)
                Text(OfficeQualifications.termLimitIntent).font(.footnote)
                Text(OfficeQualifications.termLimitMechanics).font(.footnote).foregroundStyle(.secondary)
                Text(OfficeQualifications.termLimitAuthority).font(.caption).foregroundStyle(.secondary)
            } header: {
                Label(OfficeQualifications.termLimitTitle, systemImage: "clock.arrow.circlepath")
            }

            Section {
                Text(OfficeQualifications.electedOfficesLede).font(.footnote).foregroundStyle(.secondary)
                Text(OfficeQualifications.electedOffices.joined(separator: " · "))
                    .font(.footnote.weight(.semibold))
                ForEach(OfficeQualifications.codeDecisions) { d in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(d.what).font(.footnote.weight(.semibold))
                        Text(d.detail).font(.caption).foregroundStyle(.secondary)
                        Text(d.source).font(.caption2).foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 2)
                }
            } header: {
                Label(OfficeQualifications.electedOfficesTitle, systemImage: "checklist")
            }

            Section {
                ForEach(OfficeQualifications.oddYearBody, id: \.self) { para in
                    Text(para).font(.footnote).foregroundStyle(.secondary)
                }
            } header: {
                Label(OfficeQualifications.oddYearTitle, systemImage: "calendar.badge.exclamationmark")
            }

            Section {
                Text(OfficeQualifications.staffLede).font(.footnote).foregroundStyle(.secondary)
                ForEach(OfficeQualifications.staffRequirements) { requirementRow($0) }
                Text(OfficeQualifications.officerVsEmployee).font(.caption).foregroundStyle(.secondary)
            } header: {
                Label(OfficeQualifications.staffTitle, systemImage: "person.2.badge.gearshape")
            }

            Section {
                Text(OfficeQualifications.disclaimer)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Section {
                Text(BoardElectionsData.priorElectionsNote)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(BoardElectionsData.note)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("Sources: \(BoardElectionsData.sources)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Board Elections")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func requirementRow(_ r: OfficeRequirement) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(r.label.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(.tertiary)
            Text(r.value)
                .font(.subheadline.weight(.semibold))
            Text(r.detail)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(r.source)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 3)
        .accessibilityElement(children: .combine)
    }

    private func statTile(_ label: String, _ value: String, _ sub: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption2).foregroundStyle(.secondary)
            Text(value).font(.title3.weight(.bold)).foregroundStyle(RiverheadTheme.brandNavy)
            Text(sub).font(.caption2).foregroundStyle(.secondary)
        }
    }

    // Plain year string — avoids the locale grouping that renders 2,025.
    private func yearText(_ year: Int) -> String { String(year) }

    @ViewBuilder
    private func raceView(_ race: ElectionRace) -> some View {
        let maxVotes = race.candidates.map(\.votes).max() ?? 1
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(race.office)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(RiverheadTheme.brandNavy)
                Spacer()
                Text(race.seats == 1 ? "1 seat" : "\(race.seats) seats")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            if let note = race.note {
                Text(note)
                    .font(.caption2)
                    .foregroundStyle(RiverheadTheme.accent)
            }
            ForEach(race.candidates) { c in
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(c.won ? "✓ " : "")\(c.name)")
                            .font(.caption.weight(c.won ? .bold : .regular))
                            .foregroundStyle(c.won ? RiverheadTheme.brandNavy : RiverheadTheme.textSecondary)
                        Text("(\(c.party))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(c.votes.formatted())
                            .font(.caption.weight(c.won ? .bold : .regular))
                            .foregroundStyle(c.won ? RiverheadTheme.brandNavy : RiverheadTheme.textSecondary)
                    }
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(RiverheadTheme.Surface.card)
                            .frame(height: 6)
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(c.won ? RiverheadTheme.accent : RiverheadTheme.textSecondary.opacity(0.4))
                                    .frame(width: geo.size.width * (Double(c.votes) / Double(maxVotes)), height: 6)
                            }
                    }
                    .frame(height: 6)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
