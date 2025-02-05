//
//  TimerViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2025/02/04.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    var timer: Timer = Timer()
    var count: Int = 0
    var isRunning: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar()
    }
    @IBAction func tappedStartStopButton(_ sender: UIButton) {
        if(isRunning) {
            isRunning = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
        } else {
            isRunning = true
            startStopButton.setTitle("STOP", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    @IBAction func tappedResetButton(_ sender: UIButton) {
        self.count = 0
        self.timer.invalidate()
        self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
        self.startStopButton.setTitle("START", for: .normal)
    }

    @objc func timerCounter() {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }

    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }

    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }

    func configureNavigationBar() {
        let closeButton = UIBarButtonItem(title: "戻る",
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = closeButton // leftかrightかで左右を選択
    }

    @objc func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
}
