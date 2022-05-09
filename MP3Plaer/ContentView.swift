//
//  ContentView.swift
//  MP3Plaer
//
//  Created by Вячеслав Квашнин on 07.01.2021.
//

import AVFoundation
import SwiftUI

class PlayerViewModel: ObservableObject {
    @Published public var maxDuration = 0.0
    private var player: AVAudioPlayer?
    
    public func play() {
        playSoung(name: "song")
        player?.play()
    }
    
    public func stop() {
        player?.stop()
    }
    
    public func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value) else { return }
        player?.currentTime = time
        player?.play()
    }
    
    private func playSoung(name: String) {
        guard let audioPath = Bundle.main.path(forResource: name, ofType: "mp3") else { return }
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            maxDuration = player?.duration ?? 0.0
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView: View {
    @State private var progress: Float = 0
    @ObservedObject var viewModel = PlayerViewModel()
    
    var body: some View {
        VStack {
            Slider(value: Binding(get: {
                Double(self.progress)
            }, set: { newValue in
                self.progress = Float(newValue)
                self.viewModel.setTime(value: Float(newValue))
            }), in: 0...viewModel.maxDuration)
            
            HStack {
                Button(action: {
                    self.viewModel.play()
                }, label: {
                    Text("Start")
                        .foregroundColor(.white)
                })
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50)
                    .background(Color.orange)
                    .cornerRadius(20)
                
                Button(action: {
                    self.viewModel.stop()
                }, label: {
                    Text("Stop")
                        .foregroundColor(.white)
                })
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50)
                    .background(Color.orange)
                    .cornerRadius(20)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
