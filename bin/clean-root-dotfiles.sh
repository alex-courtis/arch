#!/usr/bin/env sh

# adjust this forward as root is cleaned to speed things up
COMMIT_BEFORE_ROOT="b6c8858c"

rm -rf /tmp/dotfiles.cleaning
git clone "git@github.com:alex-courtis/arch.git" /tmp/dotfiles.cleaning
cd /tmp/dotfiles.cleaning || exit 1

# find all root files to ever exist
rm -v /tmp/root.files
until false; do

	# checkout and process all the way to before the first root commit
	git checkout -q "HEAD^1"
	c="$(git show -q --pretty='%h')"
	echo "${c}"
	[ "${c}" = "${COMMIT_BEFORE_ROOT}" ] && break

	# find the managed root files
	find root -type f >> /tmp/root.files
done
git checkout master

# uniq, normalise and filter plumbing
sort /tmp/root.files | \
	sed -E 's/^root//g' | \
	uniq > /tmp/root.files.uniq
mv -v /tmp/root.files.uniq /tmp/root.files

# filter current 
rm -v /tmp/root.files.removed
while IFS= read -r f <&3; do
	if [ ! -f "root${f}" ]; then
		echo "${f}" >> /tmp/root.files.removed
	fi
done 3< /tmp/root.files
echo "created /tmp/root.files.removed"

# maybe delete removed
while IFS= read -r f <&3; do
	if [ -f "${f}" ]; then
		printf "remove %s ? " "${f}"
		read -r yn
		if [ "${yn}" = "y" ]; then
			echo "removing ${f}"
			sudo rm -v "${f}"
		fi
	fi
done 3< /tmp/root.files.removed

