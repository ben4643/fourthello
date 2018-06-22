//
//  SelectionViewController.swift
//  Othello++
//
//  Created by B++ on 4/24/18.
//  Copyright © 2018 Ben Miller. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    var choice = ["user","cpu","hardcpu"]
    var blueChoice = 0
    var redChoice = 0
    var greenChoice = 0
    var whiteChoice = 0
    
    @IBOutlet weak var blueUserImage: UIImageView!
    @IBOutlet weak var blueCPUImage: UIImageView!
    @IBOutlet weak var blueHardCPUImage: UIImageView!
    @IBOutlet weak var redUserImage: UIImageView!
    @IBOutlet weak var redCPUImage: UIImageView!
    @IBOutlet weak var redHardCPUImage: UIImageView!
    @IBOutlet weak var greenUserImage: UIImageView!
    @IBOutlet weak var greenCPUImage: UIImageView!
    @IBOutlet weak var greenHardCPUImage: UIImageView!
    @IBOutlet weak var whiteUserImage: UIImageView!
    @IBOutlet weak var whiteCPUImage: UIImageView!
    @IBOutlet weak var whiteHardCPUImage: UIImageView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "startGame" {
            let vc = segue.destination as! BoardViewController
            vc.playersSelection.removeAll()
            vc.playersSelection.append(choice[blueChoice])
            vc.playersSelection.append(choice[redChoice])
            vc.playersSelection.append(choice[greenChoice])
            vc.playersSelection.append(choice[whiteChoice])
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func blueBar(_ sender: UIButton) {
        blueChoice += 1
        if blueChoice == 3 {
            blueChoice = 0
        }
        switch blueChoice {
        case 0:
            blueUserImage.alpha = 1
            blueCPUImage.alpha = 0.25
            blueHardCPUImage.alpha = 0.25
        case 1:
            blueUserImage.alpha = 0.25
            blueCPUImage.alpha = 1
            blueHardCPUImage.alpha = 0.25
        case 2:
            blueUserImage.alpha = 0.25
            blueCPUImage.alpha = 0.25
            blueHardCPUImage.alpha = 1
        default:
            blueUserImage.alpha = 0.25
            blueCPUImage.alpha = 0.25
            blueHardCPUImage.alpha = 0.25
        }
    }
    
    @IBAction func redBar(_ sender: UIButton) {
        redChoice += 1
        if redChoice == 3 {
            redChoice = 0
        }
        switch redChoice {
        case 0:
            redUserImage.alpha = 1
            redCPUImage.alpha = 0.25
            redHardCPUImage.alpha = 0.25
        case 1:
            redUserImage.alpha = 0.25
            redCPUImage.alpha = 1
            redHardCPUImage.alpha = 0.25
        case 2:
            redUserImage.alpha = 0.25
            redCPUImage.alpha = 0.25
            redHardCPUImage.alpha = 1
        default:
            redUserImage.alpha = 0.25
            redCPUImage.alpha = 0.25
            redHardCPUImage.alpha = 0.25
        }
    }
    
    @IBAction func greenBar(_ sender: UIButton) {
        greenChoice += 1
        if greenChoice == 3 {
            greenChoice = 0
        }
        switch greenChoice {
        case 0:
            greenUserImage.alpha = 1
            greenCPUImage.alpha = 0.25
            greenHardCPUImage.alpha = 0.25
        case 1:
            greenUserImage.alpha = 0.25
            greenCPUImage.alpha = 1
            greenHardCPUImage.alpha = 0.25
        case 2:
            greenUserImage.alpha = 0.25
            greenCPUImage.alpha = 0.25
            greenHardCPUImage.alpha = 1
        default:
            greenUserImage.alpha = 0.25
            greenCPUImage.alpha = 0.25
            greenHardCPUImage.alpha = 0.25
        }
    }
    
    
    @IBAction func whiteBar(_ sender: UIButton) {
        whiteChoice += 1
        if whiteChoice == 3 {
            whiteChoice = 0
        }
        switch whiteChoice {
        case 0:
            whiteUserImage.alpha = 1
            whiteCPUImage.alpha = 0.25
            whiteHardCPUImage.alpha = 0.25
        case 1:
            whiteUserImage.alpha = 0.25
            whiteCPUImage.alpha = 1
            whiteHardCPUImage.alpha = 0.25
        case 2:
            whiteUserImage.alpha = 0.25
            whiteCPUImage.alpha = 0.25
            whiteHardCPUImage.alpha = 1
        default:
            whiteUserImage.alpha = 0.25
            whiteCPUImage.alpha = 0.25
            whiteHardCPUImage.alpha = 0.25
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blueCPUImage.alpha = 0.25
        blueHardCPUImage.alpha = 0.25
        redCPUImage.alpha = 0.25
        redHardCPUImage.alpha = 0.25
        greenCPUImage.alpha = 0.25
        greenHardCPUImage.alpha = 0.25
        whiteCPUImage.alpha = 0.25
        whiteHardCPUImage.alpha = 0.25
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
