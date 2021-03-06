//
//  ViewController.swift
//  ApplePie
//
//  Created by Burak Donat on 29.01.2019.
//  Copyright © 2019 Burak Donat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentGame : Game!
    var listofwords : [String] = ["test", "chicago" , "orlando"]
    let incorrectMovesAllowed = 7 // How many incrorrect guesses are allowed per round
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLoses = 0 {
        didSet {
            newRound()
        }
    }
    
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString  = sender.title(for: .normal)!
        let guessedLetter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: guessedLetter)
        updateGameState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listofwords = ["test", "chicago" , "orlando", "miami", "lasvegas", "losangeles", "seattle", "boston", "newyork", "washington", "philadelphia"]
        totalLoses = 0
        totalWins = 0
    }
    
    func newRound() {
        if !listofwords.isEmpty {
        let newWord = listofwords.removeFirst()
        currentGame = Game(word: newWord , incorrectMovesRemaining : incorrectMovesAllowed , guessedLetters: [])
            enableLettersButtons(true)
            updateUI ()
        } else {
            goToResult()
        }
    }
    
    func enableLettersButtons (_ enable : Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }

    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord{
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins) Loses: \(totalLoses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    func updateGameState(){
        if currentGame.incorrectMovesRemaining == 0 {
            totalLoses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func goToResult() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let wins : ResultViewController = mainStoryboard.instantiateViewController(withIdentifier: "ResultVC") as! ResultViewController
        wins.modalPresentationStyle = .fullScreen
        wins.totalWins = totalWins
        self.present(wins, animated: true, completion: nil)
    }
}

