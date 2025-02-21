import _judger
import os

if os.system("/opt/rocm/bin/hipcc -O2 -std=c++17 main.cpp -o main"):
# if os.system("g++ main1.cpp -o main"):
    print("compile error")
    exit(1)

ret = _judger.run(max_cpu_time=-1,
                  max_real_time=-1,
                  max_memory=-1,
                  max_process_number=-1,
                  max_output_size=-1,
                  max_stack=128 * 1024 * 1024, 
                  # five args above can be _judger.UNLIMITED
                  exe_path="main",
                  input_path="1.in",
                  output_path="1.out",
                  error_path="1.out",
                  args=[],
                  # can be empty list
                  env=[],
                  log_path="judger.log",
                  # can be None
                  seccomp_rule_name=None,
                  uid=0,
                  gid=0)
print(ret)
