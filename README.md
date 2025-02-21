# AUP HIP OnlineJudge
Based on https://github.com/QingdaoU/OnlineJudge, add AMD GPU ROCm program support, and some DevOps.


# Getting Start

## Clone 
```
git clone git@github.com:KerwinTsaiii/AUP_OnlineJudge.git
cd AUP_OnlineJudge
git submodule update --init --recursive
```

## Build
This project uses Docker Compose to build and run the code.
```
make build
```

### Test
```
make up
```
If you want to see Docker Compose logs, you can use the logs command to continuously display container logs in stdout.
```
make logs
```
Using http://\<IP\> for frontend access.
