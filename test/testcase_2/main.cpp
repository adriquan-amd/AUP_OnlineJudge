#include <hip/hip_runtime.h>
#include <iostream>

// HIP Kernel for integer addition
__global__ void addKernel(int* d_a, int* d_b, int* d_c) {
    *d_c = *d_a + *d_b;
}

int main() {
    int a, b;
    
    // Read two integers from standard input
    std::cin >> a >> b;

    // Allocate device memory
    int *d_a, *d_b, *d_c;
    hipMalloc(&d_a, sizeof(int));
    hipMalloc(&d_b, sizeof(int));
    hipMalloc(&d_c, sizeof(int));

    // Copy input values to device
    hipMemcpy(d_a, &a, sizeof(int), hipMemcpyHostToDevice);
    hipMemcpy(d_b, &b, sizeof(int), hipMemcpyHostToDevice);

    // Launch kernel with 1 block and 1 thread
    hipLaunchKernelGGL(addKernel, dim3(1), dim3(1), 0, 0, d_a, d_b, d_c);

    // Copy result back to host
    int c;
    hipMemcpy(&c, d_c, sizeof(int), hipMemcpyDeviceToHost);

    // Print the result
    std::cout << c;

    // Free device memory
    hipFree(d_a);
    hipFree(d_b);
    hipFree(d_c);

    return 0;
}
