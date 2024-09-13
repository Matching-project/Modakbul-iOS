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
    case login(token: Data?, provider: String, fcm: String)                                             // 로그인
    case validateNicknameIntegrity(nickname: String)                                                    // 닉네임 무결성 확인
    case register(user: UserRegistrationRequestEntity, image: Data?, provider: String, fcm: String)     // 회원가입
    case logout(token: String)                                                                          // 로그아웃
    case reissueToken(refreshToken: String)                                                             // 토큰 재발행
    case updateProfile(token: String, user: UserProfileUpdateRequestEntity, image: Data?)               // 프로필 수정
    case readMyProfile(token: String)                                                                   // 회원 정보 조회
    case block(token: String, opponentUserId: Int64)                                                    // 사용자 차단
    case unblock(token: String, blockId: Int64)                                                         // 사용자 차단 해제
    case readBlockedUsers(token: String)                                                                // 차단한 사용자 목록 조회
    case readReports(token: String)                                                                     // 신고 목록 조회
    case readOpponentUserProfile(token: String, userId: Int64)                                          // 사용자(상대방) 프로필 조회
    case reportOpponentUserProfile(token: String, userId: Int64, report: Report)                        // 사용자(상대방) 프로필 신고
    
    // MARK: - Place Related
    case readPlaces(name: String, lat: Double, lon: Double)                                         // 카페 이름으로 검색
    case readPlacesByMatches(lat: Double, lon: Double)                                              // 카페 모임순 목록 조회
    case readPlacesByDistance(lat: Double, lon: Double)                                             // 카페 거리순 목록 조회
    case readPlacesForShowcaseAndReview(token: String)                                              // 카페 제보 및 리뷰 목록 조회
    case reviewPlace(placeId: Int64, review: ReviewPlaceRequestEntity)                              // 카페 리뷰
    case suggestPlace(suggest: SuggestPlaceRequestEntity)                                           // 카페 제보
    
    // MARK: - Board Related
    case createBoard(token: String, placeId: Int64, communityRecruitingContent: CommunityRecruitingContentEntity)  // 모집글 작성
    case readBoards(placeId: Int64)        // 카페 모집글 목록 조회
    case readBoardForUpdate(token: String, communityRecruitingContentId: Int64)            // 모집글 수정 정보 조회
    case updateBoard(token: String, communityRecruitingContent: CommunityRecruitingContentEntity)                   // 모집글 수정
    case deleteBoard(token: String, communityRecruitingContent: CommunityRecruitingContentEntity)                   // 모집글 삭제
    case readBoardDetail(communityRecruitingContentId: Int64)                                                       // 모집글 상세 조회
    case completeBoard(token: String, communityRecruitingContentId: Int64)                                          // 모집글 모집 종료
    case readMyBoards(token: String)       // 나의 모집글 목록 조회
    
    // MARK: - Match Related
    case readMatches(token: String, communityRecruitingContentId: Int64)   // 모임 참여 요청 목록 조회
    case requestMatch(token: String, communityRecruitingContentId: Int64)  // 모임 참여 요청
    case acceptMatchRequest(token: String, matchingId: Int64)              // 모임 참여 요청에 대한 수락
    case rejectMatchRequest(token: String, matchingId: Int64)              // 모임 참여 요청에 대한 거절
    case exitMatch(token: String, matchingId: Int64)                       // 모임 나가기
    case cancelMatchRequest(token: String, matchingId: Int64)              // 모임 참여 요청 취소
    case readMyMatches(token: String)                                      // 참여 모임 내역 조회
    case readMyRequestMatches(token: String)                               // 나의 참여 요청 목록 조회
    
    // MARK: - Chat Related
    case createChatRoom(token: String, configuration: ChatRoomConfigurationRequestEntity) // 채팅방 생성
    case readChatrooms(token: String)                           // 채팅방 목록 조회
    case readChatHistory(token: String, chatRoomId: Int64, communityRecruitingContentId: Int64) // 채팅기록 불러오기
    case exitChatRoom(token: String, chatRoomId: Int64)        // 채팅방 나가기
    case reportAndExitChatRoom(token: String, chatRoomId: Int64, userId: Int64, report: Report) // 채팅방 신고 후 나가기
    
    // MARK: - Notification Related
    case sendNotification(token: String, notification: NotificationSendingRequestEntity)// 알림 전송
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
    var baseURL: URL { URL(string:"https://modakbul.com")! } // TODO: 도메인 호스트는 서버 배포 이후에 나올 예정
    
    var path: String {
        switch self {
            // MARK: User Related
        case .login(_, let provider, _):
            return "/users/login/\(provider)"
        case .validateNicknameIntegrity:
            return "/users"
        case .register(_, _, let provider, _):
            return "/users/register/\(provider)"
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
        case .reviewPlace(let placeId, _):
            return "/users/cafes/\(placeId)/reviews"
        case .suggestPlace:
            return "/users/cafes/information"
            
            // MARK: Board Related
        case .readBoards(let placeId):
            return "/cafes/\(placeId)/boards"
        case .createBoard(_, let placeId, _):
            return "/cafes/\(placeId)/boards"
        case .readBoardForUpdate(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)"
        case .updateBoard(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
        case .deleteBoard(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
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
        case .sendNotification(_, let notification):
            return "/notifications/\(notification.opponentUserId)"
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
        case .validateNicknameIntegrity, .readMyProfile, .readOpponentUserProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .readPlaces, .readPlacesByMatches, .readPlacesByDistance, .readPlacesForShowcaseAndReview, .readBoards, .readBoardForUpdate, .readBoardDetail, .readMatches, .readChatrooms, .readChatHistory, .completeBoard, .readBlockedUsers, .readReports, .fetchNotifications: return .get
        case .login, .register, .reissueToken, .createBoard, .requestMatch, .createChatRoom, .block, .reviewPlace, .suggestPlace, .reportOpponentUserProfile, .reportAndExitChatRoom, .sendNotification: return .post
        case .logout, .deleteBoard, .unblock, .removeNotifications: return .delete
        case .updateProfile, .updateBoard, .acceptMatchRequest, .rejectMatchRequest, .exitMatch, .cancelMatchRequest, .exitChatRoom, .readNotification: return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .validateNicknameIntegrity(let nickname):
            return .requestParameters(parameters: ["nickname": "\(nickname)"], encoding: URLEncoding.queryString)
        case .register(let user, let image, _, let fcm):
            var formData = [MultipartFormData]()

            do {
                let user = try encode(user)
                formData.append(MultipartFormData(provider: .data(user), name: "user"))
                let fcm = try encode(fcm)
                formData.append(MultipartFormData(provider: .data(fcm), name: "fcm"))
            } catch {
                print(error)
            }
            
            if let image = image {
                formData.append(MultipartFormData(provider: .data(image),
                                                  name: "\(image)",
                                                  fileName: "image",
                                                  mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(formData)
        case .updateProfile(_, let user, let image):
            var formData = [MultipartFormData]()

            do {
                let user = try encode(user)
                
                formData.append(MultipartFormData(provider: .data(user), name: "user"))
            } catch {
                print(error)
            }
            
            if let image = image {
                formData.append(MultipartFormData(provider: .data(image),
                                                  name: "\(image)",
                                                  fileName: "image",
                                                  mimeType: "image/jpeg"))
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
            let communityRecruitingContent = try? encode(communityRecruitingContent)
            return .requestJSONEncodable(communityRecruitingContent)
        case .updateBoard(_, let communityRecruitingContent):
            let communityRecruitingContent = try? encode(communityRecruitingContent)
            return .requestJSONEncodable(communityRecruitingContent)
        case .createChatRoom(_, let configuration):
            return .requestJSONEncodable(configuration)
        case .reviewPlace(_, let review):
            return .requestJSONEncodable(review)
        case .suggestPlace(let suggest):
            return .requestJSONEncodable(suggest)
        case .reportAndExitChatRoom(_, _, _, let report):
            return .requestJSONEncodable(report)
        case .sendNotification(_, let notification):
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
        case .login(let token, _, _):
            ["Content-type": "application/json",
             "Authorization": "\(String(describing: token))"]
        case .register:
            ["Content-type": "application/json"]
        case .logout(let token):
            ["Authorization": "\(token)"]
        case .reissueToken(let refreshToken):
            ["Authorization": "\(refreshToken)"]
        case .updateProfile(let token, _, _):
            ["Content-type": "application/json",
             "Authorization": "\(token)"]
        case .readMyProfile(let token):
            ["Authorization": "\(token)"]
        case .block(let token, _):
            ["Authorization": "\(token)"]
        case .unblock(let token, _):
            ["Authorization": "\(token)"]
        case .readBlockedUsers(let token):
            ["Authorization": "\(token)"]
        case .readReports(let token):
            ["Authorization": "\(token)"]
        case .readOpponentUserProfile(let token, _):
            ["Authorization": "\(token)"]
            
            // MARK: Place Related
        case .readPlacesForShowcaseAndReview(let token):
            ["Authorization": "\(token)"]
            
            // MARK: Board Related
        case .readMyBoards(let token):
            ["Authorization": "\(token)"]
        case .createBoard(let token, _, _):
            ["Content-type": "application/json",
             "Authorization": "\(token)"]
        case .readBoardForUpdate(let token, _):
            ["Authorization": "\(token)"]
        case .updateBoard(let token, _):
            ["Content-type": "application/json",
             "Authorization": "\(token)"]
        case .deleteBoard(let token, _):
            ["Authorization": "\(token)"]
        case .completeBoard(let token, _):
            ["Authorization": "\(token)"]
            
            // MARK: Match Related
        case .readMyMatches(let token):
            ["Authorization": "\(token)"]
        case .readMyRequestMatches(let token):
            ["Authorization": "\(token)"]
        case .readMatches(let token, _):
            ["Authorization": "\(token)"]
        case .requestMatch(let token, _):
            ["Authorization": "\(token)"]
        case .acceptMatchRequest(let token, _):
            ["Authorization": "\(token)"]
        case .rejectMatchRequest(let token, _):
            ["Authorization": "\(token)"]
        case .cancelMatchRequest(let token, _):
            ["Authorization": "\(token)"]
            
            // MARK: Chat Related
        case .createChatRoom(let token, _):
            ["Authorization": "\(token)"]
        case .readChatrooms(let token):
            ["Authorization": "\(token)"]
        case .exitChatRoom(let token, _):
            ["Authorization": "\(token)"]
        case .readChatHistory(let token, _, _):
            ["Authorization": "\(token)"]
        case .reportAndExitChatRoom(let token, _, _, _):
            ["Authorization": "\(token)"]
            
            // MARK: Notification Related
        case .sendNotification(let token, _):
            ["Authorization": "\(token)"]
        case .fetchNotifications(let token):
            ["Authorization": "\(token)"]
        case .removeNotifications(let token, _):
            ["Authorization": "\(token)"]
        case .readNotification(let token, _):
            ["Authorization": "\(token)"]
        default: nil
        }
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .login, .logout, .reissueToken, .updateProfile, .readMyProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .block, .unblock, .readBlockedUsers, .readReports, .createBoard, .readBoardForUpdate, .updateBoard, .deleteBoard, .completeBoard, .readMatches, .requestMatch, .acceptMatchRequest, .rejectMatchRequest, .createChatRoom, .readChatrooms, .exitChatRoom, .cancelMatchRequest, .reportAndExitChatRoom, .reportOpponentUserProfile, .sendNotification, .fetchNotifications, .removeNotifications, .readNotification:
                .bearer
        default: .none
        }
    }
}
