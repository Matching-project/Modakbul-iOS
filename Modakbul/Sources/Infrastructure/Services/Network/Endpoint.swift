//
//  Endpoint.swift
//  Modakbul
//
//  Created by Swain Yun on 6/6/24.
//

import Foundation
import Moya

enum Endpoint {
    // MARK: - User Related
    case kakaoLogin(entity: KakaoLoginRequestEntity, provider: AuthenticationProvider)                                  // 카카오 로그인
    case appleLogin(entity: AppleLoginRequestEntity, provider: AuthenticationProvider)                                  // 애플 로그인
    case validateNicknameIntegrity(nickname: String)                                                                    // 닉네임 무결성 확인
    case kakaoRegister(user: KakaoUserRegistrationRequestEntity, image: Data?, provider: AuthenticationProvider)        // 카카오 회원가입
    case appleRegister(user: AppleUserRegistrationRequestEntity, image: Data?, provider: AuthenticationProvider)        // 애플 회원가입
    case unregister(token: String, provider: AuthenticationProvider)                                                    // 회원탈퇴
    case logout(token: String)                                                                                          // 로그아웃
    case reissueToken(refreshToken: String)                                                                             // 토큰 재발행
    case updateProfile(token: String, user: UserProfileUpdateRequestEntity, image: Data?)                               // 프로필 수정
    case readMyProfile(token: String)                                                                                   // 회원 정보 조회
    case block(token: String, opponentUserId: Int64)                                                                    // 사용자 차단
    case unblock(token: String, blockId: Int64)                                                                         // 사용자 차단 해제
    case readBlockedUsers(token: String)                                                                                // 차단한 사용자 목록 조회
    case readReports(token: String)                                                                                     // 신고 목록 조회
    case readOpponentUserProfile(token: String, userId: Int64)                                                          // 사용자(상대방) 프로필 조회
    case reportOpponentUserProfile(token: String, userId: Int64, report: Report)                                        // 사용자(상대방) 프로필 신고
    
    // MARK: - Place Related
    case readPlaces(name: String, lat: Double, lon: Double)                                                             // 카페 이름으로 검색
    case readPlacesByMatches(lat: Double, lon: Double)                                                                  // 카페 모임순 목록 조회
    case readPlacesByDistance(lat: Double, lon: Double)                                                                 // 카페 거리순 목록 조회
    case readPlacesForShowcaseAndReview(token: String)                                                                  // 카페 제보 및 리뷰 목록 조회
    case reviewPlace(token: String, placeId: Int64, review: ReviewPlaceRequestEntity)                                   // 카페 리뷰
    case suggestPlace(token: String, suggest: SuggestPlaceRequestEntity)                                                // 카페 제보
    
    // MARK: - Board Related
    case createBoard(token: String, placeId: Int64, communityRecruitingContent: CommunityRecruitingContentEntity)  // 모집글 작성
    case readBoards(token: String, placeId: Int64)        // 카페 모집글 목록 조회
    case readBoardForUpdate(token: String, communityRecruitingContentId: Int64)            // 모집글 수정 정보 조회
    case updateBoard(token: String, communityRecruitingContent: CommunityRecruitingContentEntity)                   // 모집글 수정
    case deleteBoard(token: String, communityRecruitingContentId: Int64)                                            // 모집글 삭제
    case readBoardDetail(communityRecruitingContentId: Int64)                                                       // 모집글 상세 조회
    case completeBoard(token: String, communityRecruitingContentId: Int64)                                          // 모집글 모집 종료
    case readMyBoards(token: String)       // 나의 모집글 목록 조회
    
    // MARK: - Match Related
    case readMatches(token: String, communityRecruitingContentId: Int64)                                                // 모임 참여 요청 목록 조회
    case requestMatch(token: String, communityRecruitingContentId: Int64)                                               // 모임 참여 요청
    case acceptMatchRequest(token: String, matchingId: Int64)                                                           // 모임 참여 요청에 대한 수락
    case rejectMatchRequest(token: String, matchingId: Int64)                                                           // 모임 참여 요청에 대한 거절
    case exitMatch(token: String, matchingId: Int64)                                                                    // 모임 나가기
    case cancelMatchRequest(token: String, matchingId: Int64)                                                           // 모임 참여 요청 취소
    case readMyMatches(token: String)                                                                                   // 참여 모임 내역 조회
    case readMyRequestMatches(token: String)                                                                            // 나의 참여 요청 목록 조회
    
