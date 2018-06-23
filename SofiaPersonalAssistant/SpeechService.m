//
//  SpeechService.m
//  SofiaPersonalAssistant
//
//  Created by murganandam on 20/06/18.
//  Copyright © 2018 Muruganandam C. All rights reserved.
//

#import "SpeechService.h"

@implementation SpeechService
NSString *Keyval;
SpeechRecognitionMode *modevalue;
NSString *localevalue;

-(bool)useMicrophone {
    int index = 1;
    return index < 3;
}
-(bool)wantIntent {
    int index = 1;
    return index == 2 || index == 5;
}
-(SpeechRecognitionMode)mode {
    int index = 1;
    if (index == 1 || index == 4) {
        return SpeechRecognitionMode_LongDictation;
    }
    return SpeechRecognitionMode_ShortPhrase;
}



-(instancetype)key:(NSString*)keyvalue mode:(SpeechRecognitionMode)modeval  locale:(NSString*)locval delegate:(id <SpeechRecognitionProtocol>)protocol{
    Keyval = keyvalue;
    modevalue = &modeval;
    localevalue = locval;
    self->SpeechRecoginitionDelegate = protocol;
    return self;
}
-(void)startspeechservice{
    [self logRecognitionStart];
    
    if (self.useMicrophone) {
        if (micClient == nil) {
            if (!self.wantIntent)
            {
                
                micClient = [SpeechRecognitionServiceFactory createMicrophoneClient:(self.mode)
                                                                       withLanguage:(localevalue)
                                                                            withKey:(Keyval)
                                                                       withProtocol:(self->SpeechRecoginitionDelegate)];
            }
            
        }
        
        OSStatus status = [micClient startMicAndRecognition];
        if (status)
        {
            [micClient endMicAndRecognition];
            
        }
}
}
-(void)logRecognitionStart
{
    NSString* recoSource;
    if (self.useMicrophone)
    {
        recoSource = @"microphone";
    }
    else if (self.mode == SpeechRecognitionMode_ShortPhrase)
    {
        recoSource = @"short wav file";
    }
    else
    {
        recoSource = @"long wav file";
    }
    
    
}
-(void)onError:(NSString*)errorMessage withErrorCode:(int)errorCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *errorval = ConvertSpeechErrorToString(errorCode);
        
        [self->micClient endMicAndRecognition];
        [self->SpeechRecoginitionDelegate onError:errorval withErrorCode:errorCode];
    });
}

- (void)onFinalResponseReceived:(RecognitionResult *)response {
    
    bool isFinalDicationMessage = self.mode == SpeechRecognitionMode_LongDictation &&
    (response.RecognitionStatus == RecognitionStatus_EndOfDictation ||
     response.RecognitionStatus == RecognitionStatus_DictationEndSilenceTimeout);
    if (nil != micClient && self.useMicrophone && ((self.mode == SpeechRecognitionMode_ShortPhrase) || isFinalDicationMessage)) {
        // we got the final result, so it we can end the mic reco.  No need to do this
        // for dataReco, since we already called endAudio on it as soon as we were done
        // sending all the data.
        [micClient endMicAndRecognition];
    }
    
    if ((self.mode == SpeechRecognitionMode_ShortPhrase) || isFinalDicationMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
    if (!isFinalDicationMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->SpeechRecoginitionDelegate onFinalResponseReceived:response];
        });
    }
}
NSString* ConvertSpeechErrorToString(int errorCode) {
    switch ((SpeechClientStatus)errorCode)
    {
        case SpeechClientStatus_SecurityFailed:         return
            @"SpeechClientStatus_SecurityFailed";
        case SpeechClientStatus_LoginFailed:            return
            @"SpeechClientStatus_LoginFailed";
        case SpeechClientStatus_Timeout:                return
            @"SpeechClientStatus_Timeout";
        case SpeechClientStatus_ConnectionFailed:       return
            @"SpeechClientStatus_ConnectionFailed";
        case SpeechClientStatus_NameNotFound:           return
            @"SpeechClientStatus_NameNotFound";
        case SpeechClientStatus_InvalidService:         return
            @"SpeechClientStatus_InvalidService";
        case SpeechClientStatus_InvalidProxy:           return
            @"SpeechClientStatus_InvalidProxy";
        case SpeechClientStatus_BadResponse:            return
            @"SpeechClientStatus_BadResponse";
        case SpeechClientStatus_InternalError:          return
            @"SpeechClientStatus_InternalError";
        case SpeechClientStatus_AuthenticationError:    return
            @"SpeechClientStatus_AuthenticationError";
        case SpeechClientStatus_AuthenticationExpired:  return
            @"SpeechClientStatus_AuthenticationExpired";
        case SpeechClientStatus_LimitsExceeded:         return
            @"SpeechClientStatus_LimitsExceeded";
        case SpeechClientStatus_AudioOutputFailed:      return
            @"SpeechClientStatus_AudioOutputFailed";
        case SpeechClientStatus_MicrophoneInUse:        return
            @"SpeechClientStatus_MicrophoneInUse";
        case SpeechClientStatus_MicrophoneUnavailable:  return
            @"SpeechClientStatus_MicrophoneUnavailable";
        case SpeechClientStatus_MicrophoneStatusUnknown:return
            @"SpeechClientStatus_MicrophoneStatusUnknown";
        case SpeechClientStatus_InvalidArgument:        return
            @"SpeechClientStatus_InvalidArgument";
    }
    return [[NSString alloc] initWithFormat:@"Unknown error: %d\n", errorCode];
}


NSString* ConvertSpeechRecoConfidenceEnumToString(Confidence confidence)
{
    switch (confidence)
    {
        case SpeechRecoConfidence_None:
            return @"None";
        case SpeechRecoConfidence_Low:
            return @"Low";
        case SpeechRecoConfidence_Normal:
            return @"Normal";
        case SpeechRecoConfidence_High:
            return @"High";
    }
}

-(void)onMicrophoneStatus:(Boolean)recording {
    if (!recording)
    {
        [micClient endMicAndRecognition];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!recording)
        {
            
        }
        
    });
}


- (void)onPartialResponseReceived:(NSString *)partialResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->SpeechRecoginitionDelegate onPartialResponseReceived:partialResult];
        
    });
}

@end
