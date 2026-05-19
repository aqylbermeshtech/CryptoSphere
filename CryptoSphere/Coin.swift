//
//  Coin.swift
//  CryptoSphere
//
//  Created by Nurtore on 19.05.2026.
//


import Foundation

import Foundation

struct Coin: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let priceChangePercentage24h: Double?
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
    
    static let mock = Coin(
        id: "bitcoin",
        name: "Bitcoin",
        symbol: "btc",
        currentPrice: 65000.0,
        priceChangePercentage24h: 2.5,
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"
    )
}
