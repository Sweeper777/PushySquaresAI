
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
    
    init(game: Game, myColor: Color, wSelfLife: Int, /*wOpponentLifeLoss: Int,*/ wDiffLives: Int, wSquareThreshold: Int, wSelfSpreadBelowThreshold: Int, wSelfSpreadAboveThreshold: Int, wOpponentSpread: Int, wSelfInDanger: Int, wOpponentInDangerBelowThreshold: Int, wOpponentInDangerAboveThreshold: Int) {
        self.gameStates = [game]
        self.myColor = myColor
        self.wSelfLife = wSelfLife
//        self.wOpponentLifeLoss = wOpponentLifeLoss
        self.wDiffLives = wDiffLives
        self.wSquareThreshold = wSquareThreshold
        self.wSelfSpreadBelowThreshold = wSelfSpreadBelowThreshold
        self.wSelfSpreadAboveThreshold = wSelfSpreadAboveThreshold
        self.wOpponentSpread = wOpponentSpread
        self.wSelfInDanger = wSelfInDanger
        self.wOpponentInDangerBelowThreshold = wOpponentInDangerBelowThreshold
        self.wOpponentInDangerAboveThreshold = wOpponentInDangerAboveThreshold
    }
    
    func evaluateHeuristics() -> Int {
        let livingPlayers = game.players.filter({ $0.lives > 0 })
        let me = game.player(myColor)
        if me.lives == 0 {
            return Int.min
        }
        if livingPlayers.count == 1 && me.lives > 0 {
            return Int.max
        }
        if livingPlayers.count == 0 {
            return 0
        }
//        let finalSelfLifeLoss = -lifeLosses[myColor]!
        let finalSelfLives = me.lives
        let opponents = game.opponents(to: myColor)
        let finalDiffLives: Int
//        let finalOpponentLifeLoss: Int
        if livingPlayers.count == 2 {
            finalDiffLives = me.lives - game.player(opponents[0]).lives
//            finalOpponentLifeLoss = 0
        } else {
//            finalOpponentLifeLoss = opponents.map { lifeLosses[$0]! }.reduce(0, +)
            finalDiffLives = 0
        }
        let mySquares = game.board.indicesOf(color: myColor)
        let finalSelfSpread = -spread(of: mySquares, pivot: game.spawnpoints[myColor]!)
        let finalOpponentSpread = opponents.map { self.spread(of: self.game.board.indicesOf(color: $0), pivot: self.game.spawnpoints[$0]!) }.reduce(0, +) / opponents.count
        let selfInDanger = mySquares.map { self.isInDanger(position: $0, directionsOfEdge: self.isEdge(position: $0), myColor: myColor) }.filter{ $0 }.count
        if selfInDanger >= me.lives {
            return Int.min
        }
        let finalSelfInDanger = -selfInDanger
        var opponentInDanger = 0
        for opponent in opponents {
            opponentInDanger += game.board.indicesOf(color: opponent).map { self.isInDanger(position: $0, directionsOfEdge: self.isEdge(position: $0), myColor: opponent) }.filter{ $0 }.count
        }
        let finalOpponentInDanger = opponentInDanger
//        let spawnpoints = opponents.map { self.game.board[self.game.spawnpoints[$0]!] }
//        var count = 0
//        for point in spawnpoints {
//            if case .empty = point {} else {
//                count = 1
//                break
//            }
//        }
//        let finalBlockedSpawnPointCount = -count
        return finalSelfLives * wSelfLife +
            finalDiffLives * wDiffLives +
//            finalOpponentLifeLoss * wOpponentLifeLoss +
//            finalBlockedSpawnPointCount * wBlockedSpawnPointCount +
            finalSelfSpread * (mySquares.count < wSquareThreshold ? wSelfSpreadBelowThreshold : wSelfSpreadAboveThreshold) +
            finalOpponentSpread * wOpponentSpread +
            finalSelfInDanger * wSelfInDanger +
        finalOpponentInDanger * (mySquares.count < wSquareThreshold ? wOpponentInDangerBelowThreshold : wOpponentInDangerAboveThreshold)
    }
    
    private func spread(of positions: [Position], pivot: Position) -> Int {
        if let maxX = positions.map({ abs($0.x - pivot.x) }).max(), let maxY = positions.map({ abs($0.y - pivot.y) }).max() {
            return max(maxX, maxY)
        }
        return 0
    }
    
    private func isEdge(position: Position) -> [Direction] {
        var directions = [Direction]()
        if case .void = game.board[position.above()] {
            directions.append(.up)
        }
        if case .void = game.board[position.below()] {
            directions.append(.down)
        }
        if case .void = game.board[position.left()] {
            directions.append(.left)
        }
        if case .void = game.board[position.right()] {
            directions.append(.right)
        }
        return directions
    }
    
}
