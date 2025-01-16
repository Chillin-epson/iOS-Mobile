# 칠하다 - 상상한 것을 색칠하고 프린트하다. 

<p>
<img src="https://github.com/user-attachments/assets/3c36be2f-3ea8-4a90-92c7-4a125d153fa6" width="25%">
<img src="https://github.com/user-attachments/assets/142cc510-254d-4923-988c-d79681e214e7" width="15%">


<img src="https://github.com/user-attachments/assets/deef0ce2-a9cf-4c02-9a60-f654711c439b" width="23%">
<p>

- [News Article - EPSON Innovation Chanllenge 공식 뉴스 기사](http://www.mediagb.kr/news/view.php?idx=35219)</br>

- [한국 엡손 EPSON 공식 블로그 기사](https://blog.naver.com/epsonstory/223554685463)</br>

- [실제 글로벌 기업 EPSON 홍보에 쓰인 유튜브 영상 링크](https://youtu.be/ldD-e7rh5Lo)</br>


## 프로젝트 소개
### 앱 설명
 - 칠하다 앱은 AI 기술을 활용하여 아이가 상상한 그림을 음성으로 입력하면 해당 도안을 생성하고, 이를 프린트하여 색칠 놀이를 즐길 수 있는 앱입니다. 색칠이 완료된 후에는 도안을 스캔하여, 색칠한 캐릭터와 함께 사진을 찍어 추억을 남길 수 있습니다.
 
 <img src="https://github.com/user-attachments/assets/d8854ab6-c450-47ee-a990-11f3066264e8" width="100%">
 
<img src="https://github.com/user-attachments/assets/57dc5614-bf74-4578-8909-1bc9dd3bd91c" width="100%">

### 성과
 - 엡손 Epson Innovation Challenge 최우수상(1위) 수상, 상금 1,000만 원</br>
 - 국내 최초 개최 및 세계 3번째로 열린 글로벌 대회에서 우승
 - 엡손 Epson과 파트너쉽 체결, 글로벌 앱 런칭 진행중</br>
 
 <img src="https://github.com/user-attachments/assets/582d07ce-41ed-4ea7-888f-feac27aa24e5" width="90%"></br>
    한국엡손(주) 대표이사 후지이 시게오(CEO)
 
### 프로젝트 기간
- 2024.06.01 ~ 2024.6.29 (4주) </br>

### 프로젝트 참여 인원
- iOS Developer 1명, Back-end 2명, Design 1명, PM 1명

</br>

## 기술 스택
- **Framework**
`UIKit`, `Speech`, `Alamofire`, `Kingfisher`, `SnapKit`, `Photos`, `AVFoundation`, `Gifu`, `Lottie`

- **Design Pattern**
`MVC`

- **전체 시스템 아키텍처**
 <img src="https://github.com/user-attachments/assets/ee45f724-b13b-4777-8ed1-6c282a5266a3" width="100%"></br>

</br>

## 핵심 기능과 코드 설명

- 1.음성인식을 활용한 텍스트 추출 및 도안 생성</br>
- 2. </br>
- 3. </br>
- 4. </br>


 ### 1.음성인식을 활용한 텍스트 추출 및 도안 생성</br>
    칠하다 앱은 음성인식(Speech Recognition)을 활용하여 사용자의 음성을 실시간으로 텍스트로 변환합니다. 변환된 텍스트는 AI 기반 도안 생성 API와 연동되어, 사용자가 상상한 내용을 도안으로 시각화합니다. 음성인식의 효율성을 높이기 위해 iOS의 SFSpeechRecognizer를 사용하고, 비동기 네트워크 요청으로 사용자 경험을 향상시켰습니다.
    
 <img src="https://github.com/user-attachments/assets/019a628a-62e5-4273-8114-55c8a9237037" width="99%"></br>

