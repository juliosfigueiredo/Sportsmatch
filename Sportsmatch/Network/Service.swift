//
//  Service.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import Foundation
import SwiftUI

enum Service {
    
    enum EndPoint:String {
        case base = "http://sportsmatch.com.br/teste/"
        case teste = "teste.json"
    }
    
    enum NetworkError {
        case badRequest
        case notFound
        case unauthorized
        case internalServerError
        case forbidden
    }
    
    enum Result {
        case success(Data)
        case failure(NetworkError, Data?)
    }
    
    enum ContentType: String {
        case json = "application/json"
        case formUrl = "application/x-www-form-urlencoded"
    }
    
    enum HttpMethod: String {
        case post
        case get
        case put
        case delete
    }
    
    private static func completeUrl(path: EndPoint) -> URLRequest? {
        guard let url = URL(string: "\(EndPoint.base.rawValue)\(path.rawValue)") else { return nil }
        return URLRequest(url: url)
    }
    
    private static func completeUrl(path: EndPoint, params: String) -> URLRequest? {
        guard let url = URL(string: "\(EndPoint.base.rawValue)\(path.rawValue)/\(params)") else { return nil }
        return URLRequest(url: url)
    }
    
    private static func call(path: EndPoint, parameter: String? = nil, contentType: ContentType, httpMethod: HttpMethod, data: Data?, completion: @escaping (Result) -> Void) {
        
        guard var urlRequest = completeUrl(path: path) else { return }
        
        if parameter != nil {
            urlRequest = completeUrl(path: path, params: parameter!)!
        }
        
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.internalServerError, nil))
                return
            }
            
            if let r = response as? HTTPURLResponse {
                switch r.statusCode {
                case 400:
                    completion(.failure(.badRequest, data))
                    break
                case 401:
                    completion(.failure(.unauthorized, data))
                    break
                case 403:
                    completion(.failure(.forbidden, data))
                    break
                case 404:
                    completion(.failure(.notFound, data))
                    break
                case 200:
                    completion(.success(data))
                    break
                case 500:
                    completion(.failure(.internalServerError, data))
                    break
                default:
                    break
                }
            }
        }
        task.resume()
    }
    
    public static func call<T: Encodable>(path: EndPoint, httpMethod: HttpMethod, body: T, completion: @escaping (Result) -> Void) {
        guard let jsonData = try? JSONEncoder().encode(body) else { return }
        call(path: path, contentType: .json, httpMethod: httpMethod, data: jsonData, completion: completion)
    }
    
    public static func call(path: EndPoint, httpMethod: HttpMethod, completion: @escaping (Result) -> Void) {
        call(path: path, contentType: .json, httpMethod: httpMethod, data: nil, completion: completion)
    }
    
    public static func call(path: EndPoint, parameter: String, httpMethod: HttpMethod, completion: @escaping (Result) -> Void) {
        call(path: path, parameter: parameter, contentType: .json, httpMethod: httpMethod, data: nil, completion: completion)
    }
    
    public static func call(path: EndPoint, params: [URLQueryItem], completion: @escaping (Result) -> Void) {
        guard let urlRequest = completeUrl(path: path) else { return }
        guard let absolutURL = urlRequest.url?.absoluteString else { return }
        var components = URLComponents(string: absolutURL)
        components?.queryItems = params
        
        call(path: path, contentType: .json, httpMethod: .post, data: components?.query?.data(using: .utf8), completion: completion)
    }
}

