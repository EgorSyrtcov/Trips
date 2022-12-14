//
//  Request.swift
//  Trips
//
//  Created by Egor Syrtcov on 6.01.23.
//

import Foundation

final class Request {
    
    private struct Constants {
        static let baseUrl = "https://maps.googleapis.com/maps/api"
    }
    
    enum HTTPMethodType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    private let endPoint: Endpoint
    
    private let pathComponents: [String]
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        
        var string = Constants.baseUrl
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
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
    
    public var methodType: HTTPMethodType
    
    public var searchCity: String?
    
    init(
        endPoint: Endpoint,
        methodType: HTTPMethodType = .get,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endPoint = endPoint
        self.methodType = methodType
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}
