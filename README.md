# LifeFlow

### 프로젝트
 - 인원 : 개인프로젝트 <br>
 - 기간 : 2023.11.27 ~ 2023.12.15 (3주) <br>
 - 최소지원버전 : iOS 15 <br>
 
<br>

### 한줄소개
 - 일상 생활을 공유할 수 있는 소셜 커뮤니티 앱 입니다.

<br>

### 미리보기
![라이프플로우 001](https://github.com/J-comet/traveltune/assets/67407666/6e32dad6-c576-4f93-9450-01d5850b6d95)

<br>

### 기술
| Category | Stack |
|:----:|:-----:|
| Architecture | `MVVM` |
|  UI  | `SnapKit` |
| Reactive | `RxSwift` `RxDataSources` `RxGesture` |
|  Network  | `Alamofire` |
|  Image  | `Kingfisher` |
|  Dependency Manager  | `SPM` |
| Etc | `Then` `Toast` `IQKeyboardManagerSwift` |

<br>

### 서버
- SeSAC iOS 앱 개발자 데뷔과정 교육생에게 제한적으로 제공되는 API 서버를 사용합니다.

<br>

### 기능
- 회원가입 / 로그인 / 로그아웃 / 회원탈퇴
- 게시글 및 댓글 작성 / 수정 / 삭제 / 불러오기
- 게시글 좋아요
- 프로필 조회

<br>

### 개발 고려사항
- 데이터에 변동에 따라 UI 갱신되도록 MVVM 디자인패턴 적용 했습니다.
- Alamofire RequestInterceptor 를 활용해 AccessToken 을 관리 했습니다.
- DTO 적용해 서버의 파라미터명이 변경되어도 비정상적인 종료를 방지 했습니다.
- RxSwift Single 활용해 Error 발생시에도 구독이 해제되지 않도록 구현 했습니다.
- 업로드 가능한 최대 용량에 따라 이미지 리사이징 후 다중이미지 업로드 구현 했습니다.
- enum 활용해 APIError 코드별로 분기 처리 했습니다.

<br>

### 트러블슈팅

####  1. 테이블뷰 내에 Horizontal 컬렉션뷰가 있는 중첩셀에서 생긴 이슈

-> 테이블뷰의 셀에서 좋아요를 눌렀을 때 하트 이미지는 업데이트가 잘되었습니다. 하지만 Horizontal 컬렉션뷰의 스크롤 위치는 초기화가 되는 이슈가 있었습니다. <br>
-> 글을 길게 작성했을 때 더보기 버튼이 있습니다. 위의 오류와 마찬가지로 더보기 버튼을 눌러 펼친 상태였다면 부모셀이 업데이트 되면서 다시 접힌 UI 가 되는 이슈가 발생했습니다. <br>
-> 이 오류를 해결하기 위해 Entity 로 사용 중인 구조체내에 접힌 상태인지 상태를 저장하는 프로퍼티와 현재 가로 이미지 스크롤뷰의 위치를 저장하는 프로퍼티를 추가했습니다. <br>
   접힌 상태가 변화거나 가로 스크롤뷰의 위치가 변할 때마다 기존 리스트의 값을 업데이트 시켜주는 코드를 추가 해준 뒤 부모 셀이 업데이트 될 때 접힌 상태인지 확인 하는 상태를 저장한 프로퍼티와 가로 이미지 스크롤뷰 위치 프로퍼티 값을 가져와 기존 데이터로 업데이트 시켜주도록 수정해서 해결하였습니다. <br>
   

```swift

final class TableCell {
    .....

     override func configCell(row: PostEntity) {
            horizontalImages.accept(row.image)
            pageControl.numberOfPages = row.image.count
            pageControl.currentPage = row.currentImagePage
            
            horizontalImgCollectionView.scrollToItem(at: .init(item: row.currentImagePage, section: 0), at: .centeredHorizontally, animated: false)
    
            .....
    
            expandContentLabel.isHidden = !row.isExpand
            horizontalContentStackView.isHidden = row.isExpand
        }
}

final class HomeVC {
     .....
     // 더보기 버튼
     cell.moreContentButton
          .rx
          .tap
          .bind(with: self) { owner, _ in
               let posts = owner.viewModel.posts.value.map {
                   var post = $0
                   if post.id == element.id {
                         post.isExpand = !element.isExpand
                         post.currentImagePage = cell.currentPage.value
                   }
                 return post
               }
            owner.viewModel.posts.accept(posts)
            }
           .disposed(by: cell.disposeBag)
}

```
     
<br>
