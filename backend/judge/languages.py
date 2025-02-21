from problem.models import ProblemIOMode
UNLIMITED = -1
#stdlib=libstdc++ \
#    -L/usr/lib/gcc/x86_64-linux-gnu/13/ -lstdc++ -fuse-ld=bfd

default_env = ["LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8"]
_c_lang_config = {
    "template": """//PREPEND BEGIN
#include <stdio.h>
//PREPEND END

//TEMPLATE BEGIN
int add(int a, int b) {
  // code
}
//TEMPLATE END

//APPEND BEGIN
int main() {
  printf("%d\n", add(1, 2));
  return 0;
}
//APPEND END""",
    "compile": {
        "src_name": "main.c",
        "exe_name": "main",
        "max_cpu_time": 3000,
        "max_real_time": 10000,
        "max_memory": 256 * 1024 * 1024,

        "compile_command": "/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c17 {src_path} -lm -o {exe_path}",
    },
    "run": {
        "command": "{exe_path}",
        "seccomp_rule": {ProblemIOMode.standard: "c_cpp", ProblemIOMode.file: "c_cpp_file_io"},
        "env": default_env
    }
}

_hipcc_config = {
    "template": """//PREPEND BEGIN
#include <stdio.h>
//PREPEND END

//TEMPLATE BEGIN
int add(int a, int b) {
  // code
}
//TEMPLATE END

//APPEND BEGIN
int main() {
  printf("%d\n", add(1, 2));
  return 0;
}
//APPEND END""",
    "compile": {
        "src_name": "main.c",
        "exe_name": "main",
        "max_cpu_time": 100000,
        "max_real_time": 200000,
        "max_memory":  UNLIMITED,  
        "compile_command": "/opt/rocm/bin/hipcc -O2 -std=c99 {src_path} -o {exe_path}",
    },
    "run": {
        "no_memory_check": True,
        "command": "{exe_path}",
        "seccomp_rule": None,
        "env": ["HSA_OVERRIDE_GFX_VERSION=11.0.3"] + default_env 
    }
}

_c_lang_spj_compile = {
    "src_name": "spj-{spj_version}.c",
    "exe_name": "spj-{spj_version}",
    "max_cpu_time": 3000,
    "max_real_time": 10000,
    "max_memory": 1024 * 1024 * 1024,
    "compile_command": "/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c17 {src_path} -lm -o {exe_path}",

}

_c_lang_spj_config = {
    "exe_name": "spj-{spj_version}",
    "command": "{exe_path} {in_file_path} {user_out_file_path}",
    "seccomp_rule": "c_cpp"
}

_hipcpp_lang_config = {
    "template": """//PREPEND BEGIN
#include <iostream>
//PREPEND END

//TEMPLATE BEGIN
int add(int a, int b) {
  // code
}
//TEMPLATE END

//APPEND BEGIN
int main() {
  std::cout << add(1, 2) << std::endl;
  return 0;
}
//APPEND END""",
    "compile": {
        "src_name": "main.cpp",
        "exe_name": "main",
        "max_cpu_time": 100000,  
        "max_real_time": 200000,
        "max_memory": -1,  
        "compile_command": "/opt/rocm/bin/hipcc -O2 -std=c++17 {src_path} -o {exe_path}",
 
    },
    "run": {
        "no_memory_check": True,
        "command": "{exe_path}",
        "seccomp_rule": None,  
        "env": ["HSA_OVERRIDE_GFX_VERSION=11.0.3"] + default_env  
    }
}

_cpp_lang_spj_compile = {
    "src_name": "spj-{spj_version}.cpp",
    "exe_name": "spj-{spj_version}",
    "max_cpu_time": 10000,
    "max_real_time": 20000,
    "max_memory": 1024 * 1024 * 1024,
    "compile_command": "/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++20 {src_path} -lm -o {exe_path}",
}

_cpp_lang_spj_config = {
    "exe_name": "spj-{spj_version}",
    "command": "{exe_path} {in_file_path} {user_out_file_path}",
    "seccomp_rule": "c_cpp"
}


_py3_lang_config = {
    "template": """//PREPEND BEGIN
//PREPEND END

//TEMPLATE BEGIN
def add(a, b):
  # code

//TEMPLATE END

//APPEND BEGIN
print(add(1, 2))
//APPEND END""",
    "compile": {
        "src_name": "solution.py",
        "exe_name": "solution.py",
        "max_cpu_time": 3000,
        "max_real_time": 10000,
        "max_memory": 128 * 1024 * 1024,
        "compile_command": "/usr/bin/python3 -m py_compile {src_path}",
    },
    "run": {
        "command": "/usr/bin/python3 -BS {exe_path}",
        "seccomp_rule": "general",
        "env": default_env
    }
}

_cpp_lang_config = {
    "template": """//PREPEND BEGIN
#include <iostream>
//PREPEND END

//TEMPLATE BEGIN
int add(int a, int b) {
  // code
}
//TEMPLATE END

//APPEND BEGIN
int main() {
  std::cout << add(1, 2) << std::endl;
  return 0;
}
//APPEND END""",
    "compile": {
        "src_name": "main.cpp",
        "exe_name": "main",
        "max_cpu_time": 10000,
        "max_real_time": 20000,
        "max_memory": 1024 * 1024 * 1024,
        "compile_command": "/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++20 {src_path} -lm -o {exe_path}",

        # Changed a linker, the default linker seems abnormal
    },
    "run": {
        "command": "{exe_path}",
        "seccomp_rule": {ProblemIOMode.standard: "c_cpp", ProblemIOMode.file: "c_cpp_file_io"},
        "env": default_env
    }
}


languages = [
    {"config": _c_lang_config, "name": "C", "description": "GCC 13", "content_type": "text/x-csrc",
      "spj": {"compile": _c_lang_spj_compile, "config": _c_lang_spj_config}},
    {"config": _cpp_lang_config, "name": "C++", "description": "GCC 13", "content_type": "text/x-c++src", 
      "spj": {"compile": _cpp_lang_spj_compile, "config": _cpp_lang_spj_config}},
    {"config": _py3_lang_config, "name": "Python3", "description": "Python 3.12", "content_type": "text/x-python"},
    {"config": _hipcc_config, "name": "HIPC", "description": "ROCm HIPC", "content_type": "text/x-csrc"},
    {"config": _hipcpp_lang_config, "name": "HIPCPP", "description": "ROCm HIPCpp", "content_type": "text/x-c++src"}
]
