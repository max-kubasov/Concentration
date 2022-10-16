//
//  ViewController.swift
//  Concentration
//
//  Created by Max on 14.10.2022.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = ConcentrationGame(numberOfPairOfCards: numberOfPairOfCards)
    
    var numberOfPairOfCards: Int {
        (buttonCollection.count + 1) / 2
    }
    
    private func updateTouches() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.red
        ]
        let attributedString = NSAttributedString(string: "Touches: \(touches)", attributes: attributes)
        touchLabel.attributedText = attributedString
    }
    
    private(set) var touches = 0 {
        didSet {
            updateTouches()
        }
    }
    
    private var emojiCollection = ["🦊", "🐰", "🦅", "🐥", "🐴", "🐌", "🦖", "🐙", "🐳", "🦍", "🦒", "🐏", "🦥", "🐿"]
    
    private var emojiDictionary = [Card:String]()
    
    
    private func emojiIdentifier (for card: Card) -> String {
        if emojiDictionary[card] == nil {
            emojiDictionary[card] = emojiCollection.remove(at: emojiCollection.count.arc4randomExtension)
        }
        return emojiDictionary[card] ?? "?"
    }
    
    private func updateViewFromModel () {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emojiIdentifier(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.218941745, green: 0.6965057379, blue: 1, alpha: 1)
            }
        }
    }
    
    
    @IBAction func resetToucher(_ sender: UIButton) {
        touches = 0
    }
    
    @IBOutlet private var buttonCollection: [UIButton]!
    @IBOutlet private weak var touchLabel: UILabel! {
        didSet {
            updateTouches()
        }
    }
    @IBAction private func buttonAction(_ sender: UIButton) {
        touches += 1
        if let buttonIndex = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: buttonIndex)
            updateViewFromModel()
        }
        
    }
    
}

extension Int {
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
