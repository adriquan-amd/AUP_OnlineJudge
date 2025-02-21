#!/bin/sh

# Enter Docker container and execute commands
docker exec -it aup_onlinejudge_oj-judge_1 sh -c '
    # Create main.cpp using a here-document
    cat <<EOF > main.cpp
#include <hip/hip_runtime.h>
#include <iostream>

__global__ void addKernel(int* d_a, int* d_b, int* d_c) {
    *d_c = *d_a + *d_b;
}

int main() {
    int a, b;
    std::cin >> a >> b;

    int *d_a, *d_b, *d_c;
    hipMalloc(&d_a, sizeof(int));
    hipMalloc(&d_b, sizeof(int));
    hipMalloc(&d_c, sizeof(int));

    hipMemcpy(d_a, &a, sizeof(int), hipMemcpyHostToDevice);
    hipMemcpy(d_b, &b, sizeof(int), hipMemcpyHostToDevice);

    hipLaunchKernelGGL(addKernel, dim3(1), dim3(1), 0, 0, d_a, d_b, d_c);
    hipDeviceSynchronize();

    hipError_t kernelError = hipGetLastError();
    if (kernelError != hipSuccess) {
        std::cout << "Kernel launch error: " << hipGetErrorString(kernelError) << std::endl;

    }

    // 检查 GPU 内存数据
    int h_a, h_b, c;
    hipMemcpy(&h_a, d_a, sizeof(int), hipMemcpyDeviceToHost);
    hipMemcpy(&h_b, d_b, sizeof(int), hipMemcpyDeviceToHost);
    printf("GPU values: h_a = %d, h_b = %d\n", h_a, h_b);

    hipMemcpy(&c, d_c, sizeof(int), hipMemcpyDeviceToHost);
    std::cout << c << std::endl;

    hipFree(d_a);
    hipFree(d_b);
    hipFree(d_c);

    return 0;
}

EOF
echo "3 5" > 1.in
    if [ -f "b.out" ]; then
    rm "b.out"
fi

    if [ -f "main" ]; then
    rm "main"
fi
    # 创建 Python 评测脚本
    cat <<EOF > run_judge.py
import json
import subprocess
import os

UNLIMITED = -1

def run(max_cpu_time,
        max_real_time,
        max_memory,
        max_stack,
        max_output_size,
        max_process_number,
        exe_path,
        input_path,
        output_path,
        error_path,
        args,
        env,
        log_path,
        seccomp_rule_name,
        uid,
        gid,
        memory_limit_check_only=0,
        ):
    str_list_vars = ["args", "env"]
    int_vars = ["max_cpu_time", "max_real_time",
                "max_memory", "max_stack", "max_output_size",
                "max_process_number", "uid", "gid", "memory_limit_check_only"]
    str_vars = ["exe_path", "input_path", "output_path", "error_path", "log_path"]

    proc_args = ["/usr/lib/judger/libjudger.so"]

    for var in str_list_vars:
        value = vars()[var]
        if not isinstance(value, list):
            raise ValueError("{} must be a list".format(var))
        for item in value:
            if not isinstance(item, str):
                raise ValueError("{} item must be a string".format(var))
            proc_args.append("--{}={}".format(var, item))

    for var in int_vars:
        value = vars()[var]
        if not isinstance(value, int):
            raise ValueError("{} must be an int".format(var)) 
        if value != UNLIMITED:
            proc_args.append("--{}={}".format(var, value))

    for var in str_vars:
        value = vars()[var]
        if not isinstance(value, str):
            raise ValueError("{} must be a string".format(var))
        proc_args.append("--{}={}".format(var, value))

    if not isinstance(seccomp_rule_name, str) and seccomp_rule_name is not None:
        raise ValueError("seccomp_rule_name must be a string or None")
    if seccomp_rule_name:
        proc_args.append("--seccomp_rule={}".format(seccomp_rule_name))

    proc = subprocess.Popen(proc_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    if err:
        raise ValueError("Error occurred while calling judger: {}".format(err))
    return json.loads(out.decode("utf-8"))


# 编译 main.cpp
if os.system("/opt/rocm/bin/hipcc -O2 -std=c++17 main.cpp -o main"):
    print("Compile error")
    exit(1)

# 执行评测
ret = run(
    max_cpu_time=-1,
    max_real_time=-1,
    max_memory=-1,
    max_process_number=-1,
    max_output_size=-1,
    max_stack=128 * 1024 * 1024, 
    exe_path="main",
    input_path="1.in",
    output_path="b.out",
    error_path="1.out",
    args=[],
    env=[],
    log_path="judger.log",
    seccomp_rule_name=None,
    uid=902,
    gid=902
)

print(ret)
EOF

    rm -f b.out main

    echo "3 5" > 1.in

    # 运行 Python 评测脚本
    python3 run_judge.py

    # 确保 b.out 存在
    if [ -f "b.out" ]; then
        cat b.out
    else
        echo "Error: b.out not found"
    fi
'