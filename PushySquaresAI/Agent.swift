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
    
}
