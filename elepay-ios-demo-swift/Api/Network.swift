//
//  Network.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/12.
//

import Foundation

protocol ReqInterceptor {
  func adapt(_ urlRequest: URLRequest, completion: (URLRequest) -> Void)
}

// MARK: HttpHeader

struct HTTPHeader: Equatable, Hashable, Sendable {
  public let name: String
  public let value: String
  public init(name: String, value: String) {
    self.name = name
    self.value = value
  }
}

extension HTTPHeader {
  static func accept(_ value: String) -> HTTPHeader {
    HTTPHeader(name: "Accept", value: value)
  }

  static func userAgent(_ value: String) -> HTTPHeader {
    HTTPHeader(name: "User-Agent", value: value)
  }

  static func authorization(bearerToken: String) -> HTTPHeader {
    HTTPHeader(name: "Authorization", value: "Bearer \(bearerToken)")
  }

  static func contentType(_ value: String) -> HTTPHeader {
    HTTPHeader(name: "Content-Type", value: value)
  }

  static func contentEncoding(_ value: String) -> HTTPHeader {
    HTTPHeader(name: "Content-Encoding", value: value)
  }

  static func acceptEncoding(_ value: String) -> HTTPHeader {
    HTTPHeader(name: "Accept-Encoding", value: value)
  }
}

// MARK: HTTPMethod

enum HTTPMethod: String {
  case POST
  case GET
}

// MARK: NetError

enum NetError: Error {
  case unknown
  case urlInvalid
  case code(Int, String)
}

// MARK: HeaderInterceptor

/// dynamic apply request headers
class HeaderInterceptor: ReqInterceptor {
  var token: String = "" {
    didSet {
      headers.append(.authorization(bearerToken: token))
    }
  }

  private var headers: [HTTPHeader] = [
    .accept("application/json"),
    .contentType("application/json"),
  ]

  func adapt(_ urlRequest: URLRequest, completion: (URLRequest) -> Void) {
    var adaptedRequest = urlRequest
    for header in headers {
      adaptedRequest.setValue(header.value, forHTTPHeaderField: header.name)
    }
    completion(adaptedRequest)
  }
}

// MARK: Network

class Network {
  let headerInterceptor: HeaderInterceptor
  let session: URLSession

  init(interceptor: HeaderInterceptor) {
    headerInterceptor = interceptor

    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 60

    session = URLSession(configuration: configuration)
  }

  func request(
    url: String,
    method: HTTPMethod = .POST,
    data: Data? = nil,
    completion: @escaping (Result<Data, NetError>) -> Void
  ) {
    let wrapcompletion: (Result<Data, NetError>) -> Void = { result in
      DispatchQueue.main.async {
        switch result {
        case let .success(data):
          completion(.success(data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
    }

    guard !url.isEmpty else {
      wrapcompletion(.failure(NetError.urlInvalid))
      return
    }
    guard let URL = URL(string: url) else {
      wrapcompletion(.failure(NetError.urlInvalid))
      return
    }

    // adapt headers
    var req = URLRequest(url: URL)
    headerInterceptor.adapt(req) { ret in
      req = ret
    }

    // manager req params

    req.httpMethod = method.rawValue

    if let data {
      req.httpBody = data
    }

    // start req

    let task = session.dataTask(with: req) { data, response, error in
      if error != nil {
        wrapcompletion(.failure(NetError.unknown))
        return
      }

      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data else {
        let httpRes = response as? HTTPURLResponse
        let code = httpRes?.statusCode ?? 500

        var msg = "[ErrorCode]->\(code)"
        if let data,
           let errorJSON = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
           let errorCode = errorJSON["code"] as? String,
           let errorMsg = errorJSON["message"] as? String {
          msg = msg + "\n[ServiceCode]-> " + errorCode + "\n[Message]-> " + errorMsg
        }

        wrapcompletion(.failure(NetError.code(code, msg)))
        return
      }

      wrapcompletion(.success(data))
    }
    task.resume()
  }
}

extension Network {
  func requestJSON(
    url: String,
    method: HTTPMethod = .POST,
    params: [String: Any]? = nil,
    data: Data? = nil,
    completion: @escaping (Result<[String: Any], NetError>) -> Void
  ) {
    var raw: Data?
    if let _binary = params {
      raw = try? JSONSerialization.data(withJSONObject: _binary, options: [])
    }
    if let _binary = data {
      raw = _binary
    }

    request(url: url, method: method, data: raw) { result in
      switch result {
      case let .success(data):
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) else {
          completion(.failure(NetError.unknown))
          return
        }
        guard let json = obj as? [String: Any] else {
          completion(.failure(NetError.unknown))
          return
        }
        completion(.success(json))

      case let .failure(failure):
        completion(.failure(failure))
        return
      }
    }
  }

  func requestModel<T: Decodable>(
    url: String,
    model: T.Type = T.self,
    method: HTTPMethod = .POST,
    params: [String: Any]? = nil,
    data: Data? = nil,
    completion: @escaping (Result<T, NetError>) -> Void
  ) {
    var raw: Data?
    if let _binary = params {
      raw = try? JSONSerialization.data(withJSONObject: _binary, options: [])
    }
    if let _binary = data {
      raw = _binary
    }

    request(url: url, method: method, data: raw) { result in
      switch result {
      case let .success(data):
        guard let obj = try? JSONDecoder().decode(model.self, from: data) else {
          completion(.failure(NetError.unknown))
          return
        }
        completion(.success(obj))

      case let .failure(failure):
        completion(.failure(failure))
        return
      }
    }
  }
}
