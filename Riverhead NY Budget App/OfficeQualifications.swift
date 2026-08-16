//
//  OfficeQualifications.swift
//  Riverhead NY Budget App
//
//  What the law actually requires of the people who run the Town.
//
//  Sourced from three places and nowhere else:
//    • NY Public Officers Law § 3 — the floor for any civil office in the state.
//    • NY Town Law § 23 — qualifications of town officers (the "elector" rule).
//    • Riverhead Town Code Ch. 103 — the Town's own additions, notably the
//      Article VI term limits adopted as L.L. 14-2016.
//
//  A deliberate negative finding is recorded here: searching the Riverhead Code
//  for residency provisions returns sex-offender restrictions, zoning and
//  solid-waste definitions, and nothing at all about officers or employees. The
//  Town imposes no residency rule of its own; it inherits the state's. Readers
//  reasonably assume otherwise, so the absence is stated rather than skipped.
//
//  Mirrors web/lib/office-qualifications.ts and the Android
//  OfficeQualifications.kt.
//
//  Swift 6 · iOS 17+
//

import Foundation

struct OfficeRequirement: Identifiable, Hashable {
    let label: String
    let value: String
    let detail: String
    let source: String
    var id: String { label + value }
}

struct ElectorTest: Identifiable, Hashable {
    let label: String
    let detail: String
    var id: String { label }
}

struct CodeDecision: Identifiable, Hashable {
    let what: String
    let detail: String
    let source: String
    var id: String { what }
}

enum OfficeQualifications {

    static let electedRequirements: [OfficeRequirement] = [
        OfficeRequirement(
            label: "Age",
            value: "18 or older",
            detail: "The only age condition is the general one for holding any civil office in New York. There is no higher minimum for Supervisor or Council, and no maximum.",
            source: "Public Officers Law § 3(1)"
        ),
        OfficeRequirement(
            label: "Citizenship",
            value: "U.S. citizen",
            detail: "Required for any civil office in the state.",
            source: "Public Officers Law § 3(1)"
        ),
        OfficeRequirement(
            label: "Residency",
            value: "Must be an elector of the Town",
            detail: "A candidate must be a resident of New York and of the Town, and must be an elector of Riverhead — someone qualified to vote here — both at the time of election and continuously throughout the term. Moving out of Riverhead mid-term vacates the office.",
            source: "Public Officers Law § 3(1); Town Law § 23"
        ),
        OfficeRequirement(
            label: "Term limit",
            value: "12 consecutive years",
            detail: "Riverhead limits both the Supervisor and each Council member to 12 consecutive years — six two-year terms, three four-year terms, or any combination. The Town adopted this itself in 2016 and it overrides the state default, which sets no limit.",
            source: "Riverhead Town Code §§ 103-25, 103-26 (L.L. No. 14-2016)"
        ),
        OfficeRequirement(
            label: "Disqualifications",
            value: "Certain corruption convictions",
            detail: "A felony conviction under the Penal Law’s bribery or official-misconduct articles bars a person from civil office; the equivalent misdemeanors carry a five-year bar. Separately, a county treasurer, district superintendent of schools, or school district trustee may not serve as Town Supervisor.",
            source: "Public Officers Law § 3(1); Town Law § 23"
        ),
    ]

    static let electorTitle = "What “elector of the Town” actually means"
    static let electorLede = "Both the state and the Town hang their residency rule on this phrase. An elector is a person qualified to vote here — nothing more demanding than that."

    static let electorTests: [ElectorTest] = [
        ElectorTest(label: "Citizenship", detail: "A citizen of the United States."),
        ElectorTest(label: "Age", detail: "Eighteen or older on the day of the election — not on the day of filing or of taking office."),
        ElectorTest(
            label: "Residency, and its length",
            detail: "A resident of New York State and of the county for at least 30 days before the election. Thirty days is the entire durational test. There is no requirement to have lived in Riverhead for a year, or to have grown up here, or to own property."
        ),
        ElectorTest(
            label: "What “residence” means",
            detail: "Election Law defines it as “that place where a person maintains a fixed, permanent and principal home and to which he, wherever temporarily located, always intends to return.” A second home in Riverhead does not qualify unless it is genuinely the principal one — which is why residency challenges turn on where someone actually lives rather than what they own."
        ),
    ]

    static let electorDisqualified = "A person judged incompetent by a court cannot vote, and a person serving a felony sentence in prison cannot vote while incarcerated. New York restores voting rights on release."
    static let electorNote = "Registration is the practical proof of being an elector and any real candidacy will involve it, but the statutory test is qualification to vote, not the paperwork."
    static let electorSources = "Election Law §§ 5-102, 5-106; “residence” defined at Election Law § 1-104(22)"

    static let notRequiredTitle = "What the law does not require"

    static let notRequired: [String] = [
        "No education requirement — no degree of any kind, in any subject.",
        "No professional credential. The Supervisor is the Town’s chief fiscal officer and need hold no accounting, finance, or management qualification.",
        "No prior experience in government, budgeting, or management.",
        "No long residency history. Thirty days in the county before the election is the whole durational requirement — someone who moved to Riverhead a month before Election Day is eligible to run the Town.",
        "No competency or examination requirement of any kind.",
    ]

    static let notRequiredClosing = "This is not unusual; it is how nearly every elected office in New York works, and the theory is that the electorate is the qualification test. It is worth knowing all the same, because the Supervisor signs off on a budget of tens of millions of dollars and the only formal barrier to the job is being an adult who lives here and can win more votes than the other candidate."

