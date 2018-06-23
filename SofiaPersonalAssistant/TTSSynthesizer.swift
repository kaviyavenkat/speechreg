
import Foundation

class TTSSynthesizer {
    
    enum TTSAudioOutputFormat: String {
        case raw8Khz8BitMonoMULaw = "raw-8khz-8bit-mono-mulaw"
        case raw16Khz16BitMonoPcm = "raw-16khz-16bit-mono-pcm"
        case riff8Khz8BitMonoMULaw = "riff-8khz-8bit-mono-mulaw"
        case riff16Khz16BitMonoPcm = "riff-16khz-16bit-mono-pcm"
    }
    
    enum TTSGender: String
    {
        case female = "Female"
        case male = "Male"

        func getVoiceName(forLacale locale: String = "en-IN") -> String
        {
            switch self
            {
                    case .female:
                    switch locale
                    {
                        case "zh-cn":
                            return "Microsoft Server Speech Text to Speech Voice (zh-CN, HuihuiRUS)"
                        case "es-es":
                            return "Microsoft Server Speech Text to Speech Voice (es-ES, Laura, Apollo)"
                        case "fr-fr":
                            return "Microsoft Server Speech Text to Speech Voice (fr-FR, Julie, Apollo)"
                        case "de-de":
                            return "Microsoft Server Speech Text to Speech Voice (de-DE, Hedda)"
                        case "en-au":
                            return "Microsoft Server Speech Text to Speech Voice (en-AU, Catherine)"
                        case "en-ca":
                            return "Microsoft Server Speech Text to Speech Voice (en-CA, Linda)"
                        case "en-gb":
                            return "Microsoft Server Speech Text to Speech Voice (en-GB, Susan, Apollo)"
                        default:
                            return "Microsoft Server Speech Text to Speech Voice (en-US, ZiraRUS)"
                    }
                    default:
                    switch locale
                    {
                        case "zh-cn":
                            return "Microsoft Server Speech Text to Speech Voice (zh-CN, Kangkang, Apollo)"
                        case "it-it":
                            return "Microsoft Server Speech Text to Speech Voice (it-IT, Cosimo, Apollo)"
                        case "es-es":
                            return "Microsoft Server Speech Text to Speech Voice (es-ES, Pablo, Apollo)"
                        case "fr-fr":
                            return "Microsoft Server Speech Text to Speech Voice (fr-FR, Paul, Apollo)"
                        case "de-de":
                            return "Microsoft Server Speech Text to Speech Voice (de-DE, Stefan, Apollo)"
                        case "en-in":
                            return "Microsoft Server Speech Text to Speech Voice (en-IN, Ravi, Apollo)"
                        case "en-gb":
                            return "Microsoft Server Speech Text to Speech Voice (en-GB, George, Apollo)"
                        default:
                            return "Microsoft Server Speech Text to Speech Voice (en-US, BenjaminRUS)"
                    }
            }
        }
    }
    
    private static let ttsServiceUri = "https://speech.platform.bing.com/synthesize"
    
    // Note: The way to get api key:
    // Free: https://www.microsoft.com/cognitive-services/en-us/subscriptions?productId=/products/Bing.Speech.Preview
    // Paid: https://portal.azure.com/#create/Microsoft.CognitiveServices/apitype/Bing.Speech/pricingtier/S0
    
    private static var apiKey = "1f653bce6d0d4f7eab0e1b3886cc56d2"
    
    private let authentication = TTSAuthentication(apiKey: TTSSynthesizer.apiKey)

    func synthesize(text: String,
                    outputFormat: TTSAudioOutputFormat = .riff16Khz16BitMonoPcm,
                    appId: String = "",
                    clientId: String = "",
                    lang: String = "en-IN",
                    gender: TTSGender = .female,
                    callback: @escaping (Data) -> ()) {
            self.authentication.getAccessToken { (accessToken: String) in
            let message = "<speak version='1.0' xml:lang='\(lang)'><voice xml:lang='\(lang)' xml:gender='\(gender.rawValue)' name='\(gender.getVoiceName(forLacale: lang))'>\(text)</voice></speak>"
            let encoding = String.Encoding.utf8
            TTSHttpRequest.submit(withUrl: TTSSynthesizer.ttsServiceUri,
                                  andHeaders: [
                                    "Content-Type": "application/ssml+xml",
                                    "X-Microsoft-OutputFormat": outputFormat.rawValue,
                                    "Authorization": "Bearer " + accessToken,
                                    "X-Search-AppId": appId,
                                    "X-Search-ClientID": clientId,
                                    "User-Agent": "TTSiOS",
                                    "Accept": "*/*",
                                    "content-length": "\(message.lengthOfBytes(using: encoding))"
                ],andBody: message.data(using: encoding)) { (c: TTSHttpRequest.Callback) in
                                    guard let data = c.data else { return }
                                    callback(data)
            }
        
        }
    }
    
}
