if [[ -z "$1" ]]; then
	echo "Error: No module name provided."
	exit 1
fi

cat <<EOF >index.php
<?php

echo "hello world";
echo "\n";
echo "${1}";
EOF

cat <<EOF >run
php index.php
EOF

git init
git add .
git commit -m "init"
