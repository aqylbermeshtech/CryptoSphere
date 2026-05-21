//
//  PortfolioListFeature.swift
//  CryptoSphere
//
//  Created by Nurtore on 21.05.2026.
//

import ComposableArchitecture
import Foundation

struct PortfolioListFeature: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var coins: [Coin] = []
        var isLoading = false
        var errorMessage: String? = nil
        
        var totalBalanceUSD: Double = 0.0
        
    }
    
    enum Action {
        case refreshButtonTapped
        case fetchCoinsResponse(TaskResult<[Coin]>)
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
        }
    }
}



