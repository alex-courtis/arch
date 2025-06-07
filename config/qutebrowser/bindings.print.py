import re

# user bindings always come back as "<Ctrl+Shift+f" , defaults as "<Ctrl-Shift-F"
def normalise(key):
	if re.match('.*(shift|ctrl|alt)[+-].*', key, flags=re.IGNORECASE):
		key = key.lower()
		key = re.sub('ctrl[+-]', 'Ctrl-', key)
		key = re.sub('alt[+-]', 'Alt-', key)
		key = re.sub('shift[+-]', 'Shift-', key)
	return key

# collect default bindings
all = {}
for mode, binds in c.bindings.default.items():
	for key, cmd in binds.items():
		key = normalise(key)
		all[f'{mode}{key}'] = f'{mode:12}D  {key:18}{cmd}'

# sort default by mode/key and print
print('\n--Default Bindings--')
for mode_key in sorted(all, key=str.lower):
	print(f'D {all[mode_key]}')

# collect user bindings, removing any unbindings
for mode, binds in c.bindings.commands.items():
	for key, cmd in binds.items():
		key = normalise(key)
		if cmd is None:
			all.pop(f'{mode}{key}', None)
		else:
			all[f'{mode}{key}'] = f'{mode:12}   {key:18}{cmd}'

# sort all by mode/key and print
print('\n--Actual Bindings--')
for mode_key in sorted(all, key=str.lower):
	print(f'A {all[mode_key]}')

