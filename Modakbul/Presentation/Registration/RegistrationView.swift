//
//  RegistrationView.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 7/29/24.
//

import SwiftUI
import PhotosUI

struct RegistrationView<Router: AppRouter>: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var registrationViewModel: RegistrationViewModel
    
    init(registrationViewModel: RegistrationViewModel) {
        self.registrationViewModel = registrationViewModel
    }
    
    var body: some View {
        view()
            .padding([.leading, .trailing], RegistrationViewValue.xAxisPadding)
            .onDisappear {
                registrationViewModel.submit()
                registrationViewModel.initialize()
            }
    }
}

extension RegistrationView {
    @ViewBuilder
    private func view() -> some View {
        switch registrationViewModel.currentField {
        case .username:
            contentStackView(isZStack: true) {
                RoundedTextField("30자 내로 입력해주세요", text: $registrationViewModel.name)
            }
        case .nickname:
            contentStackView(isZStack: true) {
                NicknameTextField(nickname: $registrationViewModel.nickname,
                                  isOverlapped: $registrationViewModel.isOverlappedNickname,
                                  disabledCondition: registrationViewModel.isPassedNicknameRule()
                ) {
                    registrationViewModel.checkNicknameForOverlap()
                }
            }
        case .birth:
            contentStackView(isZStack: true) {
                BirthPicker(birth: $registrationViewModel.birth)
            }
        case .gender:
            contentStackView(isZStack: false) {
                SingleSelectionButton<Gender, GenderSelectionButton>(selectedItem: $registrationViewModel.gender) { (item, selectedItem) in
                    GenderSelectionButton(item: item, selectedItem: selectedItem)
                }
            }
        case .job:
            contentStackView(isZStack: false) {
                SingleSelectionButton<Job, DefaultSingleSelectionButton>(selectedItem: $registrationViewModel.job) { (item, selectedItem) in
                    DefaultSingleSelectionButton(item: item, selectedItem: selectedItem)
                }
            }
        case .category:
            contentStackView(isZStack: false) {
                MultipleSelectionButton<Category, DefaultMultipleSelectionButton>(selectedItems: $registrationViewModel.categoriesOfInterest) { (item, selectedItem) in
                    DefaultMultipleSelectionButton(item: item, selectedItems: selectedItem)
                }
            }
        case .image:
            contentStackView(isZStack: false) {
                PhotosUploader(image: $registrationViewModel.image)
            }
        }
    }
    
    @ViewBuilder
    private func contentStackView<Content: View>(isZStack: Bool, content: @escaping () -> Content) -> some View {
        if isZStack {
            ZStack {
                VStack {
                    header
                    
                    Spacer()
                    
                    FlatButton(registrationViewModel.currentField.buttonLabel(image: registrationViewModel.image)) {
                        if registrationViewModel.currentField != .image {
                            registrationViewModel.proceedToNextField()
                        } else {
                            router.popToRoot()
                        }
                    }
                    .disabled(!registrationViewModel.isNextButtonEnabled)
                }
                content()
            }
        } else {
            VStack {
                header
                
                Spacer()
                
                content()
                
                Spacer()
                Spacer()
                
                FlatButton(registrationViewModel.currentField.buttonLabel(image: registrationViewModel.image)) {
                    if registrationViewModel.currentField != .image {
                        registrationViewModel.proceedToNextField()
                    } else {
                        router.popToRoot()
                    }
                }
                .disabled(!registrationViewModel.isNextButtonEnabled)
            }
        }
    }
    
    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: RegistrationViewValue.Header.vStackSpacing
        ) {
            Text(registrationViewModel.currentField.title)
                .font(.title)
                .bold()
            Text(registrationViewModel.currentField.subtitle)
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .padding(.top, RegistrationViewValue.Header.topPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

protocol Selectable: CaseIterable, CustomStringConvertible, Hashable {}

struct NicknameTextField: View {
    @Binding var nickname: String
    @Binding var isOverlapped: Bool?
    
    private let disabledCondition: Bool
    private let action: () -> Void
    
    init(
        nickname: Binding<String>,
        isOverlapped: Binding<Bool?>,
        disabledCondition: Bool,
        action: @escaping () -> Void
    ) {
        self._nickname = nickname
        self._isOverlapped = isOverlapped
        self.disabledCondition = disabledCondition
        self.action = action
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                RoundedTextField("한글, 영문, 숫자 2~15자", text: $nickname)
                    .onChange(of: nickname) { _ in
                        isOverlapped = nil
                    }
                
                Button {
                    action()
                } label: {
                    Text("중복확인")
                        .padding(RegistrationViewValue.NicknameCheckButton.padding)
                        .tint(.white)
                        .background(alignment: .center) {
                            RoundedRectangle(cornerRadius: RegistrationViewValue.NicknameCheckButton.cornerRadius)
                        }
                }
                .disabled(!disabledCondition)
            }
            
            if let isOverlapped = isOverlapped {
                if isOverlapped {
                    Text("""
                    중복된 닉네임입니다.
                    최대 15자까지 입력 가능합니다.
                    """)
                    .foregroundColor(.red)
                    .padding(.top, RegistrationViewValue.RoundedTextField.topPadding)
                    .padding(.leading, RegistrationViewValue.RoundedTextField.leadingPadding)
                }
                else {
                    Text("사용 가능한 닉네임입니다.\n")
                        .foregroundColor(.green)
                        .padding(.top, RegistrationViewValue.RoundedTextField.topPadding)
                        .padding(.leading, RegistrationViewValue.RoundedTextField.leadingPadding)
                }
            }
        }
    }
}

