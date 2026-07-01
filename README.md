# CryptoSphere


<div align="center">
  <video src="https://github.com/user-attachments/assets/ae0e9097-935d-4e31-ab6a-591dc218bd22" controls width="300"></video>
</div>







CryptoSphere is a modern, reactive iOS cryptocurrency tracking application built with **SwiftUI** and powered by **The Composable Architecture (TCA)**. The app fetches real-time market data from the CoinGecko API, allowing users to track trending coins, view live prices, monitor 24-hour price fluctuations, and manage a simulated investment portfolio balance.

## Features

- **Real-Time Crypto Tracking:** Fetches top cryptocurrencies with live prices, symbols, and 24-hour percentage changes.
- **Dynamic Portfolio Header:** Calculates your total portfolio balance reactively in real-time based on current token prices fetched from the API.
- **Smart Image Caching & Proxy Handling:** Uses a custom `URLSession` network layer with image filtering and caching to smoothly stream coin avatars without connection drops or TLS issues.
- **Clean Architecture:** Built strictly using the unidirectional data flow pattern of **The Composable Architecture (TCA)** for maximum testability and state management stability.

## Tech Stack & Architecture

- **User Interface:** SwiftUI (100% Programmatic/Declarative Layout)
- **Architecture:** The Composable Architecture (TCA) v1.25+
- **Concurrency:** Swift Async/Await (`.task` modifiers, native structured concurrency)
- **Networking:** Native `URLSession` combined with custom TLS/SSL handshaking policies.
- **Data Source:** CoinGecko API

---

## Project Structure

```text
CryptoSphere/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Models/
│   └── Coin.swift                 # Codable model mapping CoinGecko data
├── Features/
│   ├── CryptoListFeature.swift    # TCA Reducer managing State, Actions, and API Effects
│   └── CryptoListView.swift       # SwiftUI main list interface and portfolio views
└── Components/
    └── URLImage.swift             # Resilient, custom network image loader with caching
