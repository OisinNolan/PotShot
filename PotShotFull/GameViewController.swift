//
//  GameViewController.swift
//  Shooter
//
//  Created by Nuala O' Dea on 27/07/2015.
//  Copyright (c) 2015 oisinnolan. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highscoreTextLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var finalscoreTextLabel: UILabel!
    @IBOutlet weak var finalscoreLabel: UILabel!
    @IBOutlet weak var taptoshootLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankedupLabel: UILabel!
    
    var score = 0
    var firstTime = true
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gameOverLabel.hidden = true
        highscoreLabel.hidden = true
        highscoreTextLabel.hidden = true
        scoreLabel.hidden = true
        finalscoreTextLabel.hidden = true
        finalscoreLabel.hidden = true
        taptoshootLabel.hidden = true
        rankedupLabel.hidden = true
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.viewController = self
            
            skView.presentScene(scene)
        }
    }
    
    var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore1")
    
    func checkHighscore() {
    
        if score > NSUserDefaults.standardUserDefaults().integerForKey("highscore1") {
            
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore1")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            checkLevel()
        }
        
        highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore1")
        highscoreLabel.text = String(highscore)
        
    }
    
    func checkLevel() {
        if highscore < 25 {
            level = 1
            rankLabel.text = ""
        }
        if highscore >= 25 {
            level = 2
            rankLabel.text = "Rank: Red"
            rankLabel.hidden = false
        }
        if highscore >= 50 {
            level = 3
            rankLabel.text = "Rank: Orange"
            rankLabel.hidden = false
        }
        if highscore >= 75 {
            level = 4
            rankLabel.text = "Rank: Yellow"
            rankLabel.hidden = false
        }
        if highscore >= 100 {
            level = 5
            rankLabel.text = "Rank: Green"
            rankLabel.hidden = false
        }
        if highscore >= 125 {
            level = 6
            rankLabel.text = "Rank: Cyan"
            rankLabel.hidden = false
        }
        if highscore >= 150 {
            level = 7
            rankLabel.text = "Rank: Blue"
            rankLabel.hidden = false
        }
        if highscore >= 175 {
            level = 8
            rankLabel.text = "Rank: Purple"
            rankLabel.hidden = false
        }
        if highscore >= 200 {
            level = 9
            rankLabel.text = "Rank: Pink"
            rankLabel.hidden = false
        }
    }
    
    func rankUp() {
        rankedupLabel.alpha = 1.0
        rankedupLabel.hidden = false
        UILabel.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.rankedupLabel.alpha = 0.0
            }, completion: nil)
    }
    
    func addScore() {
        score++
        scoreLabel.text = String(score)
        checkHighscore()
        if score == 25 && level == 1 {
            rankUp()
        }
        if score == 50 && level == 2{
            rankUp()
        }
        if score == 75 && level == 3{
            rankUp()
        }
        if score == 100 && level == 4{
            rankUp()
        }
        if score == 125 && level == 5{
            rankUp()
        }
        if score == 150 && level == 6{
            rankUp()
        }
        if score == 175 && level == 7{
            rankUp()
        }
        if score == 200 && level == 8{
            rankUp()
        }
    }
    
    func resetScore() {
        score = 0
        scoreLabel.text = String(score)
    }
    
    func showScore() {
        scoreLabel.hidden = false
        scoreLabel.alpha = 0.0
        UILabel.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.scoreLabel.alpha = 1.0
            }, completion: nil)
    }
    
    func hideScore() {
        scoreLabel.alpha = 1.0
        UILabel.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.scoreLabel.alpha = 0.0
            }, completion: nil)
    }
    
    func showStart() {
        showTitle()
        startLabel.hidden = false
    }
    
    func hideStart() {
        startLabel.hidden = true
        hideTitle()
    }
    
    func showGameOver() {
        gameOverLabel.alpha = 0.0
        finalscoreLabel.alpha = 0.0
        finalscoreTextLabel.alpha = 0.0
        finalscoreLabel.text = String(score)
        gameOverLabel.hidden = false
        finalscoreLabel.hidden = false
        finalscoreTextLabel.hidden = false
        UILabel.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.gameOverLabel.alpha = 1.0
            self.finalscoreLabel.alpha = 1.0
            self.finalscoreTextLabel.alpha = 1.0
            }, completion: nil)
    }
    
    func hideTitle() {
        titleLabel.alpha = 1.0
        highscoreLabel.alpha = 1.0
        highscoreTextLabel.alpha = 1.0
        rankLabel.alpha = 1.0
        UILabel.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.titleLabel.alpha = 0.0
            self.highscoreTextLabel.alpha = 0.0
            self.highscoreLabel.alpha = 0.0
            self.rankLabel.alpha = 0.0
            }, completion: nil)
        delay(0.2) {
            self.showScore()
            self.taptoshootLabel.alpha = 0.0
            self.taptoshootLabel.hidden = false
            UILabel.animateWithDuration(0.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.taptoshootLabel.alpha = 1.0
            }, completion: nil)
        }
        delay(0.6) {
            self.taptoshootLabel.alpha = 1.0
            UILabel.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.taptoshootLabel.alpha = 0.0
                }, completion: nil)
        }
    }
    
    func showTitle() {
        
        titleLabel.alpha = 0.0
        highscoreLabel.alpha = 0.0
        highscoreTextLabel.alpha = 0.0
        rankLabel.alpha = 0.0
        highscoreLabel.hidden = false
        highscoreTextLabel.hidden = false
        UILabel.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.titleLabel.alpha = 1.0
            self.rankLabel.alpha = 1.0
            }, completion: nil)
        if highscore != 0 {
            UILabel.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.highscoreLabel.alpha = 1.0
                self.highscoreTextLabel.alpha = 1.0
                }, completion: nil)
        }
    }
    
    func hideGameOver() {
        gameOverLabel.hidden = true
        finalscoreTextLabel.hidden = true
        finalscoreLabel.hidden = true
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func delay(delayInSeconds:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delayInSeconds * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
