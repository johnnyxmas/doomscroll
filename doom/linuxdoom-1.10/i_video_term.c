#include "doomdef.h"
#include "doomstat.h"
#include "i_system.h"
#include "v_video.h"
#include "m_argv.h"
#include "z_zone.h"

// ASCII characters ordered by brightness
static const char* ascii_chars = " .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$";
static int palette_to_gray[256];

void I_InitGraphicsTerm(void)
{
    // Initialize grayscale mapping from palette
    for (int i = 0; i < 256; i++) {
        // Simple luminance calculation (R*0.3 + G*0.59 + B*0.11)
        palette_to_gray[i] = (i * 30 + i * 59 + i * 11) / 100;
    }
}

void I_ShutdownGraphicsTerm(void)
{
    // Nothing to clean up in terminal mode
}

void I_FinishUpdateTerm(void)
{
    static int lasttic = 0;
    static char term_buf[SCREENWIDTH * SCREENHEIGHT + SCREENHEIGHT];
    char *bufptr = term_buf;
    byte* src = screens[0];

    // Handle devparm dots (debug timing)
    if (devparm) {
        int tics = I_GetTime() - lasttic;
        lasttic = I_GetTime();
        tics = tics > 20 ? 20 : tics;
        
        int i;
        for (i=0; i<tics*2; i++)
            fprintf(stderr, ".");
        for (; i<20*2; i++)
            fprintf(stderr, " ");
        fprintf(stderr, "\r");
    }

    // Convert screen buffer to ASCII
    for (int y = 0; y < SCREENHEIGHT; y += 2) {
        for (int x = 0; x < SCREENWIDTH; x++) {
            byte pal_idx = src[y * SCREENWIDTH + x];
            int brightness = palette_to_gray[pal_idx] * (strlen(ascii_chars)-1) / 255;
            *bufptr++ = ascii_chars[brightness];
        }
        *bufptr++ = '\n';
    }
    *bufptr = '\0';

    // Output frame
    fputs("\033[2J\033[H", stdout); // Clear screen and home cursor
    fputs(term_buf, stdout);
    fflush(stdout);
}

void I_SetPaletteTerm(byte* palette)
{
    // Update grayscale mapping when palette changes
    for (int i = 0; i < 256; i++) {
        byte r = palette[i*3];
        byte g = palette[i*3+1];
        byte b = palette[i*3+2];
        palette_to_gray[i] = (r * 30 + g * 59 + b * 11) / 100;
    }
}