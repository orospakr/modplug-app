//
//  modplug_extra_api.cpp
//  ModPlug
//
//  Created by Andrew Clunis on 2019-12-01.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

#include "modplug_extra_api.hpp"

#include "stdafx.h"
#include "sndfile.h"

struct _ModPlugFile
{
    CSoundFile mSoundFile;
};

unsigned int ModPlug_GetCurrentPos(ModPlugFile* file) {
    return file->mSoundFile.GetCurrentPos();
}

unsigned int ModPlug_GetMaxPosition(ModPlugFile* file) {
    return file->mSoundFile.GetMaxPosition();
}
