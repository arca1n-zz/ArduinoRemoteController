//
//  MessageDefinitions.h
//  JeepController
//
//  Created by Alok Rao on 12/22/16.
//  Copyright © 2016 Alok. All rights reserved.
//


#define COMMAND_ID_LIGHT 1


// LIGHT IDS

typedef enum : Byte {
    LINone,
    LIHeadlamp,
    LIBrakeLight,
    LIIndicators,
} LightID;

typedef enum : Byte {
    LightStateNone,
    LightStateOn,
    LightStateOff,
    LightStateFlicker
} LightState;

typedef struct {
    Byte commandID;
} JCMessage;

typedef struct {
    Byte command;
    Byte lightID;
    Byte state;
} JCLightMessage;

typedef struct {
    Byte command;
    Byte motorID;
    Byte direction;
    Byte speed;
} JCMotionMessage;
