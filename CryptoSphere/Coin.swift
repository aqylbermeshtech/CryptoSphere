//
//  Coin.swift
//  CryptoSphere
//
//  Created by Nurtore on 19.05.2026.
//


import Foundation

struct Coin: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let priceChangePercentage24h: Double?
    let sparkLine: SparklineData?
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case sparkLine = "sparkline_in_7d"
    }
    
    struct SparklineData: Codable, Equatable {
        let price: [Double]
    }
    
    static let mock = Coin(
        id: "bitcoin",
        name: "Bitcoin",
        symbol: "btc",
        currentPrice: 65000.0,
        priceChangePercentage24h: 2.5,
        sparkLine: SparklineData(price: [64000, 64200, 64100, 64500, 64800, 65000]),
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"
    )
    
    static let mockCoins: [Coin] = [
            Coin(
                id: "bitcoin",
                name: "Bitcoin",
                symbol: "btc",
                currentPrice: 65230.0,
                priceChangePercentage24h: 3.45,
                sparkLine: SparklineData(price: [63000, 63500, 64000, 64800, 65230]),
                image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"
            ),
            Coin(
                id: "ethereum",
                name: "Ethereum",
                symbol: "eth",
                currentPrice: 3450.0,
                priceChangePercentage24h: -1.20,
                sparkLine: SparklineData(price: [3550, 3520, 3500, 3480, 3450]),
                image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png"
            ),
            Coin(
                id: "solana",
                name: "Solana",
                symbol: "sol",
                currentPrice: 145.75,
                priceChangePercentage24h: 5.82,
                sparkLine: SparklineData(price: [135, 138, 140, 142, 145.75]),
                image: "https://assets.coingecko.com/coins/images/4128/large/solana.png"
            ),
            Coin(
                id: "ripple",
                name: "Ripple",
                symbol: "xrp",
                currentPrice: 0.52,
                priceChangePercentage24h: -0.45,
                sparkLine: SparklineData(price: [0.54, 0.53, 0.53, 0.52, 0.52]),
                image: "https://assets.coingecko.com/coins/images/44/large/xrp.png"
            ),
            Coin(
                id: "cardano",
                name: "Cardano",
                symbol: "ada",
                currentPrice: 0.48,
                priceChangePercentage24h: 1.15,
                sparkLine: SparklineData(price: [0.46, 0.47, 0.46, 0.47, 0.48]),
                image: "https://assets.coingecko.com/coins/images/975/large/cardano.png"
            )
        ]
}
