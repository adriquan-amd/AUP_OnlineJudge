#!/bin/sh

# Enter Docker container and execute commands
docker exec -it aup_onlinejudge_oj-judge_1 sh -c '
    # Create main.cpp using a here-document
    cat <<EOF > main.cpp
#include <hip/hip_runtime.h>
#include <iostream>

// HIP Kernel for integer addition
#include <hip/hip_runtime.h>
#include <iostream>

// HIP Kernel for integer addition
__global__ void addKernel(int* d_a, int* d_b, int* d_c) {
    *d_c = *d_a + *d_b;
}



int main() {
    int a, b;
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
    printf("GPU: d_a = %d, d_b = %d\n", *d_a, *d_b); // success
    hipError_t err = hipGetLastError();
    std::cout << "Memcpy error: " << hipGetErrorString(err) <<std::endl;
    hipLaunchKernelGGL(addKernel, dim3(1), dim3(1), 0, 0, d_a, d_b, d_c); 

    // Synchronize to ensure kernel execution completes before copying data
    hipDeviceSynchronize();

    // Copy result back to host
    int c = 0;
    hipMemcpy(&c, d_c, sizeof(int), hipMemcpyDeviceToHost);

    // Print the result
    std::cout << c << std::endl;

    // Free device memory
    hipFree(d_a);
    hipFree(d_b);
    hipFree(d_c);

    return 0;
}

EOF

    # Compile hello.cpp while linking C++ standard library
    /opt/rocm/bin/hipcc -O2 -v -std=c++17 main.cpp -o main 
  
    cat <<EOF > sandbox.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    char *exe_path = "./main";  // HIP 可执行文件
    char *args[] = {exe_path, NULL};  

    // 设置环境变量
    char *envp[] = {        NULL
    };

    // 使用 execve 运行 main
    if (execve(exe_path, args, envp) == -1) {
        perror("execve failed");
        return 1;
    }

    return 0;
}
EOF

    # 编译 sandbox.c
    gcc sandbox.c -o sandbox

    # 创建输入文件 1.in
    echo "3 5" > 1.in

    # 运行 sandbox 并提供输入
    ./sandbox < 1.in > 1.out
    cat 1.out
'
