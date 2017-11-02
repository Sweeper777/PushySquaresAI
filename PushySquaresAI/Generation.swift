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
    
    let sorted = fitnesses.sorted { (a, b) -> Bool in
        return a.value > b.value
    }
    
    let top10 = sorted.prefix(through: 9)
    print("--------------")
    print("Top 10 Agents:")
    for agent in top10 {
        print("\(agent.value),\(agent.key.toArray().map { $0.description }.joined(separator: ","))")
    }
    print("--------------")
func select<T>(_ count: Int, from array: [T]) -> [T] {
    var firstFourFiths = Array(array.prefix(upTo: Int(Double(count) * 0.8)))
    let randomIndexRange = Int(Double(count) * 0.8)...(Int(Double(count) * 0.8) + (Int(Double(count) * 0.2) * 2))
    var randomItemsArray = Array(array[randomIndexRange])
    var randomItems = [T]()
    for _ in 0..<Int(Double(count) * 0.2) {
        randomItems.append(randomFromArrayAndRemove(&randomItemsArray))
    }
    firstFourFiths.append(contentsOf: randomItems)
    return firstFourFiths
}
}
