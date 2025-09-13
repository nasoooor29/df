if [[ -z "$1" ]]; then
	echo "Error: No module name provided."
	exit 1
fi

go mod init "$1"
cat <<EOF >main.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
    fmt.Println("${1}")
}
EOF

cat <<EOF >run
go run .
EOF

git init
git add .
git commit -m "init"
