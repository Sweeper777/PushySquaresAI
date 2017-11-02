import RealmSwift

func runGeneration(previousFitness: Double?) -> Double {
    let realm = try! Realm()
    let allAgents = Array(realm.objects(Agent.self))
    var fitnesses = [Agent: Int]()
    for agent in allAgents {
        fitnesses[agent] = 0
    }
    
}
