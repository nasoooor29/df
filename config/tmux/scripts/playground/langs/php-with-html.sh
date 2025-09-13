if [[ -z "$1" ]]; then
	echo "Error: No module name provided."
	exit 1
fi

cat <<EOF >index.php
<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Project ${1}</title>
</head>

<body>
    <?php
    echo "Hello World";
    echo "<br/>";
    echo "${1}";
    ?>
</body>

</html>
EOF

cat <<EOF >run
php -S localhost:8000
EOF

git init
git add .
git commit -m "init"
