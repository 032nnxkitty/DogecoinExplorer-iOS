//
//  NetworkError.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 20.07.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case httpError(statusCode: Int)
    case decodeError
    case badServerResponse
    case addressNotFound
    
    var description: String {
        switch self {
            
        case .invalidURL:
            return "Invalid URL"
        case .httpError(let statusCode):
            return "Http error status code: \(statusCode)"
        case .decodeError:
            fallthrough
        case .badServerResponse:
            return "Something went wrong"
        case .addressNotFound:
            return "Address not found"
        }
    }
}
