import RealmSwift

func runGeneration(previousFitness: Double?) -> Double {
    let realm = try! Realm()
    let allAgents = Array(realm.objects(Agent.self))
    var fitnesses = [Agent: Int]()
    for agent in allAgents {
        fitnesses[agent] = 0
    }
    
    var i = 1
    for agent in allAgents {
        for j in 0..<4 {
            var availableAgents = allAgents.filter({ $0 != agent })
            var agentPlayers = [
                randomFromArrayAndRemove(&availableAgents),
                randomFromArrayAndRemove(&availableAgents),
                randomFromArrayAndRemove(&availableAgents),
            ]
            agentPlayers.insert(agent, at: j)
            let game = AgentGame(agents: agentPlayers)
            print("game \(i) starts")
            game.run()
            print("game \(i) ended")
            fitnesses[agent]! += game.fitness[agent] ?? 0
            i += 1
        }
    }
}
