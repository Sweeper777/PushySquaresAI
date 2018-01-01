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
    
    func makeAgentsPlayGame(realm: Realm) {
        
        for agent in availableAgents {
            if agent.life <= 0 {
                if let index = availableAgents.index(of: agent) {
                    availableAgents.remove(at: index)
                }
                if let index = breedableAgents.index(of: agent) {
                    breedableAgents.remove(at: index)
                }
                try! realm.write {
                    realm.delete(agent)
                }
            }
        }
        
        while availableAgents.count >= 4 {
            availableAgents = availableAgents.filter { !$0.isInvalidated }
            
            let agentPlayers = [
                randomFromArrayAndRemove(&availableAgents),
                randomFromArrayAndRemove(&availableAgents),
                randomFromArrayAndRemove(&availableAgents),
                randomFromArrayAndRemove(&availableAgents),
                ]
            try! realm.write {
                for agent in agentPlayers {
                    agent.life -= 1
                    agent.repair()
                }
            }
            let game = AgentGame(agents: agentPlayers)
            
            game.run(doPrint: false, realm: realm)
        }
    }
    
}
