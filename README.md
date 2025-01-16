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


 ### 1.음성인식을 활용한 텍스트 추출 및 도안 생성
칠하다 앱은 음성인식(Speech Recognition)을 활용하여 사용자의 음성을 실시간으로 텍스트로 변환합니다. 변환된 텍스트는 AI 기반 도안 생성 API와 연동되어, 사용자가 상상한 내용을 도안으로 시각화합니다. 음성인식의 효율성을 높이기 위해 iOS의 SFSpeechRecognizer를 사용하고, 비동기 네트워크 요청으로 사용자 경험을 향상시켰습니다.</br>

    
 <img src="https://github.com/user-attachments/assets/019a628a-62e5-4273-8114-55c8a9237037" width="99%"></br>

1. [`Speech` 프레임 워크 사용](https://developer.apple.com/documentation/speech/)</br>
2. `speechRecognizer`: 한국어 음성 인식을 담당
3. `recognitionRequest`: 음성 데이터를 SFSpeechRecognizer로 전달하는 요청 객체
4. `audioEngine`: 마이크 입력 데이터를 관리

 ``` swift
let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
var recognitionTask: SFSpeechRecognitionTask?
let audioEngine = AVAudioEngine()
 ```
</br>

### 1-1. 음성인식 시작
 - 사용자가 버튼을 누르면 음성 입력이 시작되며 audioEngine이 마이크 데이터를 수집</br>
 - 인식 중간에 버튼을 다시 누르면 음성 입력 종료</br>
 
``` swift
@objc func startRecording() {
    if audioEngine.isRunning {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        voiceView.recordButton.isEnabled = false
    } else {
        startSpeechRecognition()
        voiceView.recordButton.setTitle("Stop", for: [])
        showBottomSheet()
    }
}
```
 ### 1-2. 음성 데이터를 텍스트로 변환
  - 입력 데이터: audioEngine이 마이크 데이터를 수집해 recognitionRequest로 전달</br>
  - 텍스트 변환: 음성 데이터는 SFSpeechRecognizer로 변환되며, bestTranscription 속성에서 최적화된 텍스트를 가져옴</br>
  - 중간결과 처리: shouldReportPartialResults를 활성화하여 실시간으로 변환된 텍스트 표시</br>
  
``` swift
func startSpeechRecognition() {
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    let inputNode = audioEngine.inputNode

    recognitionRequest?.shouldReportPartialResults = true

    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
        if let result = result {
            self.recognizedText = result.bestTranscription.formattedString
            self.bottomSheetView.updateText(self.recognizedText)
        }
        if error != nil || result?.isFinal == true {
            self.audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            self.recognitionRequest = nil
            self.recognitionTask = nil
        }
    }

    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
        self.recognitionRequest?.append(buffer)
    }
    audioEngine.prepare()
    try? audioEngine.start()
}

```
 </br>
 
 ### 1-3. 변환된 텍스트를 기반으로 도안 생성
 - 변환된 테스트를 서버에 전달</br>
 - Alamofire로 통신 네트워크 요청을 비동기로 처리하여 UI가 멈추지 않도록 설정</br>
 - 도안 생성: 서버에서 생성된 도안의 URL과 ID를 반환</br>
 - JSON 형식으로 변환된 데이터를 간편하게 서버로 전송</br>
 - 생성된 도안 결과 표시: 도안을 로드하여 새로운 화면에서 사용자에게 시각화</br>

```swift
@objc func generateDrawing() {
    let prompt = voiceView.textView.text ?? ""
    let parameters: [String: Any] = ["prompt": prompt]

    AF.request("https://api.zionhann.com/chillin/drawings/gen", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let drawingId = json["drawingId"] as? Int,
                   let urlString = json["url"] as? String,
                   let url = URL(string: urlString) {
                    let createDrawingVC = CreateDrawingViewController()
                    createDrawingVC.loadImage(from: url)
                    createDrawingVC.drawingId = drawingId
                    self.navigationController?.pushViewController(createDrawingVC, animated: true)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
}


```
