protocol DatabaseService {
    func findAll() -> Array<RunEntity>
    func save(_ object: RunEntity)
    func update(_ object: RunEntity)
    func delete(_ object: RunEntity)
    func deleteAll()
    func checkIfExists(_ object: RunEntity) -> Bool
}