    static let termLimitTitle = "Riverhead limits terms — and said why"
    static let termLimitAdopted = "Adopted April 19, 2016 · Local Law No. 14-2016, codified at Town Code §§ 103-24 through 103-29"
    static let termLimitIntent = "The Town Board’s stated purpose was “to increase the accountability of and expand participation in the governance of the Town of Riverhead by limiting the number of terms of office for the Supervisor and Town Council.”"
    static let termLimitMechanics = "Twelve consecutive years is the cap for each office, counted the same whether served as six two-year terms, three four-year terms, or a mix. Time served by appointment counts toward it. Hitting the cap in one office does not bar someone from running for a different elective Town office."
    static let termLimitAuthority = "Adopted under Municipal Home Rule Law § 10(1)(ii)a(1), expressly superseding Town Law § 24, which imposes no term limit."

    static let electedOfficesTitle = "Which offices Riverhead elects"
    static let electedOfficesLede = "Six Town offices go on the ballot, and the Town chose that structure itself. Several of these choices were put to a mandatory referendum, so voters approved them directly."

    static let electedOffices = [
        "Supervisor", "Town Council", "Town Clerk",
        "Receiver of Taxes", "Highway Superintendent", "Board of Assessors",
    ]

    static let codeDecisions: [CodeDecision] = [
        CodeDecision(
            what: "Three elected Assessors, kept by public vote",
            detail: "Riverhead retained elective Assessors under a 1971 local law that voters ratified at a special election. Most New York towns moved the other way, to a single appointed assessor who must meet State certification standards. Riverhead did not: the officials who set the assessed value your tax bill is calculated from answer to the ballot rather than to a professional qualification.",
            source: "Town Code §§ 103-1 to 103-3 (L.L. No. 1-1971, approved at special election)"
        ),
        CodeDecision(
            what: "Town Clerk: two-year term extended to four",
            detail: "Approved by referendum at the biennial Town election of November 6, 2007.",
            source: "Town Code §§ 103-5, 103-6 (L.L. No. 35-2007)"
        ),
        CodeDecision(
            what: "Highway Superintendent: two-year term extended to four",
            detail: "Approved by referendum at the biennial Town election of November 3, 2009.",
            source: "Town Code §§ 103-9, 103-10 (L.L. No. 59-2009)"
        ),
    ]

    static let oddYearTitle = "The Town’s own election-timing law, and the case that overtook it"

    static let oddYearBody: [String] = [
        "On November 7, 2024 the Town Board adopted Local Law No. 30-2024, which states that the Supervisor, Town Council, Town Clerk, Receiver of Taxes, Highway Superintendent and Board of Assessors “shall be held on the Tuesday next succeeding the first Monday in November of every odd-numbered year.” Its findings trace the practice to 1899 and rest the Town’s authority on Article IX of the State Constitution and Municipal Home Rule Law § 10(1)(a)(1).",
        "New York’s 2023 Even-Year Election Law moves most town elections to even-numbered years. Riverhead joined the federal challenge to that law, paid outside counsel, and withdrew in June 2026; on June 29, 2026 the court dismissed the government plaintiffs’ claims with prejudice and the even-year law stands.",
        "So the Town has a local law on its books saying odd years, and a state law — upheld — saying even. In practice the 2026 election is proceeding on the even-year calendar. Which instrument ultimately controls is a legal question this app cannot answer; it is flagged because a resident reading the Town Code alone would come away with the wrong idea about when their officials are elected.",
    ]

    static let staffTitle = "The Supervisor’s senior staff"
    static let staffLede = "Department heads and the Town Attorney are not the Supervisor’s hires. They are appointed by the Town Board as a body, at salaries the Board sets, which is a meaningful limit on what any incoming Supervisor can change alone."

    static let staffRequirements: [OfficeRequirement] = [
        OfficeRequirement(
            label: "Who appoints them",
            value: "The Town Board, not the Supervisor",
            detail: "The Town Attorney is “appointed by the Town Board for the terms fixed by law at such salary as may from time to time be fixed by the Town Board.” The Board likewise appoints Deputy Town Attorneys and the Administrator of Economic Development and Planning.",
            source: "Riverhead Town Code §§ 103-14B, 103-19"
        ),
        OfficeRequirement(
            label: "Merit standard",
            value: "Only one, and only for the Town Attorney",
            detail: "The Code says the Town Attorney “shall be appointed on the basis of his administrative experience and qualifications for the duties of such office.” That is the sole competence standard written into the chapter. No comparable clause governs the other department heads, whose sections describe duties rather than qualifications.",
            source: "Riverhead Town Code § 103-14B"
        ),
        OfficeRequirement(
            label: "Residency",
            value: "State law only",
            detail: "Appointed town officers must also be electors of the Town under Town Law § 23, subject to narrow statutory exceptions — including one that lets a town without a resident attorney appoint a non-resident Town Attorney. The Riverhead Code adds nothing: a search of the Town Code for residency provisions turns up sex-offender restrictions and zoning definitions, and no rule at all for officers or employees.",
            source: "Town Law § 23; Riverhead Town Code (no provision)"
        ),
        OfficeRequirement(
            label: "Age and citizenship",
            value: "Same floor as elected office",
            detail: "Eighteen or older, a U.S. citizen, and a New York resident — the general qualification for holding any civil office.",
            source: "Public Officers Law § 3(1)"
        ),
    ]

    static let officerVsEmployee = "One distinction matters and is easy to miss: these rules bind public officers, not every public employee. A department head who holds an office is covered; ordinary staff generally are not, and civil service rules rather than the Town Code govern most hiring. Where a particular position falls is a legal question this app does not try to settle."

    static let disclaimer = "A plain-English summary of statute and local law, not legal advice. Quoted language is from the sources named; anyone relying on this for an actual candidacy or appointment should read the sections themselves and speak to the Suffolk County Board of Elections or counsel."
}
