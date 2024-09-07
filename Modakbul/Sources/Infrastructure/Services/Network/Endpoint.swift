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
    case login(token: Data?, provider: String)                  // 로그인
    case checkNicknameForOverlap(nickname: String)              // 닉네임 중복 확인
    case register(user: UserRegistrationRequestEntity, image: Data?)                        // 회원가입
    case logout(token: String)                                  // 로그아웃
    case reissueToken(refreshToken: String)                     // 토큰 재발행
    case updateProfile(token: String, user: UserProfileUpdateRequestEntity, image: Data?)   // 프로필 수정
    case readMyProfile(token: String)                           // 회원 정보 조회
    case readMyBoards(token: String)                            // 나의 모집글 목록 조회
    case readMyMatches(token: String)                           // 참여 모임 내역 조회
    case readMyRequestMatches(token: String)                    // 나의 참여 요청 목록 조회
    
    // MARK: - Place Related
    case readPlaces(name: String, lat: Double, lon: Double)     // 카페 이름으로 검색
    case readPlacesByMatches(lat: Double, lon: Double)          // 카페 모임순 목록 조회
    case readPlacesByDistance(lat: Double, lon: Double)         // 카페 거리순 목록 조회
    case readBoards(token: String, placeId: String)             // 카페 모집글 목록 조회
    
    // MARK: - Board Related
    case createBoard(token: String, placeId: String, communityRecruitingContent: CommunityRecruitingContentEntity)  // 모집글 작성
    case readBoardForUpdate(token: String, communityRecruitingContent: CommunityRecruitingContentEntity)            // 모집글 수정 정보 조회
    case updateBoard(token: String, communityRecruitingContent: CommunityRecruitingContentEntity)                   // 모집글 수정
    case deleteBoard(token: String, communityRecruitingContent: CommunityRecruitingContentEntity)                   // 모집글 삭제
    case readBoardDetail(communityRecruitingContentId: String)                                                      // 모집글 상세 조회
    
    // MARK: - Match Related
    case readMatches(token: String, communityRecruitingContentId: String)   // 모임 참여 요청 목록 조회
    case requestMatch(token: String, communityRecruitingContentId: String)  // 모임 참여 요청
    case acceptMatchRequest(token: String, matchingId: String)  // 모임 참여 요청에 대한 수락
    case rejectMatchRequest(token: String, matchingId: String)  // 모임 참여 요청에 대한 거절
    
    // MARK: - Chat Related
    case createChatRoom(token: String, communityRecruitingContentId: String, opponentUserId: String) // 채팅방 생성
    case readChatrooms(token: String)                           // 채팅방 목록 조회
    case exitChatRoom(token: String, chatRoomId: String)        // 채팅방 나가기
    
    // MARK: - Notification Related
    case sendNotification(token: String, notification: NotificationSendingRequestEntity)// 알림 전송
    case fetchNotifications(token: String)                                              // 알림 목록 조회
    case removeNotifications(token: String, notificationsIds: [Int64])                  // 알림 삭제 (단일, 선택, 전체)
    case readNotification(token: String, notificationId: Int64)                         // 알림 읽기
}

extension Endpoint {
    private func encode<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let encodedData = try encoder.encode(value)
        return encodedData
    }
}

