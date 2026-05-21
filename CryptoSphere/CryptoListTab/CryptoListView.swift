//
//  CryptoListView.swift
//  CryptoSphere
//
//  Created by Nurtore on 19.05.2026.
//

import ComposableArchitecture
import SwiftUI

struct CryptoListView: View {
    @Bindable var store: StoreOf<CryptoListFeature>
    
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
                    HeaderBalanceView()
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                Section {
                    Text("Trending Coins")
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

// MARK: - Header Balance View
struct HeaderBalanceView: View {

    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome, Friend")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .tracking(1.0)

            Text("Make your first investment today")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .tracking(1.0)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Button(action: {}) {
                Text("Invest today")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    CryptoListView(
        store: Store(initialState: CryptoListFeature.State(coins: [Coin.mock])) {
//            CryptoListFeature()
        }
    )
}
