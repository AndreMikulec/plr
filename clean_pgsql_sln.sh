
set -v -x -e
# set -e

#
# Only when compiling pg from scratch.
# If pg is not being compiled then pgsql.sln will not exist and not have been created.
#
# The semi-duplicate extra 'plr' entry in the pgsql.sln file 
# prevents building if Microsoft Visual Studio is the version 2019 and greater.
#

pwd

# ls -alrt /c/projects/plr
# ls -alrt /c/projects/postgresql

export PGSLNLOCATION=/c/projects/postgresql/pgsql.sln
echo PGSLNLOCATION: $PGSLNLOCATION

if [ -f "${PGSLNLOCATION}" ]
then
  echo FILE ${PGSLNLOCATION} exists
  echo REMOVE the semi-duplicate extra plr ENTRY from the file pgsql.sln

  # GUID to later delete
  export BRACEDGUID=`cat $PGSLNLOCATION | grep '"plr", "plr"' | grep -Po '"{[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+}"$' | grep -Po '{[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+}'`

  echo From pgsql.sln the extra BRACEDGUID to Remove: $BRACEDGUID
    
  # remove GlobalSection(NestedProjects) entry GUID
  sed -i "/= $BRACEDGUID/d" $PGSLNLOCATION

  # remove entry of Project line (and its GUID) and its EndProject line
  sed -i '/"plr", "plr"/,+1d' $PGSLNLOCATION
else
  echo FILE ${PGSLNLOCATION} does not exist
fi

set +v +x +e
# set +e
