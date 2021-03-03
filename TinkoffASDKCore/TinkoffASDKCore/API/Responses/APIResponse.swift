//
//
//  APIResponse.swift
//
//  Copyright (c) 2021 Tinkoff Bank
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


import Foundation

class APIResponse<Model: Decodable>: Decodable {
    let success: Bool
    let terminalKey: String?
    let result: Swift.Result<Model, APIFailureError>
    
    private enum CodingKeys: CodingKey {
        case success
        case terminalKey
        
        var stringValue: String {
            switch self {
            case .success: return APIConstants.Keys.success
            case .terminalKey: return APIConstants.Keys.terminalKey
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        terminalKey = try container.decodeIfPresent(String.self, forKey: .terminalKey)
        success = try container.decode(Bool.self, forKey: .success)
        result = success
            ? .success(try Model(from: decoder))
            : .failure(try APIFailureError(from: decoder))
    }
    
    init(success: Bool,
         terminalKey: String?,
         result: Swift.Result<Model, APIFailureError>) {
        self.success = success
        self.terminalKey = terminalKey
        self.result = result
    }
}