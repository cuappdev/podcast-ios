/* hidden Keys.plist for sensitive information */
enum Keys: String {
    case apiURL = "api-url"
    case privacyPolicyURL = "privacypolicy-url"
    case fabricAPIKey = "fabric-api-key"
    case githubURL = "github-url"
    case appDevURL = "appdev-url"
    case reportFeedbackURL = "reportfeedback-url"
    case facebookAppID = "facebook-app-id"

    var value: String {
        return Keys.keyDict[rawValue] as! String
    }

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}
