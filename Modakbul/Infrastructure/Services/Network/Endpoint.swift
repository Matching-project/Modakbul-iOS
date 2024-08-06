//
//  Endpoint.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation
import Alamofire

protocol URLComponentsConvertible {
    var httpMethod: HTTPMethod { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    
    func asURLComponents() -> URLComponents
}

extension URLComponentsConvertible {
    func asURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components
    }
}

protocol Requestable: URLComponentsConvertible {
    var httpHeaders: HTTPHeaders? { get }
    var httpBodies: [Data]? { get }
    
    var encoder: JSONEncodable { get }
}

extension Requestable {
    var encoder: JSONEncodable { JSONEncoder() }
}

enum Endpoint {
    // MARK: User Related
    case login(email: String, provider: String) // 로그인
    case checkNicknameForOverlap(nickname: String) // 닉네임 중복 확인
    case register(user: UserEntity, image: Data?) // 회원가입
    case logout // 로그아웃
    case reissueToken(refreshToken: String) // 토큰 재발행
    case updateProfile(token: String, user: UserEntity) // 프로필 수정
    case readProfile(token: String) // 회원 정보 조회
    
    // MARK: Place & Match Related
    case readPlaceList(lat: Double, lon: Double) // 카페 목록 조회
    case readBoardList(placeId: String) // 모집글 목록 조회
    case createBoard(token: String, placeId: String, communityRecruitingContent: CommunityRecruitingContentEntity) // 모집글 작성
    case readBoardForUpdate(token: String, communityRecruitingContentId: String) // 모집글 정보 조회
    case updateBoard(token: String, communityRecruitingContent: CommunityRecruitingContentEntity) // 모집글 수정
    case readBoardDetailList(placeId: String) // 모집글 목록 조회
    case readDetailBoard(placeId: String) // 모집글 상세 정보 조회
    case readMatches(token: String, communityRecruitingContentId: String) // 모임 참여 요청 목록 조회
    case requestMatch(token: String, communityRecruitingContentId: String) // 모임 참여 요청
    case acceptMatchRequest(token: String, matchingId: String) // 모임 참여 요청에 대한 수락
    case rejectMatchRequest(token: String, matchingId: String) // 모임 참여 요청에 대한 거절
    
    // MARK: Chat Related (WIP)
    case createChatRoom(token: String, communityRecruitingContentId: String, opponentUserId: String) // 채팅방 생성
    case exitChatRoom(token: String, chatRoomId: String) // 채팅방 나가기
//    case connectChatRoom(token: String, chatRoomId: String) // WIP
    
    private func encode(value: Encodable) -> Data? {
        guard let encodedData = try? encoder.encode(value) else { return nil }
        return encodedData
    }
    
    private func buildQueryItems(queries: (key: String, value: String)...) -> [URLQueryItem] {
        return queries.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

// MARK: Requestable Conformation
extension Endpoint: Requestable {
   var httpMethod: HTTPMethod {
        switch self {
        case .checkNicknameForOverlap, .readProfile, .readPlaceList, .readBoardList, .readBoardForUpdate, .readBoardDetailList, .readDetailBoard, .readMatches: return .get
        case .login, .register, .reissueToken, .createBoard, .requestMatch, .createChatRoom: return .post
        case .logout: return .delete
        case .updateProfile, .updateBoard, .acceptMatchRequest, .rejectMatchRequest, .exitChatRoom: return .patch
        }
    }
    
    var scheme: String { "https" }
    
    var host: String { "modakbul.com" } // TODO: 도메인 호스트는 서버 배포 이후에 나올 예정
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .checkNicknameForOverlap:
            return "/users"
        case .register:
            return "/users/register"
        case .logout:
            return "/users/logout"
        case .reissueToken:
            return "/token/reissue"
        case .updateProfile:
            return "/users/profile"
        case .readProfile:
            return "/users/mypage/profile"
        case .readPlaceList:
            return "/cafes"
        case .readBoardList(let placeId):
            return "/cafes/\(placeId)"
        case .createBoard(_, let placeId, _):
            return "/cafes/\(placeId)/boards"
        case .readBoardForUpdate(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)"
        case .updateBoard(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
        case .readBoardDetailList(let placeId):
            return "/cafes/boards/\(placeId)"
        case .readDetailBoard(let placeId):
            return "/cafes/boards/\(placeId)"
        case .readMatches(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)/matches"
        case .requestMatch(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)/matches"
        case .acceptMatchRequest(_, let matchingId):
            return "/matches/\(matchingId)/acceptance"
        case .rejectMatchRequest(_, let matchingId):
            return "/matches/\(matchingId)/rejection"
        case .createChatRoom:
            return "/chatrooms"
        case .exitChatRoom(_, let chatRoomId):
            return "/chatrooms/\(chatRoomId)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .checkNicknameForOverlap(let nickname):
            return buildQueryItems(queries: ("nickname", nickname))
        default:
            return nil
        }
    }
    
    var httpHeaders: HTTPHeaders? {
        switch self {
        case .login:
            [.contentType("Application/json")]
        case .register(let user, let data):
            [.contentType("Application/json")]
        case .reissueToken(let refreshToken):
            [.authorization(refreshToken)]
        case .updateProfile(let token, _):
            [.authorization(token), .contentType("Application/json")]
        case .readProfile(let token):
            [.authorization(token)]
        case .createBoard(let token, _, _):
            [.authorization(token), .contentType("Application/json")]
        case .readBoardForUpdate(let token, _):
            [.authorization(token)]
        case .updateBoard(let token, _):
            [.authorization(token), .contentType("Application/json")]
        case .readMatches(let token, _):
            [.authorization(token)]
        case .requestMatch(let token, _):
            [.authorization(token)]
        case .acceptMatchRequest(let token, _):
            [.authorization(token)]
        case .rejectMatchRequest(let token, _):
            [.authorization(token)]
        case .createChatRoom(let token, _, _):
            [.authorization(token)]
        case .exitChatRoom(let token, _):
            [.authorization(token)]
        default: nil
        }
    }
    
    var httpBodies: [Data]? {
        switch self {
        case .login(let email, let provider):
            <#code#>
        case .checkNicknameForOverlap(let nickname):
            <#code#>
        case .register(let user, let image):
            <#code#>
        case .logout:
            <#code#>
        case .reissueToken(let refreshToken):
            <#code#>
        case .updateProfile(let token, let user):
            <#code#>
        case .readProfile(let token):
            <#code#>
        case .readPlaceList(let lat, let lon):
            <#code#>
        case .readBoardList(let placeId):
            <#code#>
        case .createBoard(let token, let placeId, let communityRecruitingContent):
            <#code#>
        case .readBoardForUpdate(let token, let communityRecruitingContentId):
            <#code#>
        case .updateBoard(let token, let communityRecruitingContent):
            <#code#>
        case .readBoardDetailList(let placeId):
            <#code#>
        case .readDetailBoard(let placeId):
            <#code#>
        case .readMatches(let token, let communityRecruitingContentId):
            <#code#>
        case .requestMatch(let token, let communityRecruitingContentId):
            <#code#>
        case .acceptMatchRequest(let token, let matchingId):
            <#code#>
        case .rejectMatchRequest(let token, let matchingId):
            <#code#>
        case .createChatRoom(let token, let communityRecruitingContentId, let opponentUserId):
            <#code#>
        case .exitChatRoom(let token, let chatRoomId):
            <#code#>
        default: nil
        }
    }
}
