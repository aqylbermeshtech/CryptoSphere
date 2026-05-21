//
//  MarketListView.swift
//  CryptoSphere
//
//  Created by Nurtore on 21.05.2026.
//

import ComposableArchitecture
import SwiftUI

struct MarketListView: View {
    let store: StoreOf<MarketListFeature>
    
    var body: some View {
            NavigationStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    if store.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Market List Container")
                            .foregroundColor(.white)
                    }
                }
                .navigationTitle("Markets")
            }
    }
}


#Preview {
    MarketListView(
        store: Store(initialState: MarketListFeature.State()) {
            MarketListFeature()
        }
    )
}
