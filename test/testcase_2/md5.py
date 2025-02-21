import hashlib

with open("1.out", "rb") as f:
    content = f.read()
print(hashlib.md5(content.rstrip()).hexdigest())