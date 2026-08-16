//
//  RoadSpendingPeers.swift
//  Riverhead NY Budget App
//
//  Road spending per maintained mile for every town in Suffolk County, on a
//  single consistent basis.
//
//  WHY THIS REPLACED THE OLD PEER FIGURES
//  The dashboard previously compared Riverhead against Southold and Brookhaven
//  using each town's adopted-budget highway appropriation over an approximate
//  road-mile count. That is not a like-for-like comparison: adopted highway
//  appropriations bundle employee benefits, debt service and capital differently
//  from town to town, the budget years did not match, and the mileage was
//  estimated. It put Southold near $56,000 per mile when the comparable figure
//  is about $24,000 — roughly 2.3x too high.
//
//  Both halves now come from one source each, applied identically to all ten
//  towns:
//    • Spending — NYS Office of the State Comptroller, Financial Data for Local
//      Governments. Every town files the same annual report on the same chart
//      of accounts, so "Highways" means the same thing in Riverhead as in
//      Brookhaven. FY ending 12/31/2024, Level 2 category = "Highways".
//    • Mileage — NYSDOT Highway Mileage, locally maintained centerline miles
//      (data.ny.gov tccz-tc3t), 2020, the latest published. State and county
//      roads inside a town are maintained by those governments.
//
//  Mirrors web/lib/road-spending.ts and web/public/data/road-spending.json.
//

import Foundation

struct RoadSpendingPeer: Identifiable, Hashable {
    let name: String
    /// OSC "Highways" expenditures, FY2024.
    let highwaySpending: Double
    /// NYSDOT locally maintained centerline miles, 2020.
    let roadMiles: Double

    var id: String { name }
    var spendPerMile: Double { highwaySpending / roadMiles }
}

enum RoadSpendingPeers {

    static let fiscalYear = 2024
    static let mileageYear = 2020

    /// All ten Suffolk County towns, highest spend per mile first.
    static let all: [RoadSpendingPeer] = [
        RoadSpendingPeer(name: "Smithtown",      highwaySpending: 19_851_243, roadMiles: 470.70),
        RoadSpendingPeer(name: "Huntington",     highwaySpending: 31_174_857, roadMiles: 786.90),
        RoadSpendingPeer(name: "Babylon",        highwaySpending: 17_947_081, roadMiles: 529.97),
        RoadSpendingPeer(name: "Islip",          highwaySpending: 33_487_302, roadMiles: 997.98),
        RoadSpendingPeer(name: "Brookhaven",     highwaySpending: 59_800_886, roadMiles: 1_799.59),
        RoadSpendingPeer(name: "Southampton",    highwaySpending: 12_900_129, roadMiles: 436.67),
        RoadSpendingPeer(name: "Southold",       highwaySpending:  4_793_578, roadMiles: 200.41),
        RoadSpendingPeer(name: "Riverhead",      highwaySpending:  4_673_787, roadMiles: 207.77),
        RoadSpendingPeer(name: "Shelter Island", highwaySpending:  1_110_721, roadMiles:  49.52),
        RoadSpendingPeer(name: "East Hampton",   highwaySpending:  5_347_054, roadMiles: 285.58),
    ]

    static let riverheadName = "Riverhead"

    static var riverhead: RoadSpendingPeer {
        all.first { $0.name == riverheadName } ?? all[7]
    }

    static var medianSpendPerMile: Double {
        let v = all.map(\.spendPerMile).sorted()
        let m = v.count / 2
        return v.count % 2 == 1 ? v[m] : (v[m - 1] + v[m]) / 2
    }

    static var maxSpendPerMile: Double {
        all.map(\.spendPerMile).max() ?? 1
    }

    /// 1 = highest spending per mile.
    static var riverheadRank: Int {
        (all.sorted { $0.spendPerMile > $1.spendPerMile }
            .firstIndex { $0.name == riverheadName } ?? 0) + 1
    }

    /// How far below (or above) the county median Riverhead sits, as a share.
    static var riverheadVsMedian: Double {
        1 - (riverhead.spendPerMile / medianSpendPerMile)
    }

    /// Extra annual cost of spending at the county median rate across Riverhead's miles.
    static var gapToMedianAnnual: Double {
        (medianSpendPerMile - riverhead.spendPerMile) * riverhead.roadMiles
    }

    /// What Riverhead's highway money is spent on, FY2024 (OSC object of expenditure).
    static let riverheadMix: [(object: String, amount: Double)] = [
        ("Personal Services",           2_722_233),
        ("Equipment and Capital Outlay",  995_678),
        ("Contractual",                   955_876),
    ]

    static let caveats: [String] = [
        "Spending less per mile is a question, not a result. It can mean an efficient operation or deferred maintenance handed to a later budget. Neither dataset measures pavement condition, and the Town publishes no pavement-condition rating.",
        "Centerline miles, not lane miles. A four-lane road counts the same as a two-lane road of the same length.",
        "The Comptroller's Highways category excludes employee benefits and debt service, which are reported separately. Every town is measured the same way, so the ranking holds, but the dollar figures understate the full cost of a highway department.",
        "Airports, bus service and waterways sit in the wider Transportation function and are excluded — East Hampton runs an airport, and including it would distort the comparison.",
        "Villages maintain their own streets and file separately; village roads and spending are excluded from both sides.",
        "Spending is FY2024 and mileage is 2020, the most recent NYSDOT publication. Road mileage moves slowly, but the years do not match exactly.",
        "One year can mislead: a town that repaved heavily in 2024 looks expensive, one that deferred looks thrifty.",
    ]

    static let sourceNote = "Spending: NYS Office of the State Comptroller, Financial Data for Local Governments — annual financial reports, fiscal year ended December 31, 2024, expenditures where the Comptroller's Level 2 category is \"Highways\". Road mileage: NYS Department of Transportation, Highway Mileage (data.ny.gov tccz-tc3t), locally maintained centerline miles, 2020."
}
