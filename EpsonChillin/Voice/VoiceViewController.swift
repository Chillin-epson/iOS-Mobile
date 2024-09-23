//
//  VoiceViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/15/24.
//

import UIKit
import Speech
import SnapKit
import Lottie
import Alamofire

class VoiceViewController: BaseViewController, SFSpeechRecognizerDelegate {
    
    let voiceView = VoiceView()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var recognizedText: String = ""
    private var isRecognizing: Bool = false
    private let bottomSheetView = BottomSheetView()
    private var drawingId: Int?
    
    override func loadView() {
        self.view = voiceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton
        
        voiceView.recordButton.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        voiceView.recordButton.isEnabled = false
        bottomSheetView.stopButton.addTarget(self, action: #selector(stopRecordingAndDismiss), for: .touchUpInside)
        voiceView.drawingButton.addTarget(self, action: #selector(generateDrawing), for: .touchUpInside)
        
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied, .restricted, .notDetermined:
                isButtonEnabled = false
            default:
                break
            }
            
            OperationQueue.main.addOperation {
                self.voiceView.recordButton.isEnabled = isButtonEnabled
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func configureView() {
    }
    
    @objc func closeButtonTapped() {
            dismiss(animated: true, completion: nil)
    }
    
    @objc func startRecording() {
        voiceView.removePlaceholder()
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            voiceView.recordButton.isEnabled = false
            voiceView.recordButton.setTitle("Stopping", for: .disabled)
            self.isRecognizing = false
        } else {
            startSpeechRecognition()
            voiceView.recordButton.setTitle("Stop", for: [])
            
            showBottomSheet()
        }
    }
    
    @objc func stopRecordingAndDismiss() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        self.recognizedText = bottomSheetView.getRecognizedText()
        if self.recognizedText.isEmpty {
            voiceView.setPlaceholder()
        } else {
            voiceView.textView.text = self.recognizedText
        }
        dismissBottomSheet()    }
    
    func startSpeechRecognition() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                self.bottomSheetView.updateText(self.recognizedText)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.voiceView.recordButton.isEnabled = true
                self.voiceView.recordButton.setTitle("Start", for: [])
                self.isRecognizing = false
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            self.isRecognizing = true
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func showBottomSheet() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(bottomSheetView)
            bottomSheetView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(window.frame.height / 3)
            }
            bottomSheetView.animateSheet()
        }
    }
    
    func dismissBottomSheet() {
        bottomSheetView.removeFromSuperview()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func generateDrawing() {
        let prompt = voiceView.textView.text ?? ""
        if prompt.isEmpty || prompt == voiceView.placeholderText {
            let alertController = UIAlertController(title: "확인!", message: "글자를 입력해주세요!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        voiceView.toggleLoading(true)
        startProgressBar()
        
        let parameters: [String: Any] = ["prompt": prompt]
        
        AF.request("https://api.zionhann.com/chillin/drawings/gen", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Generate Drawing Success: \(value)")
                if let json = value as? [String: Any],
                   let drawingId = json["drawingId"] as? Int,
                   let urlString = json["url"] as? String,
                   let url = URL(string: urlString) {
                    self.drawingId = drawingId
                    let createDrawingVC = CreateDrawingViewController()
                    createDrawingVC.loadImage(from: url)
                    createDrawingVC.drawingId = drawingId
                    self.navigationController?.pushViewController(createDrawingVC, animated: true)
                    
//                    let createVC = CreateDrawingViewController()
//                    let createNaviController = UINavigationController(rootViewController: createVC)
//                    createNaviController.modalPresentationStyle = .overFullScreen
//                    self.present(createNaviController, animated: true, completion: nil)
                    
                }
            case .failure(let error):
                
                print("Error: \(error)")
            }
        }
    }
    
    func startProgressBar() {
        var progress: Float = 0.0
        voiceView.setProgress(progress)
        let duration: Float = 35.0
        let increment = 1.0 / duration

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            progress += increment
            self.voiceView.setProgress(progress)
            if progress >= 1.0 {
                timer.invalidate()
                self.voiceView.toggleLoading(false)
            }
        }
    }
}













