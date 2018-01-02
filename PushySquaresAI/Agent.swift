import RealmSwift

class Agent: Object {
    
    dynamic var wSelfLife = 0
    dynamic var wDiffLives = 0
    dynamic var wSquareThreshold = 0
    dynamic var wSelfSpreadBelowThreshold = 0
    dynamic var wSelfSpreadAboveThreshold = 0
    dynamic var wOpponentSpread = 0
    dynamic var wSelfInDanger = 0
    dynamic var wOpponentInDangerBelowThreshold = 0
    dynamic var wOpponentInDangerAboveThreshold = 0
}

extension Agent {
    static let standard: Agent = {
        let agent = Agent()
        agent.wSelfLife = 1000
        agent.wDiffLives = 10000
        agent.wSquareThreshold = 4
        agent.wSelfSpreadBelowThreshold = 100
        agent.wSelfSpreadAboveThreshold = 1
        agent.wOpponentSpread = 10
        agent.wSelfInDanger = 100
        agent.wOpponentInDangerBelowThreshold = 1
        agent.wOpponentInDangerAboveThreshold = 100
        return agent
    }()
    
    static func randomAgent() -> Agent {
        let agent = Agent()
        agent.wSelfLife = Int(arc4random_uniform(10000))
        agent.wDiffLives = Int(arc4random_uniform(10000))
        agent.wSquareThreshold = Int(arc4random_uniform(6))
        agent.wSelfSpreadBelowThreshold = Int(arc4random_uniform(10000))
        agent.wSelfSpreadAboveThreshold = Int(arc4random_uniform(10000))
        agent.wOpponentSpread = Int(arc4random_uniform(10000))
        agent.wSelfInDanger = Int(arc4random_uniform(10000))
        agent.wOpponentInDangerBelowThreshold = Int(arc4random_uniform(10000))
        agent.wOpponentInDangerAboveThreshold = Int(arc4random_uniform(10000))
        return agent
    }
    
    static func fromArray(_ arr: [Int]) -> Agent {
        let agent = Agent()
        agent.wSelfLife = arr[0]
        agent.wDiffLives = arr[1]
        agent.wSquareThreshold = arr[2]
        agent.wSelfSpreadBelowThreshold = arr[3]
        agent.wSelfSpreadAboveThreshold = arr[4]
        agent.wOpponentSpread = arr[5]
        agent.wSelfInDanger = arr[6]
        agent.wOpponentInDangerBelowThreshold = arr[7]
        agent.wOpponentInDangerAboveThreshold = arr[8]
        return agent
    }
}

extension GameAI {
    convenience init(game: Game, myColor: Color, agent a: Agent) {
        self.init(game: game, myColor: myColor, wSelfLife: a.wSelfLife, wDiffLives: a.wDiffLives, wSquareThreshold: a.wSquareThreshold, wSelfSpreadBelowThreshold: a.wSelfSpreadBelowThreshold, wSelfSpreadAboveThreshold: a.wSelfSpreadAboveThreshold, wOpponentSpread: a.wOpponentSpread, wSelfInDanger: a.wSelfInDanger, wOpponentInDangerBelowThreshold: a.wOpponentInDangerBelowThreshold, wOpponentInDangerAboveThreshold: a.wOpponentInDangerAboveThreshold)
    }
}
