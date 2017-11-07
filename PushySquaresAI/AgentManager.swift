import RealmSwift

class AgentManager {
    var availableAgents: [Agent]
    var breedableAgents: [Agent] = []
//    var realm: Realm
    var gamesPlayed = 0
    
    static let shared = AgentManager()
}
