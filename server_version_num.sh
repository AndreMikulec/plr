
set -v -x

cd "$(dirname "$0")"

# remove whitespace and empty lines -- except remains: last line that is empty
sed -i -r -e  's/\s+//g' -e '/^$/d' $(cygpath ${GITHUB_WORKSPACE})/server_version_num.txt

# remove the only and last empty line
echo -n $(cat $(cygpath ${GITHUB_WORKSPACE})/server_version_num.txt) > $(cygpath ${GITHUB_WORKSPACE})/server_version_num.txt

set +v +x

