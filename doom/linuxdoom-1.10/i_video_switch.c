#include "doomdef.h"
#include "m_argv.h"
#include "i_video.h"
#include "i_video_term.h"

boolean terminalmode = false;

void I_InitVideo(void)
{
    terminalmode = M_CheckParm("-terminal");
    
    if (terminalmode) {
        I_InitGraphicsTerm();
    } else {
        I_InitGraphics();
    }
}

void I_FinishUpdateVideo(void)
{
    if (terminalmode) {
        I_FinishUpdateTerm();
    } else {
        I_FinishUpdate();
    }
}

void I_ShutdownVideo(void)
{
    if (terminalmode) {
        I_ShutdownGraphicsTerm();
    } else {
        I_ShutdownGraphics();
    }
}

void I_SetVideoPalette(byte* palette)
{
    if (terminalmode) {
        I_SetPaletteTerm(palette);
    } else {
        I_SetPalette(palette);
    }
}