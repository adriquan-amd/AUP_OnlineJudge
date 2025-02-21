#!/bin/sh

docker exec -it aup_onlinejudge_oj-judge_1 sh -c '
    cat <<EOF > main.cpp
#include <iostream>
#include <pwd.h>
#include <grp.h>
#include <sys/types.h>

int main() {
    struct passwd *pw = getpwnam("code");
    struct group *gr = getgrnam("code");

    if (pw) {
        std::cout << "User ID: " << pw->pw_uid << std::endl;
    } else {
        std::cerr << "User '\''code'\'' not found!" << std::endl;
    }

    if (gr) {
        std::cout << "Group ID: " << gr->gr_gid << std::endl;
    } else {
        std::cerr << "Group '\''code'\'' not found!" << std::endl;
    }

    return 0;
}
EOF

    # Compile with a different output file name
    g++ main.cpp -o main.out
    ./main.out
'
