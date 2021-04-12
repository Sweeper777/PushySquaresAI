import RealmSwift

extension Map {
    init?(name: String) {
        guard let url = URL(string: "file:///Users/mulangsu/Documents/PushySquaresAI/PushySquaresAI")?
                .appendingPathComponent(name).appendingPathExtension("map") else {
            return nil
        }
        self.init(file: url)
    }
}

let dispatchQueue = DispatchQueue(label: "agentQueue", qos: .userInitiated, attributes: .concurrent)

func runGeneration(previousFitness: Double?, mentors: [Agent]) -> Double {
    let realm = try! Realm()
    let allAgents = Array(realm.objects(Agent.self))
    let agentCopies = allAgents.map { ($0.createCopy(), $0) }
    let copiesDictionary = Dictionary(uniqueKeysWithValues: agentCopies)
    var fitnesses = [Agent: Int]()
    let maps = ["standard": Map(name: "standard")!,
//                "zigzag": Map(name: "zigzag")!,
//                "grey2": Map(name: "grey2")!,
//                "grey1": Map(name: "grey1")!,
//                "quick": Map(name: "quick")!,
                ]
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    dispatchQueue.async {
        DispatchQueue.concurrentPerform(iterations: agentCopies.count) { i in
            let agent = agentCopies[i].0
            var agentPlayers = mentors
            agentPlayers.insert(agent, at: Int.random(in: 0..<agentPlayers.count+1))
            let (mapName, map) = maps.randomElement()!
            let game = AgentGame(agents: agentPlayers, map: map)
            print("game \(i) starts, Map: \(mapName)")
            game.run()
            print("game \(i) ended")
            let fitnessGained = game.fitness[agent] ?? 0
            fitnesses[copiesDictionary[agent]!] = fitnessGained
        }
        dispatchGroup.leave()
    }

    dispatchGroup.wait()

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
    let currentFitness = Double(sorted.map(\.value)[sorted.count / 2])
    try! realm.write {
        for agent in toBeKilled {
            realm.delete(agent)
        }
        print("Removed low fitness agents")
        var offsprings = [Agent]()
        for _ in 0..<toBeKilled.count {
            let father = toBeBred.randomElement()!
            let mother = toBeBred.randomElement()!
            let offspring = Agent.breed(agent1: father, agent2: mother)
            realm.add(offspring)
            offsprings.append(offspring)
        }
        let mutationRate: Int
        if previousFitness == nil {
            mutationRate = toBeKilled.count
        } else if abs(previousFitness! - currentFitness) > 10 && currentFitness > previousFitness!{
            mutationRate = 10
        } else {
            mutationRate = toBeKilled.count
        }
        for _ in 0..<mutationRate {
            let agent = randomFromArrayAndRemove(&offsprings)
            for _ in 0..<mutationRate {
                agent.mutate()
            }
        }
        print("Mutated \(mutationRate) agents")
    }
    print("Average Fitness: \(currentFitness)")
    return currentFitness
}

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
        [
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
            property = Int(Double(property) * (Bool.random() ? 1.1 : 0.9))
        }
        for _ in 0..<8 {
            switch Int.random(in: 0..<8) {
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
}
