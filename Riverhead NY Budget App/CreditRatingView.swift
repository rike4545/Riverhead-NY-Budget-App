//
//  CreditRatingView.swift
//  Riverhead NY Budget App
//
//  Riverhead borrows at Moody's Aa2. Brookhaven borrows at Moody's Aaa and
//  S&P's AAA — the top of both scales. What the rating agencies actually said
//  about each town, how Riverhead stacks up against its other Suffolk
//  neighbors, and concrete steps that map to the agencies' own criteria.
//
//  Mirrors the web edition's /credit-rating page.
//
//  Swift 6 · iOS 17+
//

import SwiftUI

@MainActor
struct CreditRatingView: View {

    var body: some View {
        List {
            ledeSection
            plainLanguageSection
            headlineSection
            puzzleSection
            historySection
            brookhavenSection
            peerSection
            criteriaSection
            leverSection
            opebContextSection
            opebTrendSection
            opebLeverSection
            caveatSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Credit Rating")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Lede

    private var ledeSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                Text("Aa2 vs. Brookhaven's AAA")
                    .font(.headline)
                Text("Riverhead borrows at Moody's Aa2. Brookhaven borrows at Moody's Aaa and S&P's AAA — the top of both scales. Here's what the rating agencies actually said about each town, how Riverhead stacks up against its other Suffolk neighbors, and concrete steps that map to the agencies' own published criteria.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Plain language

    private var plainLanguageSection: some View {
        Section {
            Text("A credit rating is not a report card on how a town feels about its finances — it's a specific, published opinion an independent agency sells to bond buyers. Riverhead and Brookhaven are both rated by Moody's, which makes them directly comparable on the same scale. Brookhaven adds a second rating from S&P, at the top of that scale too.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            definitionRow(
                "What a rating is",
                "an independent agency's opinion of how likely a town is to repay its debt on time — a higher rating usually means lower interest costs when the Town borrows."
            )
            definitionRow(
                "Aa2 vs. AAA",
                "both are “investment grade,” but AAA is the top of the scale; Aa2 sits two notches below it on Moody's ladder."
            )
            definitionRow(
                "Sourcing here",
                "primary rating-agency documents were not directly reachable while building this screen — every reported quote and figure below is flagged VERIFIED (from an audited Town filing already used elsewhere in this app) or REPORTED (from news coverage, not independently confirmed)."
            )
        } header: {
            Label("In plain language", systemImage: "text.book.closed")
        }
    }

    // MARK: - Headline stats

    private var headlineSection: some View {
        Section {
            HStack(alignment: .top) {
                statTile("Riverhead — Moody's", CreditRating.Current.rating, "affirmed \(CreditRating.Current.affirmedDate)")
                Spacer(minLength: 12)
                statTile("Brookhaven — Moody's", CreditRating.Brookhaven.moodyRating, "\(CreditRating.Brookhaven.consecutiveMoodyAaaYears)th consecutive year")
            }
            HStack(alignment: .top) {
                statTile("Brookhaven — S&P", CreditRating.Brookhaven.spRating, "outlook: \(CreditRating.Brookhaven.outlook)")
                Spacer(minLength: 12)
                statTile(
                    "Riverhead reserve strength",
                    CreditRating.riverheadReserveShare.formatted(.percent.precision(.fractionLength(1))),
                    "of 2026 General Fund budget — above Brookhaven's own \(CreditRating.brookhavenReserveShare)"
                )
            }
            statTile(
                "Riverhead OPEB rank",
                "\(CreditRating.riverheadOpebRank) of 10",
                "highest per-resident retiree-health liability, Suffolk towns"
            )
        } header: {
            Label("Where the two towns stand", systemImage: "chart.bar.doc.horizontal")
        }
    }

    // MARK: - The puzzle

    private var puzzleSection: some View {
        Section {
            Text("Riverhead's reserve cushion — \(CreditRating.riverheadReserveShare.formatted(.percent.precision(.fractionLength(1)))) of its General Fund budget — is already **above** Brookhaven's own posture (\(CreditRating.brookhavenReserveShare)), and its debt burden is minimal: just **\(CreditRating.debtLimitExhaustedPct.formatted())%** of its legal debt limit used. On paper, the two headline numbers rating agencies talk about most — reserves and debt — both favor Riverhead. So why does Brookhaven sit at the top of the scale while Riverhead sits two notches below it? The rating criteria below break out where the two towns most likely diverge — and it isn't reserves or bonded debt.")
                .font(.subheadline)
                .foregroundStyle(RiverheadTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 2)
        } header: {
            Label("The puzzle this screen is about", systemImage: "questionmark.circle")
        }
    }

    // MARK: - Rating history

    private var historySection: some View {
        Section {
            ForEach(CreditRating.ratingHistory) { event in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(event.action)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(RiverheadTheme.brandNavy)
                        Spacer()
                        confidenceBadge(event.confidence)
                    }
                    Text(event.date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(event.rating)
                        .font(.title3.weight(.heavy))
                        .foregroundStyle(RiverheadTheme.accent)

                    if let quote = event.quote {
                        Text("“\(quote)”")
                            .font(.footnote.italic())
                            .foregroundStyle(RiverheadTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 8)
                            .overlay(alignment: .leading) {
                                Rectangle()
                                    .fill(RiverheadTheme.brandSky)
                                    .frame(width: 3)
                            }
                        if let attribution = event.quoteAttribution {
                            Text("— \(attribution)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Is Feb. 2024 still current?")
                    .font(.footnote.weight(.semibold))
                Text(CreditRating.ratingGap)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text("Current short-term rating: \(CreditRating.Current.shortTermRating)")
                    .font(.caption.weight(.semibold))
                Text(CreditRating.Current.shortTermContext)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(CreditRating.Current.sourceTitle)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                Text(CreditRating.Current.sourceDetail)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 2)
        } header: {
            Label("Riverhead's rating history", systemImage: "clock.arrow.circlepath")
        }
    }

    // MARK: - Brookhaven

    private var brookhavenSection: some View {
        Section {
            HStack(alignment: .top) {
                statTile("Moody's", CreditRating.Brookhaven.moodyRating, CreditRating.Brookhaven.asOf)
                Spacer(minLength: 12)
                statTile("S&P", CreditRating.Brookhaven.spRating, "outlook: \(CreditRating.Brookhaven.outlook)")
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("What S&P credited")
                        .font(.footnote.weight(.semibold))
                    Spacer()
                    confidenceBadge(CreditRating.Brookhaven.confidence)
                }
                Text("“\(CreditRating.Brookhaven.spRationale)”")
                    .font(.footnote.italic())
                    .foregroundStyle(RiverheadTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 2)

            Text(CreditRating.Brookhaven.history)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // The unverified-quote disclosure. Kept visible on purpose: this app
            // does not publish an unconfirmed quote as an attribution, and the
            // gap is more useful shown than silently dropped.
            VStack(alignment: .leading, spacing: 4) {
                Label("A quote we did not publish", systemImage: "exclamationmark.triangle")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(RiverheadTheme.brandGold)
                Text(CreditRating.BrookhavenQuoteNote.status)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Closest confirmed statement: \(CreditRating.BrookhavenQuoteNote.closestConfirmedAdjacent)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 2)

            ForEach(CreditRating.Brookhaven.sources, id: \.self) { source in
                Text(source)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        } header: {
            Label("Brookhaven's AAA", systemImage: "star.circle")
        }
    }

    // MARK: - Peer ladder

    private var peerSection: some View {
        Section {
            Text("Same-agency comparison only. Mixing S&P and Fitch notches onto one bar would need an equivalence table this app can't source, so those ratings appear as a label instead of a bar position.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(CreditRating.peerRatings) { peer in
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(peer.town)
                            .font(.subheadline.weight(peer.isRiverhead ? .heavy : .semibold))
                            .foregroundStyle(peer.isRiverhead ? RiverheadTheme.accent : RiverheadTheme.brandNavy)
                        Spacer()
                        if let moody = peer.moodyRating {
                            Text(moody)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(peer.isRiverhead ? RiverheadTheme.accent : RiverheadTheme.brandNavy)
                        }
                    }

                    if let moody = peer.moodyRating, !moody.isEmpty {
                        // Bar length shrinks as the rating falls further below Aaa.
                        // Suffolk County's Baa1 (7 notches) sets the floor.
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(RiverheadTheme.Surface.card)
                                .frame(height: 8)
                                .overlay(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(peer.isRiverhead ? RiverheadTheme.accent : RiverheadTheme.brandSky)
                                        .frame(
                                            width: geo.size.width * max(0.06, 1.0 - Double(peer.moodyNotchesBelowAaa) / 8.0),
                                            height: 8
                                        )
                                }
                        }
                        .frame(height: 8)
                    }

                    if let other = peer.otherAgencyRating {
                        Text(other)
                            .font(.caption)
                            .foregroundStyle(RiverheadTheme.brandMint)
                    }

                    HStack {
                        Text(peer.asOf)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        confidenceBadge(peer.confidence)
                    }
                }
                .padding(.vertical, 4)
            }
        } header: {
            Label("How Riverhead compares to its Suffolk neighbors", systemImage: "list.number")
        }
    }

    // MARK: - Criteria

    private var criteriaSection: some View {
        Section {
            Text("Weights are approximate — synthesized from secondary summaries of Moody's and S&P criteria, not a read of the primary methodology documents. Treat them as illustrative.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(CreditRating.ratingCriteria) { factor in
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(factor.factor)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(RiverheadTheme.brandNavy)
                        Spacer()
                        Text(factor.approxWeight)
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(RiverheadTheme.accent)
                    }
                    Text(factor.whatItMeans)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(factor.riverheadRead)
                        .font(.footnote)
                        .foregroundStyle(RiverheadTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 2)
                }
                .padding(.vertical, 4)
            }
        } header: {
            Label("What the rating criteria actually weigh", systemImage: "scalemass")
        }
    }

    // MARK: - Levers

    private var leverSection: some View {
        Section {
            ForEach(Array(CreditRating.levers.enumerated()), id: \.element.id) { index, lever in
                leverRow(index: index + 1, lever: lever)
            }
        } header: {
            Label("Five concrete ways to move the needle", systemImage: "arrow.up.right.circle")
        }
    }

    // MARK: - OPEB context

    private var opebContextSection: some View {
        Section {
            Text("Riverhead's retiree-health liability is the factor Moody's named explicitly. Spread across residents it ranks 4th-highest of the ten Suffolk towns — behind only the smaller East End towns that divide a similar total among far fewer people. This ranking is built on the 2023 all-activities figure of $152.6M, which is what the comparison tool held; the Town's newest reported figure is $129,479,192 for governmental activities at the end of 2025.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            let maxPerResident = CreditRating.opebPerResident.map(\.perResident).max() ?? 1
            ForEach(CreditRating.opebPerResident) { town in
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(town.town)
                            .font(.footnote.weight(town.isRiverhead ? .heavy : .regular))
                            .foregroundStyle(town.isRiverhead ? RiverheadTheme.accent : RiverheadTheme.textSecondary)
                        Spacer()
                        Text(town.perResident, format: .currency(code: "USD").precision(.fractionLength(0)))
                            .font(.footnote.weight(town.isRiverhead ? .heavy : .semibold))
                            .foregroundStyle(town.isRiverhead ? RiverheadTheme.accent : RiverheadTheme.brandNavy)
                    }
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(RiverheadTheme.Surface.card)
                            .frame(height: 6)
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(town.isRiverhead ? RiverheadTheme.brandCoral : RiverheadTheme.brandSky)
                                    .frame(
                                        width: geo.size.width * (Double(town.perResident) / Double(maxPerResident)),
                                        height: 6
                                    )
                            }
                    }
                    .frame(height: 6)
                }
                .padding(.vertical, 2)
            }

