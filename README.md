# LifeFlow

### 프로젝트
 - 인원 : 개인프로젝트 <br>
 - 기간 : 2023.11.27 ~ 2023.12.15 (3주) <br>
 - 최소지원버전 : iOS 17 <br>
 
<br>

### 한줄소개
 - 일상 생활을 공유할 수 있는 소셜 커뮤니티 앱 입니다.

<br>

### 미리보기
![라이프플로우 001](https://github.com/J-comet/LifeFlow/assets/67407666/4af6b50e-55f4-4ac2-82c2-96baf8d1e905)

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
- SeSAC iOS 앱 개발자 데뷔과정 교육생에게 제한적으로 제공되는 API 서버

<br>

### 기능
- 회원가입 / 로그인 / 로그아웃 / 회원탈퇴
- 게시글 작성 / 수정 / 삭제 / 불러오기
- 게시글 좋아요 / 댓글 작성
- 프로필 조회

<br>

### 개발 고려사항
- 데이터에 변동에 따라 UI 갱신되도록 MVVM 디자인패턴 적용
- Alamofire RequestInterceptor 를 활용해 AccessToken 관리
- DTO 적용해 서버의 파라미터명이 변경되어도 비정상적인 종료 방지
- RxSwift Single 활용해 Error 발생시에도 구독이 해제되지 않도록 구현
- 업로드 가능한 최대 용량에 따라 이미지 리사이징 후 다중이미지 업로드 구현
- enum 활용해 APIError 코드별로 분기 처리