// MARK: Requestable Conformation
extension Endpoint: TargetType {
    var baseURL: URL { URL(string:"https://modakbul.com")! } // TODO: 도메인 호스트는 서버 배포 이후에 나올 예정
    
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
        case .readMyProfile:
            return "/users/mypage/profile"
        case .readMyBoards:
            return "/users/boards"
        case .readMyMatches:
            return "/users/meetings"
        case .readMyRequestMatches:
            return "/users/matches/requests"
        case .readPlaces:
            return "/cafes"
        case .readPlacesByMatches:
            return "/cafes/meeting"
        case .readPlacesByDistance:
            return "/cafes/distance"
        case .readBoards(_, let placeId):
            return "/cafes/\(placeId)/boards"
        case .createBoard(_, let placeId, _):
            return "/cafes/\(placeId)/boards"
        case .readBoardForUpdate(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
        case .updateBoard(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
        case .deleteBoard(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
        case .readBoardDetail(let communityRecruitingContentId):
            return "/cafes/boards/\(communityRecruitingContentId)"
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
        case .readChatrooms:
            return "/chatrooms"
        case .exitChatRoom(_, let chatRoomId):
            return "/chatrooms/\(chatRoomId)"
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
        case .checkNicknameForOverlap, .readMyProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .readPlaces, .readPlacesByMatches, .readPlacesByDistance, .readBoards, .readBoardForUpdate, .readBoardDetail, .readMatches, .readChatrooms, .fetchNotifications: return .get
        case .login, .register, .reissueToken, .createBoard, .requestMatch, .createChatRoom, .sendNotification: return .post
        case .logout, .deleteBoard, .removeNotifications: return .delete
        case .updateProfile, .updateBoard, .acceptMatchRequest, .rejectMatchRequest, .exitChatRoom, .readNotification: return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(_, let provider):
            return .requestParameters(parameters: ["provider": "\(provider)"], encoding: JSONEncoding.default)
        case .checkNicknameForOverlap(let nickname):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["nickname": "\(nickname)"])
        // TODO: - image 파라미터 빼고 user.imageURL을 개선하기
        case .register(let user, let image):
            var formData = [MultipartFormData]()

            do {
                let data = try encode(user)
                formData.append(MultipartFormData(provider: .data(data), name: "user"))
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
            
        case .logout:
            return .requestPlain
        case .reissueToken:
            return .requestPlain
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
        case .readMyProfile:
            return .requestPlain
        case .readMyBoards:
            return .requestPlain
        case .readMyMatches:
            return .requestPlain
        case .readMyRequestMatches:
            return .requestPlain
        case .readPlaces(name: let name, lat: let lat, lon: let lon):
            return .requestParameters(parameters: ["name": "\(name)", "latitude": "\(lat)", "longitude": "\(lon)"], encoding: URLEncoding.queryString)
        case .readPlacesByMatches(lat: let lat, lon: let lon):
            return .requestParameters(parameters: ["latitude": "\(lat)", "longitude": "\(lon)"], encoding: URLEncoding.queryString)
        case .readPlacesByDistance(let lat, let lon):
            return .requestParameters(parameters: ["latitude": "\(lat)", "longitude": "\(lon)"], encoding: URLEncoding.queryString)
        case .readBoards:
            return .requestPlain
        case .createBoard(_, _, let communityRecruitingContent):
            let communityRecruitingContent = try? encode(communityRecruitingContent)
            return .requestJSONEncodable(communityRecruitingContent)
        case .readBoardForUpdate:
            return .requestPlain
        case .updateBoard(_, let communityRecruitingContent):
            let communityRecruitingContent = try? encode(communityRecruitingContent)
            return .requestJSONEncodable(communityRecruitingContent)
        case .deleteBoard:
            return .requestPlain
        case .readBoardDetail:
            return .requestPlain
        case .readMatches:
            return .requestPlain
        case .requestMatch(_, let communityRecruitingContentId):
            return .requestParameters(parameters: ["boardId": "\(communityRecruitingContentId)"], encoding: JSONEncoding.default)
        case .acceptMatchRequest:
            return .requestPlain
        case .rejectMatchRequest:
            return .requestPlain
        case .createChatRoom(_, let communityRecruitingContentId, let opponentUserId):
            return .requestParameters(parameters: ["boardId": "\(communityRecruitingContentId)", "theOtherUserId": "\(opponentUserId)"], encoding: JSONEncoding.default)
        case .readChatrooms:
            return .requestPlain
        case .exitChatRoom:
            return .requestPlain
        case .sendNotification(_, let notification):
            return .requestJSONEncodable(notification)
        case .removeNotifications(_, let notificationsIds):
            return .requestParameters(parameters: ["notificationIds": notificationsIds], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(let token,  _):
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
        case .readMyBoards(let token):
            ["Authorization": "\(token)"]
        case .readMyMatches(let token):
            ["Authorization": "\(token)"]
        case .readMyRequestMatches(let token):
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
        case .readMatches(let token, _):
            ["Authorization": "\(token)"]
        case .requestMatch(let token, _):
            ["Authorization": "\(token)"]
        case .acceptMatchRequest(let token, _):
            ["Authorization": "\(token)"]
        case .rejectMatchRequest(let token, _):
            ["Authorization": "\(token)"]
        case .createChatRoom(let token, _, _):
            ["Authorization": "\(token)"]
        case .readChatrooms(let token):
            ["Authorization": "\(token)"]
        case .exitChatRoom(let token, _):
            ["Authorization": "\(token)"]
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
          case .login, .logout, .reissueToken, .updateProfile, .readMyProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .createBoard, .readBoardForUpdate, .updateBoard, .deleteBoard, .readMatches, .requestMatch, .acceptMatchRequest, .rejectMatchRequest, .createChatRoom, .readChatrooms, .exitChatRoom, .sendNotification, .fetchNotifications, .removeNotifications, .readNotification:
                  .bearer
          default: .none
          }
      }
}
