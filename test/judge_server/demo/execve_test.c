#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {

    char *exe_path = "./main";  // `main` executive file of HIP program


    char *args[] = {exe_path, NULL};  

    // environmental varaibales
        char *envp[] = {

        "HIP_VISIBLE_DEVICES=0",  // 限制 GPU 设备
        "HSA_OVERRIDE_GFX_VERSION=11.0.0",  // 兼容性选项

        // **结束标记**
        NULL
    };

    // the execute function used by Sandbox `execve()` 
    if (execve(exe_path, args, envp) == -1) {
        perror("execve failed");
        return 1;
    }

    return 0;
}