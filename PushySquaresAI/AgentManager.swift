import RealmSwift

class AgentManager {
    var availableAgents: [Agent]
    var breedableAgents: [Agent] = []
//    var realm: Realm
    var gamesPlayed = 0
    
    static let shared = AgentManager()
    
    private init() {
        let realm = try! Realm()
        availableAgents = Array(realm.objects(Agent.self))
    }
    
}
