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
    case login(token: Data, provider: String)                   // 로그인
    case checkNicknameForOverlap(nickname: String)              // 닉네임 중복 확인
    case register(user: UserEntity, image: Data?)               // 회원가입
    case logout(token: String)                                  // 로그아웃
    case reissueToken(refreshToken: String)                     // 토큰 재발행
    case updateProfile(token: String, user: UserEntity)         // 프로필 수정
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
    case readBoardForUpdate(token: String, communityRecruitingContentId: String)                                    // 모집글 수정 정보 조회
    case updateBoard(token: String, communityRecruitingContent: CommunityRecruitingContentEntity)                   // 모집글 수정
    case deleteBoard(token: String, communityRecruitingContentId: String)                                           // 모집글 삭제
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
}


extension Endpoint {
    private func encode<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let encodedData = try encoder.encode(value)
        return encodedData
    }
    
    private func appendToMultipartFormData(from datasets: [String: Any?]) -> [MultipartFormData] {
        var formData = [MultipartFormData]()
        
        for (key, value) in datasets {
            // MARK: - 단순 값들을 받을 때
            if let encodableValue = value as? Encodable {
                do {
                    let encodedData = try encode(encodableValue)
                    formData.append(MultipartFormData(provider: .data(encodedData), name: key))
                } catch {
                    print("Failed to encode \(key):", error)
                }
            // MARK: - 여러 이미지를 받을 때
            } else if let imageDatas = value as? [Data] {
                for (index, imageData) in imageDatas.enumerated() {
                    formData.append(MultipartFormData(provider: .data(imageData),
                                                      name: "\(key)_\(index)",
            // TODO: - fileName: 클라이언트에선 DTO로 image.jpg 대신 image로 해야 받아지는데, 백엔드에서는 어떻게 받아질지 몰라서 메뉴얼대로 구현
                                                      fileName: "image\(index + 1).jpg",
                                                      mimeType: "image/jpeg"))
                }
            // MARK: - 한 장의 이미지를 받을 때
            } else if let imageData = value as? Data {
                formData.append(MultipartFormData(provider: .data(imageData),
                                                  name: key,
                                                  fileName: "image.jpg",
                                                  mimeType: "image/jpeg"))
            }
        }
        
        return formData
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
        case .readBoardForUpdate(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)"
        case .updateBoard(_, let communityRecruitingContent):
            return "/boards/\(communityRecruitingContent.id)"
        case .deleteBoard(_, let communityRecruitingContentId):
            return "/boards/\(communityRecruitingContentId)"
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNicknameForOverlap, .readMyProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .readPlaces, .readPlacesByMatches, .readPlacesByDistance, .readBoards, .readBoardForUpdate, .readBoardDetail, .readMatches, .readChatrooms: return .get
        case .login, .register, .reissueToken, .createBoard, .requestMatch, .createChatRoom: return .post
        case .logout, .deleteBoard: return .delete
        case .updateProfile, .updateBoard, .acceptMatchRequest, .rejectMatchRequest, .exitChatRoom: return .patch
        }
    }

    var task: Moya.Task {
        switch self {
        case .login(let token, let provider):
            return .requestParameters(parameters: ["provider": "\(provider)"], encoding: JSONEncoding.default)
        case .checkNicknameForOverlap(let nickname):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["nickname": "\(nickname)"])
        // TODO: - image 파라미터 빼고 user.imageURL을 개선하기
        case .register(let user, let image):
            let datasets: [String: Any?] = [
                "user": user,
                "image": image
            ]
            
            let formData = appendToMultipartFormData(from: datasets)
            return .uploadMultipart(formData)
        case .logout:
            return .requestPlain
        case .reissueToken:
            return .requestPlain
        case .updateProfile(_, let user):
            // TODO: - user 정보 바뀐부분만 보내도록 수정 필요
            let datasets: [String: Any?] = [
                "nickname": user.nickname,
                "isGenderVisible": user.isGenderVisible,
                "categoryName": user.categoriesOfInterest,
                "job": user.job,
                // TODO: - user.image / userEntity.image 타입 고민...
                <#image#>
//                "image": user.imageURL
            ]

            let formData = appendToMultipartFormData(from: datasets)
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
            return .requestCompositeData(bodyData: Data(), urlParameters: ["name": "\(name)", "latitude": "\(lat)", "longitude": "\(lon)"])
        case .readPlacesByMatches(lat: let lat, lon: let lon):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["latitude": "\(lat)", "longitude": "\(lon)"])
        case .readPlacesByDistance(let lat, let lon):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["latitude": "\(lat)", "longitude": "\(lon)"])
        case .readBoards:
            return .requestPlain
        case .createBoard(_, _, let communityRecruitingContent):
            return 
        case .readBoardForUpdate:
            return .requestPlain
        // TODO: - Object로 보내도 되는지 물어봄
        case .updateBoard(_, let communityRecruitingContent):
            <#code#>
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(let token,  _):
            ["Content-type": "application/json",
             "Authorization": "\(token)"]
        case .register(let user, let image):
            ["Content-type": "application/json"]
        case .logout(let token):
            ["Authorization": "\(token)"]
        case .reissueToken(let refreshToken):
            ["Authorization": "\(refreshToken)"]
        case .updateProfile(let token, let user):
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
        case .createBoard(let token, let placeId, let communityRecruitingContent):
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
        default: nil
        }
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var authorizationType: AuthorizationType? {
          switch self {
          case .login, .logout, .reissueToken, .updateProfile, .readMyProfile, .readMyBoards, .readMyMatches, .readMyRequestMatches, .createBoard, .readBoardForUpdate, .updateBoard, .deleteBoard, .readMatches, .requestMatch, .acceptMatchRequest, .rejectMatchRequest, .createChatRoom, .readChatrooms, .exitChatRoom:
                  .bearer
          default: .none
          }
      }
}
