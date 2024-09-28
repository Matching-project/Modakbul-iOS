//
//  Match.swift
//  Modakbul
//
//  Created by Swain Yun on 9/28/24.
//

/// 모임의 관계를 나타냅니다.
/// * placeId - 모집글이 작성된 장소의 식별값
/// * locationName - 모집글이 작성된 장소의 이름
/// * communityRecruitingContent - 연관된 모집글
struct CommunityRelationship {
    let placeId: Int64
    let locationName: String
    let communityRecruitingContent: CommunityRecruitingContent
}
