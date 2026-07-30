//
//  CloseTheGap2027.swift
//  Riverhead NY Budget App
//
//  The real 2027 constraint — the tax-cap gap — and the politically durable path
//  through a divided Town Board. Ported from the web edition's close-the-gap-2027.ts
//  so the three platforms tell the same story.
//
//  Two different "gaps" appear in the 2027 planning views and they measure
//  different things:
//    • payroll-pressure gap ($936,727) — the recurring cost of standing still.
//    • cap-piercing gap    ($2,619,382) — how far the projected 2027 levy
//      overshoots what NY's 2% property-tax cap allows. This is the number that
//      forces a political decision.
//
//  Swift 6 / iOS 17+
//

import Foundation

enum CloseTheGap2027 {
    // From the 2027 prediction model (budget-2027-prediction.json capGap).
    static let capPiercingGap: Double = 2_619_382
    static let allowedLevy: Double = 66_650_818
    static let predictedLevy: Double = 69_270_200
    static let predictedLevyPct: Double = 6.0
    static let capBasePct: Double = 2

    struct RetirementUnit: Identifiable {
        let unit: String
        let count: Int
        let benefit: String
        var id: String { unit }
    }

    enum RetirementIncentive {
        static let approved = "July 7, 2026 — unanimous Town Board vote"
        static let resolutions = "2026-678 (CSEA), 2026-679 (SOA), 2026-680 (PBA)"
        static let eligibleTotal = 53
        static let eligible: [RetirementUnit] = [
            .init(unit: "CSEA", count: 29, benefit: "Flat $12,500 lump sum"),
            .init(unit: "PBA", count: 18, benefit: "$1,000 / year of service + up to 30 accrued sick days"),
            .init(unit: "SOA", count: 6, benefit: "$1,000 / year of service + up to 30 accrued sick days"),
        ]
        static let projectedSavingsLow: Double = 500_000
        static let projectedSavingsHigh: Double = 800_000
        static let savingsWindow = "the rest of 2026 and the full 2027 budget year"
        static let electionDeadline = "September 1, 2026"
        static let retireBy = "October 1, 2026"
        static let note = "The savings figure is the Town's own projection; the final number depends on how many of the 53 eligible employees actually retire by the September 1, 2026 deadline, and on how each vacated post is refilled. Source: RiverheadLOCAL, July 9, 2026."
    }

    // How each lever fares on a divided board (1 Democratic Supervisor + a
    // 4-member Republican Council majority). `standing` describes political
    // durability, not dollars.
    enum Standing: String {
        case agreed = "Already agreed · 5–0"
        case lowFriction = "Low partisan friction"
        case neutral = "Neutral · no service cut"
        case oneTime = "One-time · bridge only"
        case deliberate = "Legal if done in the open"
        case blunt = "Blunt · overstated"
    }

    struct GapPath: Identifiable {
        let name: String
        let closes: String
        let standing: Standing
        let politics: String
        var id: String { name }
    }

    static let paths: [GapPath] = [
        .init(
            name: "Bank the retirement-incentive savings the whole Board already voted for",
            closes: "$500K–$800K recurring (Town projection)",
            standing: .agreed,
            politics: "The three union incentives passed 5–0 on July 7, 2026. Refilling the vacated posts at a lower step is the one salary saving both the Democratic Supervisor and the Republican majority have already endorsed — no new fight to have."
        ),
        .init(
            name: "Stack the sourced, audit-driven line trims",
            closes: "the firm-confidence recurring trims below",
            standing: .lowFriction,
            politics: "Each trim is tied to a specific, documented anomaly in the Town's own budget — a line that jumped 800%, 1,563%, or budgeted well above its own trailing actuals. Opposing one means defending an unexplained increase on the record, which is hard to do along party lines."
        ),
        .init(
            name: "Grow non-property-tax revenue",
            closes: "$1 off the levy for every $1 of new state aid, fees, mortgage tax, or interest",
            standing: .neutral,
            politics: "Offsets the cap-busting levy dollar-for-dollar with no service cut and no tax increase — the rare move with nothing for either side to run against."
        ),
        .init(
            name: "Use a modest, disclosed one-time fund-balance appropriation for the residual only",
            closes: "whatever gap remains after the recurring measures above",
            standing: .oneTime,
            politics: "An easy vote — it raises no tax and cuts no service — but it spends one-time money on recurring cost, so it can only bridge a transitional remainder. Appropriating the full $2.62M would burn ~7.8% of the General Fund cushion for something that recurs."
        ),
        .init(
            name: "If the Board still wants the spending, override the cap — deliberately and in public",
            closes: "the full gap, by raising the legal ceiling",
            standing: .deliberate,
            politics: "The cap can be exceeded legally: adopt the override local law first, in the open, with the 60% vote on the record — as Riverhead did in 2023, 2024, and 2026. The problem to avoid is piercing the cap by accident; a disclosed, on-purpose override is a legitimate choice, not a violation."
        ),
        .init(
            name: "The blunt shortcut: an across-the-board 2.5% cut",
            closes: "~$2.1M on paper",
            standing: .blunt,
            politics: "Politically tempting because it sounds even-handed, but it overstates what's actually cuttable — most of the base is personnel and mandated costs a flat directive can't touch — and it hits services indiscriminately."
        ),
    ]

    static let pragmaticReading = "Start with what already carries bipartisan support (the 5–0 retirement incentive), stack the audit-driven trims and any non-tax revenue on top — none of which asks either side to hand the other a political win — and reserve one-time fund balance for the small residual. A cap override stays available, but as a deliberate, disclosed choice rather than a number the budget backs into."
}
