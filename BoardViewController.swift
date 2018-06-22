//
//  ViewController.swift
//  Othello++
//
//  Created by B++ on 2/23/18.
//  Copyright © 2018 Ben Miller. All rights reserved.
//

import UIKit

var pieceButtons2D = [[UIButton]]()
var playerTurns: [String] = ["Blue","Red","Green","White"]
var possibleAIScores = [Int]()



class BoardViewController: UIViewController{
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var redImageView: UIImageView!
    @IBOutlet weak var whiteImageView: UIImageView!
    @IBOutlet weak var greenImageView: UIImageView!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var whiteScoreLabel: UILabel!
    @IBOutlet weak var greenScoreLabel: UILabel!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var redActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blueActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var whiteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var greenActivityIndicator: UIActivityIndicatorView!
    
    
    var playersSelection = [String]()//temp until new game is started then gets cleared
    var pieceButtons = [UIButton]()
    var game = GameLogic()
    var totalScore = 12
    var timer = Timer()
    var count = 0
    var quitting = false
    
    
    @IBAction func newGame(_ sender: UIButton) {
        playersSelection.removeAll()
        quitting = true
        timer.invalidate()
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerTurns = ["Blue","Red","Green","White"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(willAppearActivity), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActivity), name: .UIApplicationWillResignActive, object: nil)
        
