# Commit Diary 프로젝트
- 기간: 2022. 10. 03. ~ 2022. 10. 18.

## 프로젝트 소개
GitHub API를 통하여 Commit 정보가 제공되고, 원하는 레포지토리와 커밋 메세지를 선택하여 메모를 작성할 수 있습니다.

GitHub token을 Keychain으로 관리하며 메모는 CoreData에 저장됩니다.

Localization이 지원되며, 설정에서 원하는 테마 색상으로 변경할 수 있습니다.

## 목차
- [키워드](#키워드)
- [디렉토리 구조](#디렉토리-구조)
- [기능 명세](#기능-명세)
- [새롭게 시도해본 기술](#새롭게-시도해본-기술)
- [Trouble Shooting](#trouble-shooting)

## 키워드
- `SwiftUI`
    - `enviroment`
    - `enviromentObject`
    - `AppStorage`
    - `Picker`
    - `TabView`
    - `NavigationView`
    - `List`
- `GitHub API`
    - `async/await`
- `Keychain`
    - `create`
    - `read`
    - `delete`
- `CoreData`
    - `CRUD`
    - `FetchRequest`
    - `FetchedResults`
    - `sortDescriptors`
- `Localization`
- `UserDefault`
- `HTML Parsing`



## 디렉토리 구조
```
├── Views
│   ├── Theme.swift
│   ├── RootView
│   │   ├── RootTabView.swift
│   │   └── LoginView.swift
│   ├── CommitView
│   │   ├── CommitStatusView.swift
│   │   ├── ContriburionView.swift
│   │   └── CommitChart.swift
│   ├── NoteView
│   │   ├── NoteListView.swift
│   │   ├── NoteRowView.swift
│   │   ├── EditNoteView.swift
│   │   └── SubtitleTextModifier.swift
│   └── SettingView
│       └── SettingView.swift
├── Service
│   ├── UserInfoService.swift
│   ├── ContributionService.swift
│   └── CommitInfoService.swift
└── Model
│   ├── Note.swift
│   ├── UserInfo.swift
│   ├── Contribution.swift
│   ├── RepoInfo.swift
│   └── CommitInfo.swift
├── Network
│   ├── NetworkError.swift
│   ├── APICaller
│   │    └── GithubNetwork.swift
│   └── Request
│       ├── APIRequest+Protocol.swift
│       ├── UserInfoRequest.swift
│       ├── CommitInfoRequest.swift
│       ├── ContributionsRequest.swift
│       └── RepoRequest.swift
├── CoreData
│   ├── CoreDataStack.swift
│   ├── CoreDataHelpers.swift
│   ├── Model+CoreData.swift
│   ├── NoteData.xcdatamodeld
│   ├── NoteEntity+CoreDataClass.swift
│   └── NoteEntity+CoreDataProperties.swift
├── Uillity
│   ├── LoginManager.swift
│   ├── Keychain.swift
│   ├── htmlParser.swift
│   ├── APIKeyBundle.swift
│   └── Localizable.string
└── Extensions
    ├── Extension+View.swift
    ├── Extension+Date.swift
    ├── Extension+Color.swif
    ├── Extension+UIApplication.swift
    └── Extension+String.swift


```
---





## 기능 명세
|로그인/로그아웃|
| :-: |
| ![loginlogout](https://user-images.githubusercontent.com/87305744/196351598-7dd7663d-b4c7-488c-b288-5a13a7a34e51.gif) |

|노트 등록|
| :-: |
| ![Simulator Screen Recording - iPhone 13 - 2022-10-20 at 11 22 46](https://user-images.githubusercontent.com/87305744/196841234-167e2e66-4e22-45f8-82c3-f3c96d218fc1.gif) |

|테마 변경|
| :-: |
| ![color](https://user-images.githubusercontent.com/87305744/196351709-6a88a4e1-c51c-4f9a-92f9-2df40269b1cf.gif) |

|새로고침|
| :-: |
| ![refresh](https://user-images.githubusercontent.com/87305744/196351757-bb3865ed-97b2-4fff-b0d4-36b90602a9e5.gif) |

|Localization|
| :-: |
| ![Simulator Screen Recording - iPhone 13 - 2022-10-20 at 17 32 14](https://user-images.githubusercontent.com/87305744/196898300-03fc15eb-0776-4c1a-b87c-7a2bb014c079.gif) |

<br/>
<br/>

### 내부 기능
**1. 로그인/로그아웃**
- LoginManager를 구현하여 로그인/로그아웃 관련 기능이 실행됩니다.
    - `Oauth` URL을 통해 임시 code를 받고, 이를 이용해서 요청한 token을 사용해서 로그인
    - 로그인 유지를 위하여 `UserDefaults`에  로그인 상태 Bool값 저장
    - 로그아웃 시 `UserDefaults`의 로그인 상태 false로 변경
    
**2. 보안**
- 로그인 시 `Keychain`에 GitHub 로그인 token이 저장됩니다.
- 로그아웃 시 `Keychain`의 token 정보가 삭제됩니다.
- Property List에 Client Id, Client Secret을 등록하여 Bundle에 연결했습니다. 

**3. API Call**
- `async/await`을 사용했습니다.
- `KeyChain`에 저장된 token 정보를 이용하여 사용자 정보 API Call을 합니다.
- 공개되어 있는 Contribution에 대한 요청의 경우 userId를 이용하여 API Call을 합니다.
- 사용자의 레포지토리 목록을 불러와서, `Picker`에서 레포지토리가 선택 될 때마다 커밋메세지에 대한 API Call을 합니다.

**4. CoreData**
- MangedEntity Protocol을 구현하여 활용했습니다.
    - 해당 타입의 새로운 Object를 context에 추가할 수 있는 insertNew 메소드 구현
    - 해당 타입의 새 FetchRequest를 만들 수 있는 newFetchRequest 메소드 구현
- Note 타입 내부에 CoreData 관련 메소드를 구현했습니다.
    - Entity에 새로운 Object를 추가하고 Note 타입 자신의 프로퍼티도 함께 변경하는 `store` 메소드 구현
    - Entity의 값을 업데이트하는 `update` 메소드 구현

**5. HTML Parsing**
- `Contribution 페이지소스`의 html 데이터를 유효 정보로 변환합니다.
- html class 이름과 tag 유형을 매개변수로 class 블록을 추출합니다.
- 추출된 class 블록에서 tag 유형을 매개변수로 inline 블록을 추출합니다.
- 추출된 inline 블록을 key-value 쌍의 딕셔너리로 변환합니다.
 
<br/>

### View 기능
**1. Contribution**
```swift
guard let lastDate = contributions.last?.date else {
    return []
}
let rows = 7
let blankCellCount = rows - Calendar.current.component(.weekday, from: lastDate)
let cellCount = rows * columnsCount - blankCellCount
let levels = contributions.suffix(cellCount).map{ $0.level }

var colors = [[Color]]()
for index in stride(from: 0, to: levels.count, by: rows) {
     let splitedColors = levels[index..<Swift.min(index+rows, levels.count)]
                        .map{ theme.colorSet(by: $0) }
    colors.append(splitedColors)
}
```
 - Calendar 타입의 메소드를 이용하여 Contribution Cell 개수를 산출합니다.
 - 로드된 Contribution Data에서 Cell 개수만큼 분할 후 `level` 타입으로 변환합니다.
 - 현재 색상 테마의 level별 색상으로 변환합니다.

**2. 그래프**
- `ZStack`을 이용하여 바탕 그래프 영역, 색칠되는 그래프 영역을 구현했습니다.
- 현재 연속 기록과 최고 연속 기록을 계산하여 최고 기록까지의 도달 정도를 시각화했습니다.

**3. 테마 색상 변경**
- `AppStorage`에 저장된 테마 값을 `Binding`하여 변경합니다.
- 변경 시 `AppStorage`에도 테마 값이 업데이트 됩니다.

**4. 키보드 입력**
- Note 입력 시 입력 외부 영역을 터치하면 키보드 숨김 기능을 구현했습니다.
- `UIApplication` 내부에서 `UITapGestureRecognizer`를 이용했습니다.
 
**4. Alert**
- 아래의 경우 Alert이 송출됩니다.
    - 노트의 값 중 빈 값이 있을 때
    - 테마가 변경되었을 때
    - 로그아웃 버튼을 눌렀을 때


<br/>
<br/>

---


## 새롭게 시도해본 기술
### SwiftUI에서의 CoreData
`@FetchRequest`를 사용하여 SwiftUI에서의 CoreData를 적용했습니다.

`sortDescriptors` 등을 통해서 `View`에서 CoreData를 원하는 형식으로 바로 접근하여 사용할 수 있었습니다.

UIKit+MVVM 구조와 비교하여 편의성은 좋았지만, 지금처럼 단순히 CoreData를 읽고 쓰는 것 뿐만 아닌 추가적인 가공과 로직이 필요할 경우 View가 무거워질 수 있지 않을까? 라는 고민을 했습니다. 현재의 코드에서도 CoreData를 다루는 메소드가 2개가 존재하는데, 가독성을 위해 별도의 extension으로 분리했습니다.

또한 `Note` 타입과 연관되어 Note <-> NoteEntity 타입의 변환이 필요한 `store`, `update` 메소드는 `Note`타입의 extension으로 구현했습니다. 
이 부분 역시 CoreData의 CRUD와 관련된 메소드가 `View`와 흩어져 있다는 점에서 가독성, 효율성 측면에 최선인가 하는 고민을 하고 있습니다.

### async/await을 이용한 통신
기존에 경험한 completionHandler, Combine 방식과는 다르게 async/await을 이용한 통신을 구현했습니다.

`await`을 호출하는 메소드에 `async` 키워드를 사용하여 구현했습니다.

메소드 내부의 `View`와 관련된 동작에는 `DispatchQueue.main.async`를 사용하여 업데이트 되도록 했습니다.

`View`의 `body`, `init`과 같이 동시성을 지원하지 않는 함수에서 async 호출은 불가능하기 때문에, 초기화 시 await 함수 호출이 필요할 경우에는 `SwiftUI`의 `Task` 타입을 사용했습니다.

### Keychain 사용
`Keychain`을 사용하여 보안이 필요한 정보를 관리했습니다.

`Keychain Class`를 구현하여 사용했으며, 그 과정에서 기본 개념과 `Keychain Items`, `Item Class`, `Attribute` 등 주요 키워드를 바탕으로 학습했습니다. 

공식문서를 정리하며 학습한 기록입니다.

[2022.09.29. 블로그 작성 글 _ [Swift] Keychain](https://velog.io/@horeng2/Swift-KeyChain...CF...%EB%AD%90...-%EB%84%A4)


<br/>
<br/>

---

## Trouble Shooting
### `AsyncImage` 사용 시 View가 만들어지는 타이밍과 Image 로드 타이밍의 딜레이 발생
- 문제점
    - `AsyncImage`를 사용 시 뷰가 생성된 이후에 이미지 로드가 완료되어 딜레이가 발생하는 문제가 있었습니다.

- 원인 분석
    - `AsyncImage`는 비동기적으로 이미지를 불러오기 때문에 이미지 로드 시간보다 뷰의 생성시간이 빠르기 때문이었습니다.

- 해결
    - `UserInfoService`에서 이미지 로드를 미리 처리하도록 했습니다. 
    - `UserInfoService`는 `userInfo`, `profileImage`의  `@Published` 객체를 가지게 되었으며 이것을 `View`에서 사용하도록 했습니다.
<br/>

### 키보드가 화면을 가리는 문제

- 문제점
    - `TextEditor`에 입력 시 키보드가 올라와 타이핑 영역을 가리는 문제가 있었습니다.

- 원인 분석
    - Xcode Beta 4 버전부터 `TextField`에는 화면이 자동으로 키보드에 가리지 않도록 스크롤링 되는 방법이 지원되었으나 `TextEditor`에는 적용되지 않은 기능이었기 때문입니다.

- 시도해본 방법들
    - TextField 사용
        - 내부의 스크롤링 기능을 이용하기 위하여 `TextField`를 사용하는 방법입니다. 하지만 노트의 내용을 여러 줄 입력하는 기능에는 `TextField`보다 `TextEditor`가 적합하다고 생각하여 이 방식은 사용하지 않았습니다.

    - `UIResponder`, `NotificationCenter`, `Combine` 사용
        - `UIResponder`의 `keyboardWillShowNotification`, `keyboardFrameEndUserInfoKey`, `keyboardWillHideNotification`을 `publisher`에 등록하여 변경에 따라 `offSet`의 크기를 조절하는 방식입니다.
        - 하지만 Xcode Beta 5 버전부터 `Form, List, TextEditor`가 키보드 뒤에 겹치지 않는 방식으로 변경되었고, 이 때문에 키보드가 올라오면 키보드의 상단 지점부터 offSet이 적용되는 문제가 발생했습니다. 
    
    - `GeometryReader`를 이용하여 프레임 크기 조절
        - 현재의 프레임 크기에서 키보드 높이만큼을 뺀 값으로 프레임을 재설정하는 시도를 하였습니다. 하지만 위의 방식과 마찬가지로, 키보드가 올라온 뒤에는 키보드 영역을 제외한 부분만큼 프레임이 자동으로 재설정되기 때문에 사용이 불가능했습니다.
    
    
- 해결
    - `ScrollViewReader`을 사용하여 해결했습니다.
    - 키보드가 올라와도 키보드 뒤로 뷰가 겹치지 않는 방식으로 앱이 작동되기 때문에, 프레임이나 오프셋을 설정하는 방식은 어려울 것으로 판단했습니다. 
    - 따라서 `ScrollView`를 이용하여 스크롤 지점을 제어하는 방향으로 해결책을 고민했고, `ScrollViewReader`와 `ScrollViewProxy`를 사용하여 `TextEditor`가 변경될 때 원하는 지점으로의 스크롤을 구현했습니다.
    - `withAnimation` 키워드를 사용하여 자연스러운 스크롤이 되도록 하였습니다. 
<br/>

### Custom Font의 사용

- 문제점
    - 프로젝트에 다양한 `Custom Font`를 사용했는데, 적용된 `Text`의 수가 많아지다보니 관리가 어렵다는 생각이 들었습니다.

- 고민해본 것들
    - FontManager 타입 구현
        - 폰트를 관리하는 타입을 구현해서 싱글톤으로 사용하는 방법입니다.
    - SystemFont 사용
        - 내장된 폰트를 사용하는 방법입니다.
    
- 해결
    - `SystemFont`를 사용하는 방식으로 결정했습니다. 
    - 그 이유는 다음과 같습니다.
        - `automatically` 등 다른 다이나믹 타입 기능들과의 호환성
        - 내장되어 있는 폰트 기능을 최대한 활용하는 것이 효율성, 가독성 측면에서 효율적

<br/>

### `ObservedObject`로 코어데이터 엔티티를 참조하고 있는 Row 삭제시 앱 충돌
- 문제점
    - 코어데이터 엔티티를 참조하고 있는 Row를 삭제했을 때 앱 충돌이 발생했습니다.
    <br/>
    
    ```swift
    struct NoteRowView: View {
        @ObservedObject var noteEntity: NoteEntity
        ...
    }
    ```

- 원인 분석
    - breakPoint를 사용해서 상태를 점검해보았을 때, 코어데이터를 삭제할 때 잠시동안 비어있는 코어데이터가 발견되었습니다. 이 때, 엔티티의 `String` 프로퍼티는 `""`와 같은 형태로 출력되었지만, `Date`타입 프로퍼티에는 값이 존재하지 않아서 오류가 발생한 것으로 보였습니다.
 
 - 해결
    - 코어데이터 엔티티의 `Date` 타입 프로퍼티를 옵셔널로 변경하여 해결하였습니다.
 
 <br/>
 
 ### 앱 구동 초기 로딩 지연
 
 - 문제점
    - 앱을 구동 시 초기 로딩 속도가 느린 문제가 있었습니다.
 
 - 원인 분석
    - 초기 `App`파일에서 3개의 `awit` 메소드를 호출했는데, 이 메소드들이 동기적으로 처리됨에 따라서 발생하는 속도 지연을 의심할 수 있었습니다.
    <br/>
    
    ```swift
    RootTabView(colorTheme: $colorTheme)
        .environment(\.managedObjectContext, coreDataStack.context)
        .environmentObject(userInfoService)
        .environmentObject(contributionService)
        .environmentObject(commitInfoService)
        .task {
            await userInfoService.loadUserInfo()
            await contributionService.loadContribution()
            await commitInfoService.loadRepos(from: userInfoService.userInfo.reposUrl)
        }
    ```
 
 - 해결
    - 각 메소드가 비동기적으로 처리되도록 `task`를 분리하여 로딩 속도가 향상되었습니다.
    <br/>
    
    ```swift
    RootTabView(colorTheme: $colorTheme)
    .environment(\.managedObjectContext, coreDataStack.context)
    .environmentObject(userInfoService)
    .environmentObject(contributionService)
    .environmentObject(commitInfoService)
    .task {
        await userInfoService.loadUserInfo()
    }
    .task {
        await contributionService.loadContribution()
    }
    .task {
        await commitInfoService.loadRepos(from: userInfoService.userInfo.reposUrl)
    }
    ```
