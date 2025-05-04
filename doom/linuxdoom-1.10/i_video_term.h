#ifndef __I_VIDEO_TERM_H__
#define __I_VIDEO_TERM_H__

#include "doomtype.h"

extern boolean terminalmode;

void I_InitGraphicsTerm(void);
void I_ShutdownGraphicsTerm(void);
void I_FinishUpdateTerm(void);
void I_SetPaletteTerm(byte* palette);

#endif