
extension Game {
    func createCopy() -> Game {
        return Game(game: self)
    }
    
    func player(_ color: Color) -> Player {
        return players.filter { $0.color == color }.first!
    }
    
    func opponents(to color: Color) -> [Color] {
        return players.filter { $0.color != color }.map { $0.color }
    }
    
    func moveInDirection(_ direction: Direction) {
        switch direction {
        case .up: moveUp()
        case .down: moveDown()
        case .left: moveLeft()
        case .right: moveRight()
        }
    }
}

extension Player {
    func createCopy() -> Player {
        return Player(turnsUntilNewSquare: self.turnsUntilNewSquare, lives: self.lives, color: self.color)
    }
}

class GameAI {
    var gameStates: [Game]
    var game: Game {
        return gameStates.last!
    }
    let wSelfLife: Int
//    let wOpponentLifeLoss: Int
    let wDiffLives: Int
    let wSquareThreshold: Int
    let wSelfSpreadBelowThreshold: Int
    let wSelfSpreadAboveThreshold: Int
    let wOpponentSpread: Int
    let wSelfInDanger: Int
    let wOpponentInDangerBelowThreshold: Int
    let wOpponentInDangerAboveThreshold: Int
//    var wBlockedSpawnPointCount: Int {
//        return game.player(myColor).lives * wSelfLife
//    }
    
    let myColor: Color
    
}
