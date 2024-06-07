//
//  Bundle+Extension.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 6/5/24.
//

import Foundation

extension Bundle {
    // MARK: Nested Types
    private enum FetchingAPIKeyError: Error, CustomDebugStringConvertible {
        case fileNotFound, keyNotFound
        
        var debugDescription: String {
            switch self {
            case .fileNotFound: "번들에서 파일을 찾을 수 없음"
            case .keyNotFound: "번들에서 키를 찾을 수 없음"
            }
        }
    }
    
    // MARK: Public Methods
    func getAPIKey(provider: AuthenticationProvider) -> String? {
        switch fetchKey(provider: provider) {
        case .success(let key):
            return key
        case .failure(let error):
            print(error.debugDescription)
            return nil
        }
    }
    
    // MARK: Private Methods
    private func fetchKey(provider: AuthenticationProvider) -> Result<String, FetchingAPIKeyError> {
           
        guard let apikey = Bundle.main.object(forInfoDictionaryKey: provider.infoDictionaryKey) as? String
        else {
            return .failure(.keyNotFound)
        }
                
        return .success(apikey)
    }
}