            Text("Net OPEB liability per resident, 2023 audited filings (Empire Center OPEB tool).")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        } header: {
            Label("OPEB in context: where Riverhead ranks", systemImage: "cross.case")
        }
    }

    // MARK: - OPEB trend and basis

    private var opebTrendSection: some View {
        Section {
            Text(CreditRating.opebWhyItMoves)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(CreditRating.opebSeries) { year in
                VStack(alignment: .leading, spacing: 4) {
                    Text(year.asOf.uppercased())
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(RiverheadTheme.brandGold)
                    Text(year.governmental, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .font(.title3.weight(.bold))
                        .monospacedDigit()
                    Text(basisLine(for: year))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 2)
            }

            Text("Governmental activities come from the Annual Financial Report's Schedule W. The all-activities total adds water and sewer and comes from the audited statements, which run a year behind — so the two are never the same number, and mixing them across years invents a trend.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .fixedSize(horizontal: false, vertical: true)
        } header: {
            Label("Why the number keeps moving", systemImage: "arrow.up.arrow.down")
        }
    }

    private func basisLine(for year: CreditRating.OpebYear) -> String {
        var parts: [String] = ["governmental activities"]
        if let rate = year.discountRate {
            parts.append("discount rate \(rate.formatted(.number.precision(.fractionLength(2))))%")
        } else {
            parts.append("discount rate not yet published")
        }
        if let total = year.total {
            let formatted = total.formatted(.currency(code: "USD").precision(.fractionLength(0)))
            parts.append("\(formatted) including water & sewer")
        } else {
            parts.append("audited all-activities total not out yet")
        }
        return parts.joined(separator: " · ")
    }

    // MARK: - OPEB levers

    private var opebLeverSection: some View {
        Section {
            Text("Two different things: FUNDING the liability (how it gets paid for) and SHRINKING it (how big it gets in the first place). Current retirees' and current employees' accrued benefits are generally vested and can't be clawed back — the plan-design levers below apply to future hires and to funding mechanics, not to cutting what's already been promised.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(Array(CreditRating.opebLevers.enumerated()), id: \.element.id) { index, lever in
                leverRow(index: index + 1, lever: lever)
            }
        } header: {
            Label("How to actually reduce or fund the OPEB liability", systemImage: "chart.line.downtrend.xyaxis")
        }
    }

    // MARK: - Caveats

    private var caveatSection: some View {
        Section {
            ForEach(CreditRating.caveats, id: \.self) { caveat in
                Label {
                    Text(caveat)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                } icon: {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.vertical, 2)
            }
        } header: {
            Label("Limits of this screen", systemImage: "exclamationmark.bubble")
        }
    }

    // MARK: - Row helpers

    private func leverRow(index: Int, lever: CreditRating.Lever) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(index)")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .background(Circle().fill(RiverheadTheme.accent))
                Text(lever.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(RiverheadTheme.brandNavy)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text(lever.detail)
                .font(.footnote)
                .foregroundStyle(RiverheadTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Text(lever.evidence)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 1)
        }
        .padding(.vertical, 4)
    }

    private func definitionRow(_ label: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.footnote.weight(.semibold))
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 2)
    }

    private func statTile(_ label: String, _ value: String, _ sub: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(RiverheadTheme.brandNavy)
            Text(sub)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func confidenceBadge(_ confidence: CreditRating.Confidence) -> some View {
        Text(confidence.rawValue)
            .font(.caption2.weight(.heavy))
            .foregroundStyle(confidence.color)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(
                Capsule().fill(confidence.color.opacity(0.15))
            )
            .accessibilityLabel("Confidence: \(confidence.rawValue)")
    }
}

#Preview {
    NavigationStack {
        CreditRatingView()
    }
}
