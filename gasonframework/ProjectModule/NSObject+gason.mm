//
//  NSObject+gason.m
//  gasonframework
//
//  Created by Benjamin on 26/11/2017.
//  Copyright © 2017 Benjamin. All rights reserved.
//

#import "NSObject+gason.h"
#import "gason.h"

const int SHIFT_WIDTH = 4;

@interface gason ()
@property(nonatomic, assign) JsonValue jsonValue;
@property(nonatomic, assign) JsonAllocator *jsonAllocator;
@property(nonatomic, assign) JsonIterator iterator;
@property(nonatomic, assign) NSString *key;
@property(nonatomic, assign) char* s;
@property(nonatomic, assign) char* endptr;
@end

@implementation gason

- (nonnull instancetype) initWithData:(nonnull NSData *)data{
    self = [super init];
    if (self) {
        _endptr = new char;
        _jsonValue = JsonValue();
        _jsonAllocator = new JsonAllocator;
        if (data.length == 0){
            _parseStatus = JSON_BAD_STRING;
            _s = nil;
            return self;
        }
        char *tmp = strdup((char *) data.bytes);
        size_t l = strlen(tmp);
        size_t ll = l + 1;
        if (l > 0){
            char last = tmp[l - 1];
            if (last == '\0'){
                --ll;
            }
        }
        _s = (char *) malloc(sizeof(char)*(ll));
        memset(_s, 0x00, sizeof(char)*(ll));
        memcpy(_s, tmp, sizeof(char)*l);
        free(tmp);

        _parseStatus = jsonParse(_s, &_endptr, &_jsonValue, *_jsonAllocator);
        switch (_jsonValue.getTag()) {
            case JSON_ARRAY:
            case JSON_OBJECT:{
                JsonValue o = _jsonValue;
                _iterator = begin(o);
                break;
            }
            default:
                break;
        }

        return self;
    }
    return self;
}

