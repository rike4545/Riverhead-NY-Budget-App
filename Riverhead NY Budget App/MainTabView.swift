//
//  MainTabView.swift
//  Riverhead NY Budget App
//
//  Root tab container. Referenced by RootView.
//  All stores flow in from Riverhead_NYApp via environment injection:
//    - RBBudgetStore         (@Observable  → .environment)
//    - RBCivicToolkitStore   (ObservableObject → .environmentObject)
//    - RBSixSigmaStore       (ObservableObject → .environmentObject)
//
//  Swift 5 language mode • iOS 26+
//
//  Bars are deliberately left unstyled. On iOS 26 the system draws the tab bar
//  and navigation bar in Liquid Glass; any UIKit appearance proxy set here would
//  replace that material with a flat fill and the app would look like it had
//  never been rebuilt. The previous version of this file did exactly that.
//

import SwiftUI

@MainActor
struct MainTabView: View {
    private enum AppTab: String, Hashable {
        case home
        case budget
        case discover
        case toolkits
        case more

        var title: String {
            switch self {
            case .home:
                return "Home"
            case .budget:
                return "Budget"
            case .discover:
                return "Civic"
            case .toolkits:
                return "Tools"
            case .more:
                return "More"
            }
        }

        var systemImage: String {
            switch self {
            case .home:
                return "house.fill"
            case .budget:
                return "chart.bar.doc.horizontal"
            case .discover:
                return "sparkle.magnifyingglass"
            case .toolkits:
                return "person.2.badge.gearshape"
            case .more:
                return "ellipsis.circle"
            }
        }
    }

    @AppStorage("Riverhead.selectedTab") private var selectedTabRaw: String = AppTab.home.rawValue
    @Environment(RBBudgetStore.self) private var budgetStore
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    @State private var hasPreparedBudgetData = false
    @State private var isPreparingBudgetData = false

    var body: some View {
        TabView(selection: selectedTab) {
            Tab(AppTab.home.title, systemImage: AppTab.home.systemImage, value: AppTab.home) {
                NavigationStack {
                    HomeView()
                }
            }

            Tab(AppTab.budget.title, systemImage: AppTab.budget.systemImage, value: AppTab.budget) {
                NavigationStack {
                    RiverheadBudgetHubView()
                }
            }

            Tab(AppTab.discover.title, systemImage: AppTab.discover.systemImage, value: AppTab.discover) {
                NavigationStack {
                    CivicImprovementsHubView()
                }
            }

            Tab(AppTab.toolkits.title, systemImage: AppTab.toolkits.systemImage, value: AppTab.toolkits) {
                NavigationStack {
                    CivicToolkitsHubView()
                }
            }

            Tab(AppTab.more.title, systemImage: AppTab.more.systemImage, value: AppTab.more) {
                NavigationStack {
                    MoreView()
                }
            }
        }
        .tint(RiverheadTheme.accent)
        .tabBarMinimizeBehavior(.onScrollDown)
        .task {
            await prepareBudgetDataIfNeeded()
        }
        .overlay(alignment: .top) {
            if isPreparingBudgetData {
                startupBanner
                    .padding(.top, 8)
            }
        }
    }

    private var selectedTab: Binding<AppTab> {
        Binding(
            get: { AppTab(rawValue: selectedTabRaw) ?? .home },
            set: { selectedTabRaw = $0.rawValue }
        )
    }

    // A floating pill over scrolling content is exactly what Liquid Glass is for,
    // so on iOS 26 it takes the real material instead of .ultraThinMaterial plus a
    // hand-drawn border and shadow — glass supplies its own edge and shadow.
    // Reduce Transparency still gets the flat card: glass is a translucency effect,
    // and that setting exists to turn translucency off.
    private var startupBanner: some View {
        let pill = Label("Loading budget data", systemImage: "arrow.trianglehead.2.clockwise")
            .font(.footnote.weight(.medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

        return Group {
            if reduceTransparency {
                pill
                    .background(RiverheadTheme.Surface.card, in: Capsule())
                    .overlay(
                        Capsule()
                            .strokeBorder(RiverheadTheme.softBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
            } else {
                pill.glassEffect(.regular, in: Capsule())
            }
        }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Loading budget data")
            .accessibilityHint("Budget data is warming up in the background.")
            .accessibilityAddTraits(.updatesFrequently)
    }

    private func prepareBudgetDataIfNeeded() async {
        guard !hasPreparedBudgetData else { return }

        hasPreparedBudgetData = true
        isPreparingBudgetData = true
        await BudgetDataBootstrapper.warmUpAsync()
        budgetStore.refreshFromLoadedData()
        isPreparingBudgetData = false
    }
}

#Preview {
    MainTabView()
        .environmentObject(RBCivicToolkitStore())
        .environmentObject(RBSixSigmaStore())
        .environment(RBBudgetStore())
}