struct BirthPicker: View {
    @Binding var birth: DateComponents
    
    var body: some View {
        HStack {
            contentView(titleKey: "생년",
                        dateType: birth.year,
                        defaultValue: 2000,
                        startRange: 1900,
                        endRange: 2050) {
                birth.year = $0
            }
            
            contentView(titleKey: "월",
                        dateType: birth.month,
                        defaultValue: 1,
                        startRange: 1,
                        endRange: 12) {
                birth.month = $0
            }
            
            contentView(titleKey: "일",
                        dateType: birth.day,
                        defaultValue: 1,
                        startRange: 1,
                        endRange: 31) {
                birth.day = $0
            }
        }
    }
    
    @ViewBuilder
    private func contentView(titleKey: String,
                             dateType: Int?,
                             defaultValue: Int,
                             startRange: Int,
                             endRange: Int,
                             updateValue: @escaping (Int) -> Void) -> some View {
        Picker(titleKey, selection: Binding(
            get: { dateType ?? defaultValue },
            set: { updateValue($0) }
        )) {
            ForEach(startRange...endRange, id: \.self) { number in
                Text(verbatim: "\(number)")
            }
        }.pickerStyle(WheelPickerStyle())
    }
}

struct SingleSelectionButton<T: Selectable, Content: View>: View {
    @Binding var selectedItem: T?
    var columns: [GridItem] = Array(repeating: .init(.fixed(135)), count: 2)
    @ViewBuilder var content: (T, T?) -> Content
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Button {
                    selectedItem = item
                } label: {
                    content(item, selectedItem)
                }
            }.padding(5)
        }
    }
}

struct MultipleSelectionButton<T: Selectable, Content: View>: View {
    @Binding var selectedItems: Set<T>
    var columns: [GridItem] = Array(repeating: .init(.fixed(135)), count: 2)
    @ViewBuilder var content: (T, Set<T>) -> Content
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Button {
                    if selectedItems.contains(item) && selectedItems.count > 1 {
                        selectedItems.remove(item)
                    } else {
                        selectedItems.insert(item)
                    }
                } label: {
                    content(item, selectedItems)
                }
            }
        }
    }
}

struct GenderSelectionButton<T: Selectable>: View {
    let item: T
    let selectedItem: T?
    
    var body: some View {
        VStack {
            Image(item.description)
                .foregroundStyle(.gray)
            Text(item.description)
                .foregroundStyle(item == selectedItem ? .white : .accent)
                .padding(RegistrationViewValue.GenderSelectionButton.padding)
        }
        .background {
            RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadius)
                .stroke(Color.accent)
                .background(RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadius)
                    .shadow(color: .gray,
                            radius: RegistrationViewValue.DefaultSelectionButton.shadowRadius,
                            x: RegistrationViewValue.DefaultSelectionButton.shadowXAxisPosition,
                            y: RegistrationViewValue.DefaultSelectionButton.shadowYAxisPosition)
                )
        }
        .foregroundStyle(item == selectedItem ? .accent : .white)
    }
}

struct DefaultSingleSelectionButton<T: Selectable>: View {
    let item: T
    let selectedItem: T?
    
    var body: some View {
        Text(item.description)
            .foregroundStyle(item == selectedItem ? .white : .accent)
            .frame(width: RegistrationViewValue.DefaultSelectionButton.widthFrame,
                   height: RegistrationViewValue.DefaultSelectionButton.heightFrame,
                   alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadiusMaximum)
                    .stroke(Color.accent, lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadiusMaximum)
                        .shadow(color: .gray,
                                radius: RegistrationViewValue.DefaultSelectionButton.shadowRadius,
                                x: RegistrationViewValue.DefaultSelectionButton.shadowXAxisPosition,
                                y: RegistrationViewValue.DefaultSelectionButton.shadowYAxisPosition)
                    )
            }
            .foregroundStyle(item == selectedItem ? .accent : .white)
    }
}

struct DefaultMultipleSelectionButton<T: Selectable>: View {
    let item: T
    let selectedItems: Set<T>
    
    var body: some View {
        Text(item.description)
            .foregroundStyle(selectedItems.contains(item) ? .white : .accent)
            .frame(width: RegistrationViewValue.DefaultSelectionButton.widthFrame,
                   height: RegistrationViewValue.DefaultSelectionButton.heightFrame,
                   alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadiusMaximum)
                    .stroke(Color.accent, lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: RegistrationViewValue.DefaultSelectionButton.cornerRadiusMaximum)
                        .shadow(color: .gray,
                                radius: RegistrationViewValue.DefaultSelectionButton.shadowRadius,
                                x: RegistrationViewValue.DefaultSelectionButton.shadowXAxisPosition,
                                y: RegistrationViewValue.DefaultSelectionButton.shadowYAxisPosition)
                    )
            }
            .foregroundStyle(selectedItems.contains(item) ? .accent : .white)
    }
}

