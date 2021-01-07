#include "CudaFunction.h"

__global__ void
yuv420p2bgr32_kernel(CUdeviceptr yuv_buffer_in, cv::cuda::PtrStepSz<uchar3> rgb_buffer_out, unsigned int pitch,
                     int height, int width, int32_t real_height, int32_t real_width) {
	unsigned char* yuv_buffer = (unsigned char*) yuv_buffer_in;

	int           channels = 3;
	int           index_Y;
	int           index_U;
	int           index_V;
	unsigned char Y;
	unsigned char U;
	unsigned char V;

	const int x = blockIdx.x * blockDim.x + threadIdx.x;
	const int y = blockIdx.y * blockDim.y + threadIdx.y;
	index_Y = y * pitch + x;
	Y       = yuv_buffer[index_Y];

	if (x % 2 == 0) {
		index_U = (height + y / 2) * pitch + x;
		index_V = (height + y / 2) * pitch + x + 1;
		U       = yuv_buffer[index_U];
		V       = yuv_buffer[index_V];
	} else if (x % 2 == 1) {
		index_V = (height + y / 2) * pitch + x;
		index_U = (height + y / 2) * pitch + x - 1;
		U       = yuv_buffer[index_U];
		V       = yuv_buffer[index_V];
	}

	// YCbCr420
	int R = Y + 1.402 * (V - 128);
	int G = Y - 0.34413 * (U - 128) - 0.71414 * (V - 128);
	int B = Y + 1.772 * (U - 128);


	// 确保取值范围在 0 - 255 中
	R = (R < 0) ? 0 : R;
	G = (G < 0) ? 0 : G;
	B = (B < 0) ? 0 : B;
	R = (R > 255) ? 255 : R;
	G = (G > 255) ? 255 : G;
	B = (B > 255) ? 255 : B;

	if (x < real_width && y < real_height) {
		rgb_buffer_out(y, x) = {(unsigned char) B, (unsigned char) G, (unsigned char) R};
	}
}

void yuv420p2bgr32(CUdeviceptr yuv_buffer_in, cv::cuda::GpuMat& rgb_buffer_out, unsigned int pitch,
                   int height, int width, int32_t real_height, int32_t real_width){
//	dim3 gridSize((width + 16 - 1) / 16, (height + 16 - 1) / 16);
	dim3 gridSize((real_width + 16 - 1) / 16, (real_height + 16 - 1) / 16);
	dim3 blockSize(16, 16);
	yuv420p2bgr32_kernel<<< gridSize, blockSize >>>(yuv_buffer_in, rgb_buffer_out, pitch, height, width, real_height, real_width);
	cudaDeviceSynchronize();
}