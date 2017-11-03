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
    
    let toBeBred = select(15, from: sorted).map { $0.key }
    let toBeKilled = sorted.map { $0.key }.filter { !toBeBred.contains($0) }
    let currentFitness = Double(fitnesses.values.reduce(0, +)) / Double(fitnesses.values.count)
    try! realm.write {
        for agent in toBeKilled {
            realm.delete(agent)
        }
        print("Removed low fitness agents")
        var offsprings = [Agent]()
        for _ in 0..<toBeKilled.count {
            let father = toBeBred[Int(arc4random_uniform(UInt32(toBeBred.count)))]
            let mother = toBeBred[Int(arc4random_uniform(UInt32(toBeBred.count)))]
            let offspring = Agent.breed(agent1: father, agent2: mother)
            realm.add(offspring)
            offsprings.append(offspring)
        }
        let mutationRate: Int
        if previousFitness == nil {
            mutationRate = 4
        } else if abs(previousFitness! - currentFitness) > 10 && currentFitness > previousFitness! {
            mutationRate = 1
        } else {
            mutationRate = 4
        }
        for _ in 0..<mutationRate {
            let agent = randomFromArrayAndRemove(&offsprings)
            for _ in 0..<mutationRate {
                agent.mutate()
            }
        }
        print("Mutated 2% of the population")
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

extension Agent {
    func toArray() -> [Int] {
        return [
         wSelfLife,
         wDiffLives,
         wSquareThreshold,
         wSelfSpreadBelowThreshold,
         wSelfSpreadAboveThreshold,
         wOpponentSpread,
         wSelfInDanger,
         wOpponentInDangerBelowThreshold,
         wOpponentInDangerAboveThreshold,
        ]
    }
    
    func mutate() {
        func mutateProperty(_ property: inout Int) {
            property = Int(Double(property) * (arc4random_uniform(2) == 0 ? 1.1 : 0.9))
        }
        switch arc4random_uniform(8) {
        case 0:
            mutateProperty(&wDiffLives)
        case 1:
            mutateProperty(&wSelfLife)
        case 2:
            mutateProperty(&wSelfSpreadBelowThreshold)
        case 3:
            mutateProperty(&wSelfSpreadAboveThreshold)
        case 4:
            mutateProperty(&wOpponentSpread)
        case 5:
            mutateProperty(&wSelfInDanger)
        case 6:
            mutateProperty(&wOpponentInDangerBelowThreshold)
        case 7:
            mutateProperty(&wOpponentInDangerAboveThreshold)
        default: break
        }
    }
}