private struct MultipleSelection<T: Selectable, Content: View>: View {
    let item: T
    @Binding var selectedItems: Set<T>
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Toggle(isOn: Binding<Bool>(
            get: { selectedItems.contains(item) },
            set: { isSelected in
                if isSelected {
                    selectedItems.insert(item)
                } else {
                    selectedItems.remove(item)
                }
            }
        )) {
            content()
        }
        .toggleStyle(.button)
    }
}

struct PhotosUploader: View {
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @Binding var image: Data?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhoto,
            matching: .images,
            photoLibrary: .shared()) {
                PhotoUploaderView(image: $image)
                    .getPhoto(selectedPhoto: $selectedPhoto, image: $image)
            }
            .padding(RegistrationViewValue.PhotoUploader.padding)
    }
}

struct PhotoUploaderView: View {
    @Binding var image: Data?
    
    var body: some View {
        // TODO: 이미지 추가해야함
        Circle()
            .foregroundStyle(.gray)
            .opacity(0.6)
            .overlay {
                if let userImage = image,
                   let uiImage = UIImage(data: userImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFill()
                }
            }
            .overlay(alignment: .bottomTrailing) {
                // TODO: 이미지 추가해야함
                Image(systemName: "pencil.circle")
                    .font(.system(size: 50).weight(.light))
            }
    }
}

final class RegistrationViewModel: ObservableObject {
    private let userRegistrationUseCase: UserRegistrationUseCase
    private let allFields: [RegisterField] = RegisterField.allCases
    private var fieldIndex: Int = 0

    // MARK: Data From User
    @Published var email = ""
    @Published var name = ""
    @Published var nickname = ""
    @Published var birth: DateComponents = DateComponents(year: 2000, month: 1, day: 1)
    @Published var gender: Gender? = nil
    @Published var job: Job? = nil
    @Published var categoriesOfInterest: Set<Category> = []
    @Published var image: Data? = nil
    
    // MARK: For Binding
    @Published var currentField: RegisterField = .username
    @Published var isOverlappedNickname: Bool? = nil
    
    var isNextButtonEnabled: Bool {
        switch currentField {
        case .username:
            return !name.isEmpty && name.count <= 30
        case .nickname:
            return !(isOverlappedNickname ?? true)
        case .gender:
            return gender != nil
        case .job:
            return job != nil
        case .category:
            return !categoriesOfInterest.isEmpty
        default: return true
        }
    }
    
    init(userRegistrationUseCase: UserRegistrationUseCase) {
        self.userRegistrationUseCase = userRegistrationUseCase
    }
    
    // MARK: - Private Methods
    
    private func dateComponentsToDate(_ dateComponents: DateComponents) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.date(from: dateComponents)!
    }
    
    // MARK: - Public Methods
    func proceedToNextField() {
        fieldIndex += 1
        fieldIndex %= allFields.count
        currentField = allFields[fieldIndex]
    }

    @MainActor
    func checkNicknameForOverlap() {
        // TODO: NetworkService를 통해 닉네임 쿼리 필요
        Task {
            isOverlappedNickname = try await userRegistrationUseCase.validate(nickname)
        }
    }
    
    func isPassedNicknameRule() -> Bool {
        let nicknamePattern = "^[가-힣a-zA-Z0-9]+$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknamePattern)
        
        guard nicknamePredicate.evaluate(with: nickname) else {
            return false
        }
        
        guard 2 <= nickname.count && nickname.count <= 15 else {
            return false
        }
        
        return true
    }
    
    func submit() {
        // TODO: Provider 수정할 것
        let user = User(email: email,
                        provider: .apple,
                        name: name,
                        nickname: nickname,
                        birth: dateComponentsToDate(birth),
                        gender: gender!,
                        job: job!,
                        categoriesOfInterest: categoriesOfInterest,
                        image: image,
                        isGenderVisible: false)
        
        Task {
            try await userRegistrationUseCase.register(user, encoded: image ?? Data())
        }
    }
    
    func initialize() {
        email = ""
        name = ""
        nickname = ""
        birth = DateComponents(year: 2000, month: 1, day: 1)
        gender = nil
        job = nil
        categoriesOfInterest = []
        image = nil
        currentField = .username
        isOverlappedNickname = nil
    }
}

//extension UIApplication {
//    func hideKeyboard() {
//
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        guard let window = windowScene?.windows.first else { return }
//        // deprecated
//        //        guard let window = windows.first else { return }
//
//        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
//        tapRecognizer.cancelsTouchesInView = false
//        tapRecognizer.delegate = self
//        window.addGestureRecognizer(tapRecognizer)
//    }
//}
//
//extension UIApplication: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
//}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RegistrationView_PreView: PreviewProvider {
    static var previews: some View {
        router.view(to: .registrationView)
    }
}
