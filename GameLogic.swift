//
//  OthelloGame.swift
//  Othello++
//
//  Created by B++ on 3/5/18.
//  Copyright © 2018 Ben Miller. All rights reserved.
//

import Foundation
import UIKit

class GameLogic{
    public var redScore: Int
    public var blueScore: Int
    public var greenScore: Int
    public var whiteScore: Int
    public var blankSpaces: Int
    private var playersSelection:[String]
    private var testingMove = false
    
    init(){
        redScore = -1
        blueScore = -1
        greenScore = -1
        whiteScore = -1
        blankSpaces = -1
        self.playersSelection = [""]
    }
    
    init( _ playersSelection: [String]){
        redScore = 3
        blueScore = 3
        greenScore = 3
        whiteScore = 3
        blankSpaces = 192
        self.playersSelection = playersSelection
    }
    
    func newGame() {
        redScore = 3
        blueScore = 3
        greenScore = 3
        whiteScore = 3
    }
    
    
    //MARK: Check Move Methods
    
    func checkLegalMove(atRow r: Int,  atColumn c: Int, testing: Bool) -> Bool { // gets called from viewController to start chain reaction of functions
        if testing {
            testingMove = true
        } else {
            testingMove = false
        }
        if checkSurrondingPieces(atRow: r, atColumn: c){
            
            if checkScore(){
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    private func checkX(atRow r: Int, atColumn c: Int, direction: Int) -> Bool{ // direction is 4 if left and 5 if right any other is bad
        var iteration:Int!
        var limit:Int!
        switch direction {
        case 4:
            iteration = -1
            limit = 0
        case 5:
            iteration = 1
            limit = 13
        default:
            print("How did we get here")
        }
        
        for index in stride(from: c+(iteration*2), through: limit, by: iteration){
            
            if UIImage(named: playerTurns[0]) == pieceButtons2DView[r][index].currentImage{
                if !testingMove{
                    completeMove(fromRow: r, fromColumn: c, toRow: r, toColumn: index, direction: direction)
                }
                return true
            }else if pieceButtons2DView[r][index].currentImage == UIImage(named: "Black") {
                break
            }
        }
        return false
    }
    
    private func checkY(atRow r: Int, atColumn c: Int, direction: Int) -> Bool{// direction is 2 if up and 7 if down any other is bad
        var iteration:Int!
        var limit:Int!
        switch direction {
        case 2:
            iteration = -1
            limit = 0
        case 7:
            iteration = 1
            limit = 13
        default:
            print("How did we get here")
        }
        
        for index in stride(from: r+(iteration*2), through: limit, by: iteration){
            if UIImage(named: playerTurns[0]) == pieceButtons2DView[index][c].currentImage{
                if !testingMove{
                    completeMove(fromRow: r, fromColumn: c, toRow: index, toColumn: c, direction: direction)
                }
                return true
            }else if pieceButtons2DView[index][c].currentImage == UIImage(named: "Black") {
                break
            }
        }
        return false
    }
    
    private func checkDiagonal(atRow r: Int, atColumn c: Int, direction: Int) -> Bool{// direction is 1 if up left, 3 if up right, 6 if down left, 8 if down right any other is bad
        var iterationR:Int!
        var iterationC:Int!
        var r1: Int!
        var c1: Int!
        var limitR: Int!
        var limitC: Int!
        var count = 1
        switch direction {
        case 1:
            iterationR = -1
            iterationC = -1
            limitR = 0
            limitC = 0
        case 3:
            iterationR = -1
            iterationC = 1
            limitR = 0
            limitC = 13
        case 6:
            iterationR = 1
            iterationC = -1
            limitR = 13
            limitC = 0
        case 8:
            iterationR = 1
            iterationC = 1
            limitR = 13
            limitC = 13
        default:
            print("How did we get here")
        }
        while true {
            r1 = r + (iterationR*count)
            c1 = c + (iterationC*count)
            if r1 == limitR + iterationR || c1 == limitC + iterationC {
                break
            }
                 if UIImage(named: playerTurns[0]) == pieceButtons2DView[r1][c1].currentImage && count >= 2{
                    if !testingMove{
                        completeMove(fromRow: r, fromColumn: c, toRow: r1, toColumn: c1 , direction: direction)
                    }
                    return true
                }else if pieceButtons2DView[r1][c1].currentImage == UIImage(named: "Black") {
                    break
                }
                count += 1
        }
        return false
    }
    
    
    
    private func completeMove(fromRow r1:Int, fromColumn c1: Int, toRow r2: Int, toColumn c2: Int, direction: Int){ // direction is 1-8 for each square around piece 1 if up left 8 is down right
        var iterationR: Int!
        var iterationC: Int!
        var countR = 0
        var countC = 0
        switch direction {
        case 1:
            iterationR = -1
            iterationC = -1
            for r in stride(from: r1, to: r2, by: iterationR){
                countR += 1
                countC = 0
                for c in stride(from: c1, to: c2, by: iterationC){
                    countC += 1
                    if countR == countC{
                        pieceButtons2DView[r][c].setImage(UIImage(named: playerTurns[0]), for: .normal)
                    }
                }
            }
        case 2:
            iterationR = -1
            iterationC = 0
            for r in stride(from: r1, to: r2, by: iterationR){
                    pieceButtons2DView[r][c1].setImage(UIImage(named: playerTurns[0]), for: .normal)
            }
        case 3:
            iterationR = -1
            iterationC = 1
            for r in stride(from: r1, to: r2, by: iterationR){
                countR += 1
                countC = 0
                for c in stride(from: c1, to: c2, by: iterationC){
                    countC += 1
                    if countR == countC{
                        pieceButtons2DView[r][c].setImage(UIImage(named: playerTurns[0]), for: .normal)
                    }
                }
            }
        case 4:
            iterationR = 0
            iterationC = -1
                for c in stride(from: c1, to: c2, by: iterationC){
                    pieceButtons2DView[r1][c].setImage(UIImage(named: playerTurns[0]), for: .normal)
                }
        case 5:
            iterationR = 0
            iterationC = 1
                for c in stride(from: c1, to: c2, by: iterationC){
                    pieceButtons2DView[r1][c].setImage(UIImage(named: playerTurns[0]), for: .normal)
                }
        case 6:
            iterationR = 1
            iterationC = -1
            for r in stride(from: r1, to: r2, by: iterationR){
                countR += 1
                countC = 0
                for c in stride(from: c1, to: c2, by: iterationC){
                    countC += 1
                    if countR == countC{
                        pieceButtons2DView[r][c].setImage(UIImage(named: playerTurns[0]), for: .normal)
                    }
                }
            }
        case 7:
            iterationR = 1
            iterationC = 0
            for r in stride(from: r1, to: r2, by: iterationR){
                    pieceButtons2DView[r][c1].setImage(UIImage(named: playerTurns[0]), for: .normal)
            }
        case 8:
            iterationR = 1
            iterationC = 1
            for r in stride(from: r1, to: r2, by: iterationR){
                countR += 1
                countC = 0
                for c in stride(from: c1, to: c2, by: iterationC){
                    countC += 1
                    if countR == countC{
                        pieceButtons2DView[r][c].setImage(UIImage(named: playerTurns[0]), for: .normal)
                    }
                }
            }
        default:
            print("a lot went wrong to get here")
        }
        updateScore()
    }
        
    
    private func checkSurrondingPieces(atRow r: Int,  atColumn c: Int) -> Bool{ // checks if a piece is surronding the piece you placed down and calls checkX, checkY, or checkDiagonal based on it
        var returnValue = false
        if r != 0{
            if c != 0 {
                if (pieceButtons2DView[r-1][c-1].currentImage != UIImage(named: "Black") && pieceButtons2DView[r-1][c-1].currentImage != UIImage(named: playerTurns[0])){ //Up Left
                    
                        returnValue = checkDiagonal(atRow: r, atColumn: c, direction: 1)
                }
            }
            if (pieceButtons2DView[r-1][c].currentImage != UIImage(named: "Black") && pieceButtons2DView[r-1][c].currentImage != UIImage(named: playerTurns[0])){ //Up
                if !returnValue {
                    returnValue = checkY(atRow: r, atColumn: c, direction: 2)
                }else{
                   _ = checkY(atRow: r, atColumn: c, direction: 2)
                }
            }
            if c != 13 {
                if (pieceButtons2DView[r-1][c+1].currentImage != UIImage(named: "Black") && pieceButtons2DView[r-1][c+1].currentImage != UIImage(named: playerTurns[0])){ //Up Right
                    if !returnValue {
                        returnValue = checkDiagonal(atRow: r, atColumn: c, direction: 3)
                    }else {
                        _ = checkDiagonal(atRow: r, atColumn: c, direction: 3)
                    }
                }
            }
        }
        if c != 0 {
            if (pieceButtons2DView[r][c-1].currentImage != UIImage(named: "Black") && pieceButtons2DView[r][c-1].currentImage != UIImage(named: playerTurns[0])) { //Left
                if !returnValue {
                    returnValue = checkX(atRow: r, atColumn: c, direction: 4)
                }else {
                    _ = checkX(atRow: r, atColumn: c, direction: 4)
                }
            }
        }
        if c != 13{
            if (pieceButtons2DView[r][c+1].currentImage != UIImage(named: "Black") && pieceButtons2DView[r][c+1].currentImage != UIImage(named: playerTurns[0]) ){ //Right
                if !returnValue {
                    returnValue = checkX(atRow: r, atColumn: c, direction: 5)
                }else{
                    _ = checkX(atRow: r, atColumn: c, direction: 5)
                }
            }
        }
        if r != 13{
            if c != 0 {
                if (pieceButtons2DView[r+1][c-1].currentImage != UIImage(named: "Black") && pieceButtons2DView[r+1][c-1].currentImage != UIImage(named: playerTurns[0]) ){ //Down Left
                    if !returnValue {
                        returnValue = checkDiagonal(atRow: r, atColumn: c, direction: 6)
                    }else{
                        _ = checkDiagonal(atRow: r, atColumn: c, direction: 6)
                    }
                }
            }
            if (pieceButtons2DView[r+1][c].currentImage != UIImage(named: "Black") && pieceButtons2DView[r+1][c].currentImage != UIImage(named: playerTurns[0]) ){//Down
                if !returnValue {
                    returnValue = checkY(atRow: r, atColumn: c, direction: 7)
                } else {
                    _ = checkY(atRow: r, atColumn: c, direction: 7)
                }
            }
            if c != 13 {
                if (pieceButtons2DView[r+1][c+1].currentImage != UIImage(named: "Black") && pieceButtons2DView[r+1][c+1].currentImage != UIImage(named: playerTurns[0]) ){//Down Right
                    if !returnValue {
                        returnValue = checkDiagonal(atRow: r, atColumn: c, direction: 8)
                    }else {
                        _ = checkDiagonal(atRow: r, atColumn: c, direction: 8)
                    }
                }
            }
        }
        updateScore()
        return returnValue
    }
    
    //MARK: Score Methods
    
    func checkScore() -> Bool {
        if redScore == 0 || blueScore == 0 || whiteScore == 0 || greenScore == 0{
            return false
        }
        return true
    }
    
    func updateScore() {
        redScore = 0
        blueScore = 0
        greenScore = 0
        whiteScore = 0
        blankSpaces = 0
        for r in pieceButtons2DView.indices {
            for c in pieceButtons2DView.indices{
                if pieceButtons2DView[r][c].currentImage == UIImage(named:"Blue"){
                    blueScore += 1
                } else if pieceButtons2DView[r][c].currentImage == UIImage(named:"Green"){
                    greenScore += 1
                } else if pieceButtons2DView[r][c].currentImage == UIImage(named:"White") {
                    whiteScore += 1
                } else if pieceButtons2DView[r][c].currentImage == UIImage(named:"Red") {
                    redScore += 1
                } else {
                    blankSpaces += 1
                }
            }
        }
    }

}
