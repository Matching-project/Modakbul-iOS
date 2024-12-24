//
//  RegisterField.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 8/5/24.
//

import Foundation

enum RegisterField: CaseIterable {
    case nickname, gender, job, category, image
    
    var title: String {
        switch self {
//        case .name: return "처음 오셨군요. 반가워요!\n회원님의 이름은 무엇인가요?"
        case .nickname: return "회원님의 닉네임은 무엇인가요?"
//        case .birth: return "회원님의 생년월일은 언제인가요?"
        case .gender: return "회원님의 성별은 무엇인가요?"
        case .job: return "현재 직업은 무엇인가요?"
        case .category: return "주요 작업 카테고리는 무엇인가요? (복수 선택 가능)"
        case .image: return "사진을 업로드해주세요."
        }
    }
    
    var subtitle: String {
        switch self {
        case .nickname, .image: ""
        case .gender: "회원님의 성별 표시에 사용되며,\n설정에서 on/off 할 수 있어요."
        case .job: "회원님의 직업 표시에 사용되요."
        case .category: "관심 모임을 지도에서 표시해드려요!"
        }
    }
    
    func buttonLabel(image: Data?) -> String {
        switch self {
        case .image: image == nil ? "건너뛰고 완료하기" : "완료하기"
        default: "다음"
        }
    }
}
