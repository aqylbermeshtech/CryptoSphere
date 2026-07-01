//
//  MarketListFeature.swift
//  CryptoSphere
//
//  Created by Nurtore on 21.05.2026.
//

import ComposableArchitecture
import Foundation

enum MarketTab: String, CaseIterable, Identifiable {
    case all = "All"
    case gainer = "Gainer"
    case loser = "Loser"
    case favourites = "Favourites"
    
    var id: String { self.rawValue }
}


struct MarketListFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var coins: [Coin] = []
        var favoriteCoinIds: Set<String> = []
        var selectedTab: MarketTab = .all
        var isLoading = false
        var errorMessage: String? = nil

        var filteredCoins: [Coin] {
            switch selectedTab {
            case .all:
                return coins
            case .gainer:
                return coins.filter { ($0.priceChangePercentage24h ?? 0) > 0 }
                            .sorted { ($0.priceChangePercentage24h ?? 0) > ($1.priceChangePercentage24h ?? 0) }
            case .loser:
                return coins.filter { ($0.priceChangePercentage24h ?? 0) < 0 }
                            .sorted { ($0.priceChangePercentage24h ?? 0) < ($1.priceChangePercentage24h ?? 0) }
            case .favourites:
                return coins.filter { favoriteCoinIds.contains($0.id) }
            }
        }
    }
    
    enum Action {
        case refreshButtonTapped
        case fetchCoinsResponse(TaskResult<[Coin]>)
        case tabSelected(MarketTab) 
        case toggleFavorite(coinId: String)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .refreshButtonTapped:
            state.isLoading = true
            state.errorMessage = nil
            return .run { send in
                await send(.fetchCoinsResponse(TaskResult {
                    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true")!
                    let (data, response) = try await URLSession.shared.data(from: url)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 429 {
                        struct RateLimitError: Error, LocalizedError {}
                        throw RateLimitError()
                    }
                    return try JSONDecoder().decode([Coin].self, from: data)
                }))
            }
            
        case let .fetchCoinsResponse(.success(fetchedCoins)):
            state.coins = fetchedCoins
            state.isLoading = false
            return .none
            
        case let .fetchCoinsResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Не удалось загрузить данные: \(error.localizedDescription)"
            return .none
            
        case let .tabSelected(tab):
            state.selectedTab = tab
            return .none
            
        case let .toggleFavorite(coinId):
            if state.favoriteCoinIds.contains(coinId) {
                state.favoriteCoinIds.remove(coinId)
            } else {
                state.favoriteCoinIds.insert(coinId)
            }
            return .none
        }
    }
}
