//
//  Request.swift
//  Trips
//
//  Created by Egor Syrtcov on 6.01.23.
//

import Foundation

final class Request {
    
    private struct Constants {
        static let baseUrl = "https://"
    }
    
    enum HTTPMethodType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    private let endPoint: Endpoint
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        
        var string = Constants.baseUrl
        string += endPoint.rawValue
        
        if !queryParameters.isEmpty {
            string += "?"
            
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            string += argumentString
        }
        return string
    }
    
    public var url: URL? {
        let сomponent = URLComponents(string: urlString)
        return сomponent?.url
    }
    
    public let methodType: HTTPMethodType
    
    init(
        endPoint: Endpoint,
        methodType: HTTPMethodType = .get,
        queryParameters: [URLQueryItem] = []
    ) {
        self.endPoint = endPoint
        self.methodType = methodType
        self.queryParameters = queryParameters
    }
}

extension Request {
    
    static let searchCity = Request(
        endPoint: .findPlace,
        queryParameters: [
            URLQueryItem(name: "fields", value: "formatted_address"),
            URLQueryItem(name: "input", value: "city"),
            URLQueryItem(name: "inputtype", value: "textquery"),
            URLQueryItem(name: "key", value: "AIzaSyD5w9hIjcghZtugzS_JW9Qhb7T1EoxOxJw")
        ]
    )
}

