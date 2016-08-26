//
//  CarViewController.swift
//  RPiProject
//
//  Created by wonderworld on 16/8/25.
//  Copyright © 2016年 haozhang. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {

    @IBOutlet weak var videoContainer: UIView!
    let mediaPlayer = VLCMediaPlayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSURL(string: "http://haozhang.win:8090/")
//        mediaPlayer.setMedia(VLCMedia(URL: url))
        mediaPlayer.media = VLCMedia(URL: url)
//        mediaPlayer.delegate = self
        mediaPlayer.drawable = videoContainer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mediaPlayer.play()
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func move(sender: UIButton) {
        switch sender.tag {
        case 1001:
            // forward
            Client.shared.sendMessage("forward")
        case 1002:
            // back
            Client.shared.sendMessage("back")
        case 1003:
            // turn_left
            Client.shared.sendMessage("left")
        case 1004:
            // turn_right
            Client.shared.sendMessage("right")
        default: break
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        // stop
        Client.shared.sendMessage("stop")
    }
}