    // MARK: - Chat Related
    case createChatRoom(token: String, configuration: ChatRoomConfigurationRequestEntity) // 채팅방 생성
    case readChatrooms(token: String)                           // 채팅방 목록 조회
    case readChatHistory(token: String, chatRoomId: Int64, communityRecruitingContentId: Int64) // 채팅기록 불러오기
    case exitChatRoom(token: String, chatRoomId: Int64)        // 채팅방 나가기
    case reportAndExitChatRoom(token: String, chatRoomId: Int64, userId: Int64, report: Report) // 채팅방 신고 후 나가기
    
    // MARK: - Notification Related
    case sendNotification(token: String, targetId: Int64, notification: NotificationSendingRequestEntity)// 알림 전송
    case fetchNotifications(token: String)                                              // 알림 목록 조회
    case removeNotifications(token: String, notificationsIds: NotificationRemovingRequestEntity)                  // 알림 삭제 (단일, 선택, 전체)
    case readNotification(token: String, notificationId: Int64)                         // 알림 읽기
}

extension Endpoint {
    private func encode<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let encodedData = try encoder.encode(value)
        return encodedData
    }
}

// MARK: TargetType Conformation
extension Endpoint: TargetType {
    var baseURL: URL { URL(string:"https://modakbul.store")! }
    
