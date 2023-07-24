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
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL :/"
        case .httpError(let statusCode):
            return statusCode == 404 ? "Address not found" : "Http error status code: \(statusCode)"
        case .decodeError:
            fallthrough
        case .badServerResponse:
            return "Something went wrong :/"
        }
    }
}
