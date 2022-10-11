# Commit Diary 프로젝트
- 기간: 2022. 10. 03. ~ 2022. 10. 11.

## 프로젝트 소개
GitHub API를 이용한 Commit 정보 제공 및 메모 앱입니다.

GitHub token을 Keychain으로 관리하며, 메모는 CoreData에 저장됩니다.

설정에서 원하는 테마 색상으로 변경할 수 있습니다.

## 목차
- [키워드](#키워드)
- [디렉토리 구조](#디렉토리-구조)
- [기능 명세](#기능-명세)
- [새롭게 시도해본 기술](#새롭게-시도해본-기술)

## 키워드
- `SwiftUI`
    - `enviroment`
    - `enviromentObject`
    - `AppStorage`
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
- `UserDefault`
- `HTML Parsing`



## 디렉토리 구조
```
├── Views
│   ├── ViewIndex.swift
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
│   │   └── EditNoteView.swift
│   ├── SettingView
│   │   └── SettingView.swift
│   └── Extensions
│   │   ├── Extension+Date.swift
│   │   ├── Extension+Colorv
│   │   └── Extension+UIApplication.swift
├── Service
│   ├── UserInfoService.swift
│   └── ContributionService.swift
└── Model
│   ├── Note.swift
│   ├── UserInfo.swift
│   └── Contribution.swift
├── Network
│   ├── GithubNetwork.swift
│   ├── UserInfoRequest.swift
│   ├── ContributionsRequest.swift
│   └── NetworkError.swift
├── CoreData
│   ├── CoreDataStack.swift
│   ├── CoreDataHelpers.swift
│   ├── Model+CoreData.swift
│   ├── NoteData.xcdatamodeld
│   ├── NoteEntity+CoreDataClass.swift
│   └── NoteEntity+CoreDataProperties.swift
└── Uillity
    ├── LoginManager.swift
    ├── Keychain.swift
    ├── htmlParser.swift
    └── Extension+String.swift


```
---

## 기능 명세
|로그인/로그아웃|
| :-: |
| ![login:logout](https://user-images.githubusercontent.com/87305744/195121988-669bb397-7391-462e-96b9-18cb2dbe48dc.gif) |

|노트 등록|
| :-: |
| ![note](https://user-images.githubusercontent.com/87305744/195123563-44f2c786-80af-48a9-832f-d7cbaff8d451.gif) |

|테마 변경|
| :-: |
| ![theme](https://user-images.githubusercontent.com/87305744/195123108-e3464b8b-ca79-42c1-bc82-078f02c7b879.gif) |

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
- `UserDefaults`에 저장된 테마 값을 `Binding`하여 변경합니다.
- 변경 시 `UserDefaults`에도 테마 값이 업데이트 됩니다.

**4. 키보드**
- Note 입력 시 입력 외부 영역을 터치하면 키보드 숨김 기능을 구현했습니다.
- `UIApplication` 내부에서 `UITapGestureRecognizer`를 이용했습니다.
 
**4. Alert**
- 아래의 경우 Alert이 송출됩니다.
    - 노트의 값 중 빈 값이 있을 때
    - 테마가 변경되었을 때
    - 로그아웃 버튼을 눌렀을 때





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