- (nonnull instancetype) initWithJSON:(nonnull NSString *)json{
    self = [super init];
    if (self){
        if (json.UTF8String == nil){
            _endptr = nil;
            _s = nil;
            _parseStatus = JSON_NULL;
        }else{
            _s = (char *) json.UTF8String;
            _endptr = new char;
            _jsonValue = JsonValue();
            _jsonAllocator = new JsonAllocator;
            _parseStatus = jsonParse(_s, &_endptr, &_jsonValue, *_jsonAllocator);
            if (_parseStatus == JSON_OK) {
                switch (_jsonValue.getTag()) {
                    case JSON_OBJECT:
                    case JSON_ARRAY:{
                        JsonValue o = _jsonValue;
                        _iterator = begin(o);
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    return self;
}

- (void) dealloc{    
    delete _jsonAllocator;
    if(_s) {
        free(_s);
    }
}

- (nonnull instancetype) initWithJsonValue:(JsonValue) v{
    self = [super init];
    if (self){
        _jsonValue = v;
        _parseStatus = JSON_OK;
        _s = nil;
        _endptr = nil;
        switch (_jsonValue.getTag()) {
            case JSON_OBJECT:
            case JSON_ARRAY:{
                JsonValue o = _jsonValue;
                _iterator =  begin(o);
                break;
            }
            default:
                break;
        }
    }
    return self;
}

-(nullable NSNumber *) length{
    switch (_jsonValue.getTag()) {
        case JSON_ARRAY:
        case JSON_OBJECT:{
            uint cnt = 0;
            JsonIterator it = begin(_jsonValue);
            JsonIterator et = end(_jsonValue);
            while (it != et) {
                cnt++;
                it++;
            }
            return [NSNumber numberWithUnsignedInt:cnt];
        }
        default:{
            break;
        }
            
    }
    return nil;
}

-(nullable gason *) objectAtIndexedSubscript:(NSUInteger)index {
    switch (_jsonValue.getTag()) {
        case JSON_ARRAY:{
            uint ind = (uint) index;
            uint cnt = 0;
            JsonValue o = _jsonValue;
            JsonIterator it = begin(o);
            JsonIterator et = end(o);
            do {
                if (cnt == ind){
                    JsonValue oo = it->value;
                    gason *g = [[gason alloc] initWithJsonValue:oo];
                    return g;
                }
                it++;
                cnt++;
            } while (it != et || it.p || cnt > ind);
            break;
        }
        default:{
            break;
        }
    }
    return nil;
}

-(nullable gason *) objectForKeyedSubscript:(nonnull NSString *)key{
    switch (_jsonValue.getTag()){
        case JSON_OBJECT:{
            JsonValue o = _jsonValue;
            JsonIterator it = begin(o);
            JsonIterator et = end(o);
            do {
                const char *k = it->key;
                if (k){
                    NSString *s = [NSString stringWithCString:k encoding:NSUTF8StringEncoding];
                    if ([s isEqualToString:key]){
                        JsonValue oo = it->value;
                        return [[gason alloc] initWithJsonValue:oo];
                    }
                }
                it++;
            } while (it != et || it.p);
            break;
        }
        default:{
            break;
        }
    }
    return nil;
}

-(nullable gason*) next{
    switch (_jsonValue.getTag()) {
        case JSON_ARRAY:
            if (_iterator.isValid()){
                gason *g = [[gason alloc] initWithJsonValue:_iterator->value];
                _iterator++;
                return g;
            }
            break;
        case JSON_OBJECT:
            if (_iterator.isValid()){
                gason *g = [[gason alloc] initWithJsonValue:JsonValue(JSON_OBJECT, _iterator.p)];
                char *s = _iterator->key;
                if (s){
                    g.key = [NSString stringWithUTF8String:s];
                }
                _iterator++;
                return g;
            }
            break;
        default:
            break;
    }
    return nil;
}

-(nullable NSNumber*) toBool{
    switch (_jsonValue.getTag()) {
        case JSON_TRUE:{
            return [NSNumber numberWithBool:YES];
        }
        case JSON_FALSE:{
            return [NSNumber numberWithBool:NO];
        }
        default:{
            break;
        }
    }
    return nil;
}


-(nullable NSNumber*) toNumber{
    switch (_jsonValue.getTag()) {
        case JSON_NUMBER:{
            return [NSNumber numberWithDouble:_jsonValue.toNumber()];
        }
        default:{
            break;
        }
    }
    return nil;
}

-(nullable NSString *) toString{
    switch (_jsonValue.getTag()){
        case JSON_STRING: {
            char *s = _jsonValue.toString();
            if (s == 0){
                return nil;
            }
            return [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
        }
        default:{
            break;
        }
    }
    return nil;
}

-(nullable NSString *) getKey{
    return _key;
}

-(nonnull NSString *) dumpValue:(int) indent {
    JsonValue o = _jsonValue;
    NSMutableString *ms = [[NSMutableString alloc] init];
    switch (o.getTag()) {
        case JSON_NUMBER:
            [ms appendString:[NSString stringWithFormat:@"%f",o.toNumber()]];
            break;
        case JSON_STRING:
            [ms appendString:[self dumpString:o.toString()]];
            break;
        case JSON_ARRAY:
            if (!o.toNode()){
                [ms appendString:@"[]"];
                break;
            }
            [ms appendString:@"[\n"];
            for (auto i: o){
                gason *g = [[gason alloc] initWithJsonValue:i->value];
                [ms appendString:[@" " stringByPaddingToLength:indent + SHIFT_WIDTH withString:@" " startingAtIndex:0]];
                [ms appendString:[g dumpValue:indent + SHIFT_WIDTH]];
                [ms appendString:i->next ? @",\n" : @"\n"];
            }
            [ms appendString:[@" " stringByPaddingToLength:indent withString:@" " startingAtIndex:0]];
            [ms appendString:@"]"];
            break;
        case JSON_OBJECT:
            if (!o.toNode()){
                [ms appendString:@"{}"];
                break;
            }
            [ms appendString:@"{\n"];
            for (auto i: o) {
                if (i->key){
                    [ms appendString:[@" " stringByPaddingToLength:indent + SHIFT_WIDTH withString:@" " startingAtIndex:0]];
                    char *k = i->key;
                    if (k) {
                        NSString *key = [NSString stringWithCString:k encoding:NSUTF8StringEncoding];
                        if (key == nil){
                            key = @"";
                        }
                        [ms appendString:key];
                    }else{
                        [ms appendString:@""];
                    }
                    [ms appendString:@": "];
                }
                gason *g = [[gason alloc] initWithJsonValue:i->value];
                [ms appendString:[g dumpValue:indent + SHIFT_WIDTH]];
                [ms appendString:i->next ? @",\n" : @"\n"];
            }
            [ms appendString:[@" " stringByPaddingToLength:indent withString:@" " startingAtIndex:0]];
            [ms appendString:@"}"];            
            break;
        case JSON_NULL:
            [ms appendString:@"null"];
            break;
        case JSON_TRUE:
            [ms appendString:@"true"];
            break;
        case JSON_FALSE:
            [ms appendString:@"false"];
            break;
    }
    return (NSString *) ms;
}

-(nonnull NSString *) dumpString:(const char *) s{
    if (s == nil || s == 0){
        return @"";
    }
    NSString *tmp = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    if (tmp == nil){
        return @"";
    }
    NSMutableString *ms = [[NSMutableString alloc] initWithString:tmp];
    [ms replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
//    [ms replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
//    [ms replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
    [ms replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
    [ms replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
    [ms replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
    [ms replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
    [ms replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ms length])];
    return [NSString stringWithFormat:@"\"%@\"",ms];
}


@end

