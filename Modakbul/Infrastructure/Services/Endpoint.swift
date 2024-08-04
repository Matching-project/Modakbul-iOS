//
//  Endpoint.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation

protocol Requestable {
    var httpMethod: HTTPMethodType { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpBody: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    
    var jsonEncoder: JSONEncodable { get }
    
    func asURLRequest() -> URLRequest?
}

extension Requestable {
    var jsonEncoder: JSONEncodable { JSONEncoder() }
    
    func asURLRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let fullURL = components.url else { return nil }
        var request = URLRequest(url: fullURL)
        request.httpMethod = httpMethod.value
        request.httpBody = httpBody
        print(request)
        return request
    }
}

enum HTTPMethodType {
    case get, post, delete, patch
    
    var value: String? {
        switch self {
        case .get: "GET"
        case .post: "POST"
        case .delete: "DELETE"
        case .patch: "PATCH"
        }
    }
}

enum Endpoint {
    // MARK: User Related
    case login(email: String, provider: String) // 로그인
    case checkNicknameForOverlap(nickname: String) // 닉네임 중복 확인
    case register(user: UserEntity) // 회원가입
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
    
    private func encode<T: Encodable>(_ value: T) -> Data? {
        guard let data = try? jsonEncoder.encode(value) else {
            print("Encoding Failed on Request Body")
            return nil
        }
        return data
    }
    
    private func buildQueryItems(queries: (key: String, value: String)...) -> [URLQueryItem] {
        return queries.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

// MARK: Requestable Conformation
extension Endpoint: Requestable {
   var httpMethod: HTTPMethodType {
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
    
    var httpBody: Data? {
        switch self {
        case .login(let email, let provider):
            return encode(["email": email, "provider": provider])
        case .register(let user):
            return encode(user)
        case .reissueToken(let refreshToken):
            return encode(refreshToken)
        case .createBoard(_, _, let communityRecruitingContent):
            return encode(communityRecruitingContent)
        case .createChatRoom(_, let communityRecruitingContentId, let opponentUserId):
            return encode(["boardId": communityRecruitingContentId, "theOtherUserId": opponentUserId])
        default:
            return nil
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
}
