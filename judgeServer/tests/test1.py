import shlex

command = "/opt/rocm/lib/llvm/bin/clang++ -O2 -std=c++17 hello.cpp -o hello"
_command = shlex.split(command)
print(command)
print(_command)
