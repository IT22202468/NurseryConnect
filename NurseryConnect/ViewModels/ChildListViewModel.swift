import Foundation
import Observation

@Observable
final class ChildListViewModel {
    var searchQuery: String = ""

    func filtered(_ children: [Child]) -> [Child] {
        guard !searchQuery.isEmpty else { return children }
        return children.filter {
            $0.fullName.localizedCaseInsensitiveContains(searchQuery)
        }
    }
}
