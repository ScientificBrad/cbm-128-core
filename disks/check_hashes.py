import gzip
import hashlib
import os
import glob

# Extract 28may87-1.d64.gz into cpm_28may87_extracted.d64 if not already extracted
gz_path = 'disks/28may87-1.d64.gz'
ext_path = 'disks/cpm_28may87_extracted.d64'
if os.path.exists(gz_path) and not os.path.exists(ext_path):
    with gzip.open(gz_path, 'rb') as f_in, open(ext_path, 'wb') as f_out:
        f_out.write(f_in.read())
    print(f'Extracted {gz_path} -> {ext_path}')

files = sorted(glob.glob('disks/*.d64') + glob.glob('disks/*.gz'))
print(f'{"File":<35} {"Size":<10} {"SHA-256":<64}')
print('-' * 115)
for f in files:
    with open(f, 'rb') as fp:
        data = fp.read()
    h = hashlib.sha256(data).hexdigest()
    print(f'{os.path.basename(f):<35} {len(data):<10} {h}')
