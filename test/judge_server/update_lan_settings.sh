#!/bin/sh



make build
make restart


docker exec -it aup_onlinejudge_oj-backend_1 python3 manage.py shell -c "
from options.options import *;
SysOptions.reset_languages();
print(SysOptions.languages)
"
