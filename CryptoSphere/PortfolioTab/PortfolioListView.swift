//
//  PortfolioListView.swift
//  CryptoSphere
//
//  Created by Nurtore on 20.05.2026.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct PortfolioListView:View {
    let store: StoreOf<PortfolioListFeature>
    var body: some View {
        NavigationStack {
            content
                .onAppear {
                    store.send(.refreshButtonTapped)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading && store.coins.isEmpty {
            VStack {
                ProgressView()
                Text("Загрузка рынка...")
                    .foregroundColor(.secondary)
            }
        } else if let error = store.errorMessage {
            VStack(spacing: 16) {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                
                Button("Повторить") {
                    store.send(.refreshButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        } else {
            List {
                Section {
                    HeaderPortfolioView(totalBalance: store.totalBalanceUSD)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                Section {
                    Text("Your coins")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .tracking(1.0)
                        .padding(.vertical, 4)
                    ForEach(store.coins) { coin in
                        HStack(spacing: 16) {
                            URLImage(urlString: coin.image)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(coin.name)
                                    .font(.headline)
                                Text(coin.symbol.uppercased())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            let percentChange = coin.priceChangePercentage24h ?? 0.0
                            let prices = coin.sparkLine?.price ?? []
                            SparklineView(prices: prices, isPositive: percentChange >= 0)
                                .frame(width: 60, height: 30)
                                .padding(.horizontal, 8)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(String(format: "$%.2f", coin.currentPrice))
                                    .font(.system(.headline, design: .rounded))
                                let percentChange = coin.priceChangePercentage24h ?? 0.0
                                Text(String(format: "%.2f%%", percentChange))
                                    .font(.subheadline)
                                    .foregroundColor(percentChange >= 0 ? .green : .red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct HeaderPortfolioView: View {
    let totalBalance: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Holding Value")
                    .font(.caption)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .tracking(1.0)
            }
            Divider()
                .background(Color.white.opacity(0.2))
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Invested Value")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .tracking(0.5)
                    Text(String(format: "$%.2f", totalBalance))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Available INR")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .tracking(0.5)
                    Text(String(format: "$%.2f", totalBalance))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    PortfolioListView(
        store: Store(initialState: PortfolioListFeature.State(coins: Coin.mockCoins)) {
            PortfolioListFeature()
        }
    )
}
