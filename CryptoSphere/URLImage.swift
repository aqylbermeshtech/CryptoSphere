//
//  URLImage.swift
//  CryptoSphere
//
//  Created by Nurtore on 19.05.2026.
//

import SwiftUI

final class TLSResolverDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

struct URLImage: View {
    let urlString: String
    @State private var imageData: Data? = nil
    @State private var isError: Bool = false

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.httpShouldUsePipelining = true
        return URLSession(configuration: configuration, delegate: TLSResolverDelegate(), delegateQueue: nil)
    }()
    
    var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
            } else if isError {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        Image(systemName: "bitcoinsign.circle")
                            .foregroundColor(.gray.opacity(0.4))
                    )
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                    )
            }
        }
        .task(id: urlString) {
            await loadImage()
        }
    }
    
    @MainActor
    private func loadImage() async {
        let cleanUrlString = urlString.components(separatedBy: "?").first ?? urlString

        let cacheComponents = URLComponents(string: cleanUrlString)
        if let cacheUrl = cacheComponents?.url {
            let cacheRequest = URLRequest(url: cacheUrl)
            if let cachedResponse = URLCache.shared.cachedResponse(for: cacheRequest) {
                self.imageData = cachedResponse.data
                return
            }
        }

        let proxiedUrlString = "https://images.weserv.nl/?url=\(cleanUrlString.replacingOccurrences(of: "https://", with: ""))"
        
        guard let url = URL(string: proxiedUrlString) else {
            self.isError = true
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.isError = true
                return
            }
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)
            
            self.imageData = data
        } catch {
            self.isError = true
        }
    }
}
