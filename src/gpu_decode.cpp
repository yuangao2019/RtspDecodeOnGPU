#include <stdio.h>

extern "C"
{
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
}
#include "VideoSource.h"
//#include "dynlink_nvcuvid.h"
#include <nvcuvid.h>

int main(int argc, const char* argv[])
{

    const char *rtsp;
    rtsp = argv[1];
    //rtsp = "http://hls01open.ys7.com/openlive/39cce778dd3c4a7aa2cf96c9df9040f3.m3u8";
    bool ret;

    VideoSource *videoDecoder = new VideoSource();

    //初始化解码器
    ret = videoDecoder->init(rtsp);

    //运行解码
    ret = videoDecoder->run(); 
    return 0;
    
}
