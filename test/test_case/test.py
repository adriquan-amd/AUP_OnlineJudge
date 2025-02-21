import hashlib
with open("1.out", "rb") as f:
    content = f.read()

output_md5 = hashlib.md5(content.rstrip()).hexdigest()
print(output_md5)

print(hashlib.md5("101010101010101010".encode()).hexdigest())