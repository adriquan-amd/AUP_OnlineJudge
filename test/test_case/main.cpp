#include <hip/hip_runtime.h>
#include <iostream>
#include <vector>
#include <cmath>

#define MAX_N 100000

// HIP Kernel for vector addition
__global__ void vectorAdd(const float* A, const float* B, float* C, int numElements) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < numElements) {
        C[i] = A[i] + B[i];
    }
}

int main() {
    int N;
    while (std::cin >> N) {  
        // Allocate host memory using std::vector
        std::vector<float> h_A(N), h_B(N), h_C(N);

        // Read input values
        for (int i = 0; i < N; i++) std::cin >> h_A[i];
        for (int i = 0; i < N; i++) std::cin >> h_B[i];

        // Allocate device memory
        float *d_A = nullptr, *d_B = nullptr, *d_C = nullptr;
        hipMalloc(&d_A, N * sizeof(float));
        hipMalloc(&d_B, N * sizeof(float));
        hipMalloc(&d_C, N * sizeof(float));

        // Copy data from host to device
        hipMemcpy(d_A, h_A.data(), N * sizeof(float), hipMemcpyHostToDevice);
        hipMemcpy(d_B, h_B.data(), N * sizeof(float), hipMemcpyHostToDevice);

        // Launch HIP kernel
        int threadsPerBlock = 256;
        int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
        hipLaunchKernelGGL(vectorAdd, dim3(blocksPerGrid), dim3(threadsPerBlock), 0, 0, d_A, d_B, d_C, N);

        // Copy result back to host
        hipMemcpy(h_C.data(), d_C, N * sizeof(float), hipMemcpyDeviceToHost);

        // Print result
        for (int i = 0; i < N; i++) {
            std::cout << h_C[i] << " ";
        }
        std::cout << std::endl;

        // Free device memory
        hipFree(d_A);
        hipFree(d_B);
        hipFree(d_C);
    }

    return 0;
}