        for subview in boardView.subviews where subview.tag==1000 {
            pieceButtons.append(subview as! UIButton)
        }
        for button in pieceButtons {
            button.setImage(UIImage(named: "Black"), for: .normal)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        }
        pieceButtons2D.removeAll()
        for index in 0 ..< pieceButtons.count/14 {
            var tempArr = [UIButton]()
            for j in 0..<pieceButtons.count/14 {
                let spot = index*14+j
                tempArr.append(pieceButtons[spot])
            }
            pieceButtons2D.append(tempArr)
        }
        //place the pieces down on the board
        newGame()
        
    }
    
    @objc func willAppearActivity(_ notification: Notification){
        if let myLoadedImages = UserDefaults.standard.imageArray(forKey:"board") {
            updateBoard(board: myLoadedImages)
        }
    }
    
    @objc func willResignActivity(_ notification: Notification) {
        timer.invalidate()
        UserDefaults.standard.set(imageArray: makeTempBoard(), forKey: "board")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: New game
    func newGame(){
        for r in pieceButtons2D.indices{
            for button in pieceButtons2D[r]{
                button.setImage(UIImage(named: "Black"), for: .normal)
            }
        }
        game = GameLogic(playersSelection)
        print("\(playerTurns[0]): \(playersSelection[0])")
        print("\(playerTurns[1]): \(playersSelection[1])")
        print("\(playerTurns[2]): \(playersSelection[2])")
        print("\(playerTurns[3]): \(playersSelection[3])")
        
        game.newGame()
        blueImageView.alpha = 1
        redImageView.alpha = 0.25
        whiteImageView.alpha = 0.25
        greenImageView.alpha = 0.25
        pieceButtons2D[6][6].setImage(UIImage(named:"Blue"), for: .normal)
        pieceButtons2D[6][7].setImage(UIImage(named:"Red"), for: .normal)
        pieceButtons2D[7][6].setImage(UIImage(named:"Green"), for: .normal)
        pieceButtons2D[7][7].setImage(UIImage(named:"White"), for: .normal)
        pieceButtons2D[5][6].setImage(UIImage(named:"White"), for: .normal)
        pieceButtons2D[6][5].setImage(UIImage(named:"White"), for: .normal)
        pieceButtons2D[5][7].setImage(UIImage(named:"Green"), for: .normal)
        pieceButtons2D[6][8].setImage(UIImage(named:"Green"), for: .normal)
        pieceButtons2D[7][8].setImage(UIImage(named:"Blue"), for: .normal)
        pieceButtons2D[8][7].setImage(UIImage(named:"Blue"), for: .normal)
        pieceButtons2D[7][5].setImage(UIImage(named:"Red"), for: .normal)
        pieceButtons2D[8][6].setImage(UIImage(named:"Red"), for: .normal)
        blueImageView.image = UIImage(named: "Blue")
        redImageView.image = UIImage(named: "Red")
        whiteImageView.image = UIImage(named: "White")
        greenImageView.image = UIImage(named: "Green")
        enableButtons()
        updateLabels()
        pieceButtons2D[6][6].isUserInteractionEnabled = false
        pieceButtons2D[6][7].isUserInteractionEnabled = false
        pieceButtons2D[7][6].isUserInteractionEnabled = false
        pieceButtons2D[7][7].isUserInteractionEnabled = false
        pieceButtons2D[5][6].isUserInteractionEnabled = false
        pieceButtons2D[6][5].isUserInteractionEnabled = false
        pieceButtons2D[5][7].isUserInteractionEnabled = false
        pieceButtons2D[6][8].isUserInteractionEnabled = false
        pieceButtons2D[7][8].isUserInteractionEnabled = false
        pieceButtons2D[8][7].isUserInteractionEnabled = false
        pieceButtons2D[7][5].isUserInteractionEnabled = false
        pieceButtons2D[8][6].isUserInteractionEnabled = false
        
        if playersSelection[0] == "hardcpu" {//Test
            activateActivityIndicator()
            disableButtons()
            hardAIMove()
            enableButtons()
        }else if playersSelection[0] == "cpu" {
            activateActivityIndicator()
            disableButtons()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(BoardViewController.easyAIMove), userInfo: nil, repeats: true)
            easyAIMove()
            enableButtons()
        }
    }
    
    func endGame(){
        timer.invalidate()
        blueImageView.alpha = 0.25
        redImageView.alpha = 0.25
        whiteImageView.alpha = 0.25
        greenImageView.alpha = 0.25
        
        if game.blueScore > game.redScore && game.blueScore > game.greenScore && game.blueScore > game.whiteScore {
            endGameBox(title: "Blue Wins", message: "Blue has won with a score of \(game.blueScore)")
        }else if game.greenScore > game.redScore && game.greenScore > game.blueScore && game.greenScore > game.whiteScore {
            endGameBox(title: "Green Wins", message: "Green has won with a score of \(game.greenScore)")
        }else if game.redScore > game.blueScore && game.redScore > game.greenScore && game.redScore > game.whiteScore {
            endGameBox(title: "Red Wins", message: "Red has won with a score of \(game.redScore)")
        }else if game.whiteScore > game.redScore && game.whiteScore > game.greenScore && game.whiteScore > game.blueScore {
            endGameBox(title: "White Wins", message: "White has won with a score of \(game.whiteScore)")
        }else{
            endGameBox(title: "Tie", message: "There was a tie so nobody wins")
        }
    }
    
    func endGameBox(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let newGameButton = UIAlertAction(title: "New Game", style: .default){ _ in self.newGame(UIButton()) }
        alert.addAction(newGameButton)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonPressed(sender: UIButton!){
        disableButtons()
        let (r,c) = locateButton(button: sender)
        let tempBoard = makeTempBoard()
        let legalMove = game.checkLegalMove(atRow: r, atColumn: c, testing: false)
        if legalMove{
            sender.isUserInteractionEnabled = false
            updateLabels()
            game.updateScore()
            switchTurn()
        } else {
            sender.isUserInteractionEnabled = true
            updateBoard(board: tempBoard)
            game.updateScore()
            updateLabels()
        }
        if game.redScore + game.blueScore + game.whiteScore + game.greenScore == 196 {
            endGame()
        }
        enableButtons()
    }
    
    func makeTempBoard() -> [UIImage]{ // grabs all the images from pieceButtons2D and puts them into an array
        var tempBoard = [UIImage](repeating: UIImage(named: "Black")!, count: 0)
        
        var counter = 0
        for r in pieceButtons2D.indices {
            for c in pieceButtons2D[r].indices{
                if let image = pieceButtons2D[r][c].currentImage{
                    tempBoard.insert(image, at: counter)
                }
                counter += 1
            }
        }
        return tempBoard
    }
    
    func updateBoard(board: [UIImage]){//takes array of UIImages from makeTempBoard to set pieceButtons2D to correct images after making a change to the board
        var count = 0
        for r in pieceButtons2D.indices{
            for c in pieceButtons2D.indices{
                pieceButtons2D[r][c].setImage(board[count], for: .normal)
                count += 1
            }
        }
    }
    func updateLabels(){
        blueScoreLabel.text = "\(game.blueScore) :Score"
        greenScoreLabel.text = "\(game.greenScore) :Score"
        whiteScoreLabel.text = "Score: \(game.whiteScore)"
        redScoreLabel.text = "Score: \(game.redScore)"
    }
    
    func switchTurn(){
        
        print("\n switching turns")
        deactivateActivityIndicator()
        disableButtons()
        timer.invalidate()
        totalScore = game.redScore + game.blueScore + game.whiteScore + game.greenScore
        playerTurns.append(playerTurns[0])
        playerTurns.remove(at: 0)
        playersSelection.append(playersSelection[0])
        playersSelection.remove(at: 0)
        blueImageView.alpha = 0.25
        redImageView.alpha = 0.25
        whiteImageView.alpha = 0.25
        greenImageView.alpha = 0.25
        switch playerTurns[0] {
        case "Blue":
            blueImageView.alpha = 1
        case "Green":
            greenImageView.alpha = 1
        case "White":
            whiteImageView.alpha = 1
        case "Red":
            redImageView.alpha = 1
        default:
            print("This should not happen")
        }
        
        if totalScore > 170 && totalScore != 196, !possibleMoves(){
            count += 1
            if count == 4{
                count = 0
                quitting = true
                endGame()
            }else{
                switchTurn()
            }
        }
        
        if totalScore == 196{
            quitting = true
            endGame()
        }
        
        
        if playersSelection[0] == "hardcpu" {//Test
            activateActivityIndicator()
            disableButtons()
            hardAIMove()
            enableButtons()
        }else if playersSelection[0] == "cpu" {
            activateActivityIndicator()
            disableButtons()
            DispatchQueue.main.async{
                
                self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(BoardViewController.easyAIMove), userInfo: nil, repeats: true)
            }
            
        }
        enableButtons()
    }
    
    func possibleMoves() -> Bool{//Checks if there are any legal moves to make
        for r in pieceButtons2D.indices{
            for c in pieceButtons2D[r].indices{
                if pieceButtons2D[r][c].currentImage == UIImage(named: "Black"){
                    if game.checkLegalMove(atRow: r, atColumn: c, testing: true){
                        count = 0
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func locateButton(button: UIButton) -> (Int,Int){
        for r in pieceButtons2D.indices {
            for c in pieceButtons2D[r].indices{
                if pieceButtons2D[r][c] == button{
                    return (r,c)
                }
            }
        }
        return (-1,-1)
    }
    
    func enableButtons(){
        for r in pieceButtons2D.indices {
            for button in pieceButtons2D[r]{
                if button.currentImage == UIImage(named: "Black"){
                    button.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func disableButtons(){
        for r in pieceButtons2D.indices {
            for button in pieceButtons2D[r]{
                button.isUserInteractionEnabled = false
            }
        }
    }
    
    func activateActivityIndicator(){
        print("activating")
        switch playerTurns[0] {
        case "Blue":
            blueActivityIndicator.startAnimating()
        case "Green":
            greenActivityIndicator.startAnimating()
        case "White":
            whiteActivityIndicator.startAnimating()
        case "Red":
            redActivityIndicator.startAnimating()
        default:
            print("This should not happen")
        }
    }
    
    func deactivateActivityIndicator(){
        print("deactivating")
        blueActivityIndicator.stopAnimating()
        greenActivityIndicator.stopAnimating()
        whiteActivityIndicator.stopAnimating()
        redActivityIndicator.stopAnimating()
    }
    
    //MARK: AI
    
    @objc func easyAIMove(){
        var r: Int
        var c: Int
        r = Int(arc4random_uniform(14))
        c = Int(arc4random_uniform(14))
        if pieceButtons2D[r][c].currentImage == UIImage(named: "Black"){
            if game.checkLegalMove(atRow: r, atColumn: c, testing: true){
                buttonPressed(sender: pieceButtons2D[r][c])
                enableButtons()
            }
        }
    }
    
    func hardAIMove(){//Should not trust but going to trust anyway
        var rPosition = [Int]()
        var cPosition = [Int]()
        var highestScore = 0
        var index = -1
        let startBoard = self.makeTempBoard()
        DispatchQueue.global(qos: .background).async{
            DispatchQueue.main.async{
                if !self.quitting{
                    for r in pieceButtons2D.indices{
                        for c in pieceButtons2D[r].indices{
                            self.updateBoard(board: startBoard)
                            print("\(r) \(c)")
                            if pieceButtons2D[r][c].currentImage == UIImage(named: "Black"){
                                if self.game.checkLegalMove(atRow: r, atColumn: c, testing: false){
                                    if self.game.checkScore(){
                                        switch playerTurns[0] {
                                        case "Blue":
                                            possibleAIScores.append(self.game.blueScore)
                                        case "Green":
                                            possibleAIScores.append(self.game.greenScore)
                                        case "White":
                                            possibleAIScores.append(self.game.whiteScore)
                                        case "Red":
                                            possibleAIScores.append(self.game.redScore)
                                        default:
                                            print("This should not happen")
                                        }
                                        rPosition.append(r)
                                        cPosition.append(c)
                                    }
                                }
                            }
                        }
                    }
                    self.updateBoard(board: startBoard)
                    print(rPosition)
                    print(index)
                    for i in possibleAIScores.indices {
                        if highestScore < possibleAIScores[i]{
                            highestScore = possibleAIScores[i]
                            index = i
                        }else if highestScore == possibleAIScores[i]{
                            let choice = arc4random_uniform(2)
                            if choice == 1  || index == -1{
                                highestScore = possibleAIScores[i]
                                index = i
                            }
                        }
                    }
                    print(index)
                    self.buttonPressed(sender: pieceButtons2D[rPosition[index]][cPosition[index]])
                    self.enableButtons()
                }
            }
        }
        possibleAIScores.removeAll()
        updateLabels()
    }
}

//MARK: Saving
extension UserDefaults {
    func set(image: UIImage?, forKey key: String) {
        guard let image = image else {
            set(nil, forKey: key)
            return
        }
        set(UIImageJPEGRepresentation(image, 1.0), forKey: key)
    }
    func image(forKey key:String) -> UIImage? {
        guard let data = data(forKey: key), let image = UIImage(data: data )
            else  { return nil }
        return image
    }
    func set(imageArray value: [UIImage]?, forKey key: String) {
        guard let value = value else {
            set(nil, forKey: key)
            return
        }
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }
    func imageArray(forKey key:String) -> [UIImage]? {
        guard  let data = data(forKey: key),
            let imageArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UIImage]
            else { return nil }
        return imageArray
    }
}
    

















