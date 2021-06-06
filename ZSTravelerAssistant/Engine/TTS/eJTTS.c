//
//  eJTTS.c
//  singleView
//
//  Created by shanxin he on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
int jt_Fseek(FILE *stream, long offset, int origin)
{	
	return fseek(stream, offset, origin);
}

size_t jt_Fread(void *buffer, size_t size, size_t count, FILE *stream)
{
	return fread(buffer, size, count, stream);
}

FILE *jt_Fopen(const char *filename, const char *mode)
{
	return fopen(filename, mode);
}

int jt_Fclose(FILE *stream)
{
	return fclose(stream);
}