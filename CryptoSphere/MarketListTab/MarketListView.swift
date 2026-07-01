//
//  MarketListView.swift
//  CryptoSphere
//
//  Created by Nurtore on 21.05.2026.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MarketListView: View {
    let store: StoreOf<MarketListFeature>
    
    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                content
                    .background(Color(.systemGray6).opacity(0.4).ignoresSafeArea())
                    .navigationTitle("Market")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        if store.coins.isEmpty {
                            store.send(.refreshButtonTapped)
                        }
                    }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading && store.coins.isEmpty {
            loadingView
        } else if let error = store.errorMessage {
            errorView(message: error)
        } else {
            mainMarketView
        }
    }
}

private extension MarketListView {
    
    var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Загрузка рынка...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text("⚠️").font(.largeTitle)
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button("Повторить") {
                store.send(.refreshButtonTapped)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
    
    var mainMarketView: some View {
        VStack(spacing: 0) {
            headerView
            tabBarView
            
            Divider()
                .background(Color(.systemGray5))
            
            coinListView
        }
    }
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Market is down")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        Text("- 11.17%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.red)
                    }
                    Text("In the past 24 hours")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()

                Button {
                    store.send(.refreshButtonTapped)
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Coins")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                HStack(spacing: 4) {
                    Text("Market- USD")
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    var tabBarView: some View {
        HStack(spacing: 24) {
            ForEach(MarketTab.allCases) { tab in
                VStack(spacing: 8) {
                    Text(tab.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(store.selectedTab == tab ? .blue : .gray)
                    
                    Capsule()
                        .fill(store.selectedTab == tab ? Color.blue : Color.clear)
                        .frame(height: 3)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    store.send(.tabSelected(tab))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    var coinListView: some View {
        ScrollView {
            VStack(spacing: 12) {
                if store.filteredCoins.isEmpty {
                    Text("Список пуст")
                        .foregroundColor(.secondary)
                        .padding(.top, 40)
                } else {
                    ForEach(store.filteredCoins) { coin in
                        MarketCoinRowView(
                            coin: coin,
                            isFavorite: store.favoriteCoinIds.contains(coin.id),
                            onFavoriteToggle: {
                                store.send(.toggleFavorite(coinId: coin.id))
                            }
                        )
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await store.send(.refreshButtonTapped).finish()
        }
    }
}

struct MarketCoinRowView: View {
    let coin: Coin
    let isFavorite: Bool
    var onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .orange : .gray.opacity(0.6))
                    .font(.system(size: 18))
            }
            .buttonStyle(.plain)
            
            URLImage(urlString: coin.image)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                Text(coin.symbol.uppercased())
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            let percentChange = coin.priceChangePercentage24h ?? 0.0
            let prices = coin.sparkLine?.price ?? []
            
            SparklineView(prices: prices, isPositive: percentChange >= 0)
                .frame(width: 60, height: 30)
            
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", coin.currentPrice))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                
                Text(String(format: "%@%.2f%%", percentChange >= 0 ? "+" : "", percentChange))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(percentChange >= 0 ? .green : .red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(coin.symbol.lowercased() == "band" ? Color.blue : Color.clear, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    MarketListView(
        store: Store(initialState: MarketListFeature.State(coins: Coin.mockCoins)) {
            MarketListFeature()
        }
    )
}
