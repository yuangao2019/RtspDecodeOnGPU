//
// Created by gaoyuan on 2021/1/7.
//

#pragma once
#include <cuda.h>
#include <opencv2/opencv.hpp>

void yuv420p2bgr32(CUdeviceptr yuv_buffer_in, cv::cuda::GpuMat& rgb_buffer_out, unsigned int pitch,
                   int height, int width, int32_t real_height, int32_t real_width);
