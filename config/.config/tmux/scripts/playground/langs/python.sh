if ! command -v uv &>/dev/null; then
	echo "uv command not found. Installing..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if [[ -z "$1" ]]; then
	echo "Error: No module name provided."
	exit 1
fi

uv init --name="$1"

git init
git add .
git commit -m "init"
