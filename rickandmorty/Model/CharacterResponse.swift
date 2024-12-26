
import Foundation
struct CharacterResponse : Codable {
	let info : Info
	let results : [Character]?

	enum CodingKeys: String, CodingKey {

		case info = "info"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		info = try values.decode(Info.self, forKey: .info)
		results = try values.decodeIfPresent([Character].self, forKey: .results)
	}

}