    var path: String {
        switch self {
            // MARK: User Related
        case .kakaoLogin(_, let provider):
            return "/users/login/\(provider.identifier)"
        case .appleLogin(_, let provider):
            return "/users/login/\(provider.identifier)"
        case .validateNicknameIntegrity:
            return "/users"
        case .kakaoRegister(_, _, let provider):
            return "/users/register/\(provider.identifier)"
        case .appleRegister(_, _, let provider):
            return "/users/register/\(provider.identifier)"
        case .unregister(_, let provider):
            return "/users/withdrawal/\(provider.identifier)"
        case .logout:
            return "/users/logout"
        case .reissueToken:
            return "/token/reissue"
        case .updateProfile:
            return "/users/profile"
        case .readMyProfile:
            return "/users/mypage/profile"
        case .readMyBoards:
            return "/users/boards"
        case .readMyMatches:
            return "/users/meetings"
        case .readMyRequestMatches:
            return "/users/matches/requests"
        case .block(_, let opponentUserId):
            return "/blocks/\(opponentUserId)"
        case .unblock(_, let blockId):
            return "/blocks/\(blockId)"
        case .readBlockedUsers:
            return "/users/blocks"
        case .readReports:
            return "/users/reports"
        case .readOpponentUserProfile(_, let userId):
            return "/users/profile/\(userId)"
        case .reportOpponentUserProfile(_, let userId, _):
            return "/reports/\(userId)"
            
            // MARK: Place Related
        case .readPlaces:
            return "/cafes"
        case .readPlacesByMatches:
            return "/cafes/meeting"
        case .readPlacesByDistance:
            return "/cafes/distance"
        case .readPlacesForShowcaseAndReview:
            return "users/cafes"
        case .reviewPlace(_, let placeId, _):
            return "/users/cafes/\(placeId)/reviews"
        case .suggestPlace:
            return "/users/cafes/information"
            
            // MARK: Board Related
        case .readBoards(_, let placeId):
            return "/cafes/\(placeId)/boards"
        case .createBoard(_, let placeId, _):
            return "/cafes/\(placeId)/boards"
        case .readBoardForUpdate(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)"
        case .updateBoard(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
        case .deleteBoard(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)"
        case .readBoardDetail(let communityRecruitingContentId):
            return "/cafes/boards/\(communityRecruitingContentId)"
        case .completeBoard(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)/completed"
            
            // MARK: Match Related
        case .readMatches(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)/matches"
        case .requestMatch(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)/matches"
        case .acceptMatchRequest(_, let matchingId):
            return "/matches/\(matchingId)/acceptance"
        case .rejectMatchRequest(_, let matchingId):
            return "/matches/\(matchingId)/rejection"
        case .exitMatch(_, let matchingId):
            return "/matches/\(matchingId)/exit"
        case .cancelMatchRequest(_, let matchingId):
            return "/matches/\(matchingId)/cancel"
            
            // MARK: Chat Related
        case .createChatRoom:
            return "/chatrooms"
        case .readChatrooms:
            return "/chatrooms"
        case .exitChatRoom(_, let chatRoomId):
            return "/chatrooms/\(chatRoomId)"
        case .readChatHistory(_, let chatRoomId, let communityRecruitingContentId):
            return "/chatrooms/\(chatRoomId)/\(communityRecruitingContentId)"
        case .reportAndExitChatRoom(_, let chatRoomId, let userId, _):
            return "/reports/\(chatRoomId)/\(userId)"
            
            // MARK: Notification Related
        case .sendNotification(_, let targetId, _):
            return "/notifications/\(targetId)"
        case .fetchNotifications:
            return "/notifications"
        case .removeNotifications:
            return "/notifications"
        case .readNotification(_, let notificationId):
            return "/notifications/\(notificationId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validateNicknameIntegrity, .readMyProfile, .readOpponentUserProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .readPlaces, .readPlacesByMatches, .readPlacesByDistance, .readPlacesForShowcaseAndReview, .readBoards, .readBoardForUpdate, .readBoardDetail, .readMatches, .readChatrooms, .readChatHistory, .readBlockedUsers, .readReports, .fetchNotifications:
            return .get
        case .kakaoLogin, .appleLogin, .kakaoRegister, .appleRegister, .reissueToken, .createBoard, .requestMatch, .createChatRoom, .block, .reviewPlace, .suggestPlace, .reportOpponentUserProfile, .reportAndExitChatRoom, .sendNotification:
            return .post
        case .logout, .unregister, .deleteBoard, .unblock, .removeNotifications:
            return .delete
        case .updateProfile, .updateBoard, .completeBoard, .acceptMatchRequest, .rejectMatchRequest, .exitMatch, .cancelMatchRequest, .exitChatRoom, .readNotification:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let entity, _):
            return .requestJSONEncodable(entity)
        case .appleLogin(let entity, _):
            return .requestJSONEncodable(entity)
        case .validateNicknameIntegrity(let nickname):
            return .requestParameters(parameters: ["nickname": "\(nickname)"], encoding: URLEncoding.queryString)
        case .kakaoRegister(let user, let image, _):
            var formData = [MultipartFormData]()
            
            if let user = try? encode(user) {
                formData.append(.init(provider: .data(user), name: "user", fileName: "user.json", mimeType: "application/json"))
            }
            
            if let image = image {
                formData.append(.init(provider: .data(image), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(formData)
        case .appleRegister(let user, let image, _):
            var formData = [MultipartFormData]()
            
            if let user = try? encode(user) {
                formData.append(.init(provider: .data(user), name: "user", fileName: "user.json", mimeType: "application/json"))
            }
            
            if let image = image {
                formData.append(.init(provider: .data(image), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(formData)
        case .updateProfile(_, let user, let image):
            var formData = [MultipartFormData]()
            
            if let user = try? encode(user) {
                formData.append(.init(provider: .data(user), name: "user", fileName: "user.json", mimeType: "application/json"))
            }
            
            if let image = image {
                formData.append(.init(provider: .data(image), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg"))
            }

            return .uploadMultipart(formData)
        case .reportOpponentUserProfile(_, _, let report):
            return .requestJSONEncodable(report)
        case .readPlaces(let name, let lat, let lon):
            return .requestParameters(parameters: ["name": "\(name)", "latitude": "\(lat)", "longitude": "\(lon)"], encoding: URLEncoding.queryString)
        case .readPlacesByMatches(let lat, let lon):
            return .requestParameters(parameters: ["latitude": "\(lat)", "longitude": "\(lon)"], encoding: URLEncoding.queryString)
        case .readPlacesByDistance(let lat, let lon):
            return .requestParameters(parameters: ["latitude": "\(lat)", "longitude": "\(lon)"], encoding: URLEncoding.queryString)
        case .createBoard(_, _, let communityRecruitingContent):
            return .requestJSONEncodable(communityRecruitingContent)
        case .updateBoard(_, let communityRecruitingContent):
            return .requestJSONEncodable(communityRecruitingContent)
        case .createChatRoom(_, let configuration):
            return .requestJSONEncodable(configuration)
        case .reviewPlace(_, _, let review):
            return .requestJSONEncodable(review)
        case .suggestPlace(_, let suggest):
            return .requestJSONEncodable(suggest)
        case .reportAndExitChatRoom(_, _, _, let report):
            return .requestJSONEncodable(report)
        case .sendNotification(_, _, let notification):
            return .requestJSONEncodable(notification)
        case .removeNotifications(_, let notificationsIds):
            return .requestJSONEncodable(notificationsIds)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            // MARK: User Related
        case .kakaoLogin, .appleLogin:
            ["Content-Type": "application/json"]
        case .kakaoRegister, .appleRegister:
            ["Content-Type": "multipart/form-data"]
        case .unregister(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .logout(let token):
            ["Authorization": "Bearer \(token)"]
        case .reissueToken(let refreshToken):
            ["Authorization": "\(refreshToken)"]
        case .updateProfile(let token, _, _):
            ["Content-Type": "application/json",
             "Authorization": "Bearer \(token)"]
        case .readMyProfile(let token):
            ["Authorization": "Bearer \(token)"]
        case .block(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .unblock(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .readBlockedUsers(let token):
            ["Authorization": "Bearer \(token)"]
        case .readReports(let token):
            ["Authorization": "Bearer \(token)"]
        case .readOpponentUserProfile(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .reportOpponentUserProfile(let token, _, _):
            ["Authorization": "Bearer \(token)"]
            
            // MARK: Place Related
        case .readPlacesForShowcaseAndReview(let token):
            ["Authorization": "Bearer \(token)"]
        case .reviewPlace(let token, _, _):
            ["Authorization": "Bearer \(token)"]
        case .suggestPlace(let token, _):
            ["Authorization": "Bearer \(token)"]
            
            // MARK: Board Related
        case .readBoards(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .readMyBoards(let token):
            ["Authorization": "Bearer \(token)"]
        case .createBoard(let token, _, _):
            ["Content-Type": "application/json",
             "Authorization": "Bearer \(token)"]
        case .readBoardForUpdate(let token, _):
            ["Authorization": "\(token)"]
        case .updateBoard(let token, _):
            ["Content-Type": "application/json",
             "Authorization": "Bearer \(token)"]
        case .deleteBoard(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .completeBoard(let token, _):
            ["Authorization": "Bearer \(token)"]
            
            // MARK: Match Related
        case .readMyMatches(let token):
            ["Authorization": "Bearer \(token)"]
        case .readMyRequestMatches(let token):
            ["Authorization": "Bearer \(token)"]
        case .readMatches(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .requestMatch(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .acceptMatchRequest(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .rejectMatchRequest(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .cancelMatchRequest(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .exitMatch(let token, _):
            ["Authorization": "Bearer \(token)"]
            
            // MARK: Chat Related
        case .createChatRoom(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .readChatrooms(let token):
            ["Authorization": "\(token)"]
        case .exitChatRoom(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .readChatHistory(let token, _, _):
            ["Authorization": "Bearer \(token)"]
        case .reportAndExitChatRoom(let token, _, _, _):
            ["Authorization": "Bearer \(token)"]
            
            // MARK: Notification Related
        case .sendNotification(let token, _, _):
            ["Authorization": "Bearer \(token)"]
        case .fetchNotifications(let token):
            ["Authorization": "Bearer \(token)"]
        case .removeNotifications(let token, _):
            ["Authorization": "Bearer \(token)"]
        case .readNotification(let token, _):
            ["Authorization": "Bearer \(token)"]
        default: nil
        }
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .logout, .unregister, .reissueToken, .updateProfile, .readMyProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .block, .unblock, .readBlockedUsers, .readReports, .readBoards, .createBoard, .readBoardForUpdate, .updateBoard, .deleteBoard, .completeBoard, .readMatches, .requestMatch, .acceptMatchRequest, .exitMatch, .rejectMatchRequest, .createChatRoom, .readChatrooms, .exitChatRoom, .cancelMatchRequest, .reportAndExitChatRoom, .reportOpponentUserProfile, .sendNotification, .fetchNotifications, .removeNotifications, .readNotification, .reviewPlace, .suggestPlace:
                .bearer
        default: .none
        }
    }
}
