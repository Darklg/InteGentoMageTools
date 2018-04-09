#!/bin/bash

oldfile="${1}";
oldfileoriginal="${1}";

if [[ ${oldfile} == '' ]]; then
    echo -e "${CLR_RED}- The file path is not defined.${CLR_DEF}";
    return 0;
fi;

###################################
## Test file
###################################

# Convert the absolute path to a relative path.
if [[ ${oldfile} == *"/app/design"* ]]; then
    MTCOPY_LONGPREFIX=${oldfile%app/design*};
    echo -e "${CLR_GREEN}- Removing this part of the absolute path : ${MTCOPY_LONGPREFIX}${CLR_DEF}";
    MTCOPY_LONGPREFIX=${MTCOPY_LONGPREFIX//\//\\/};
    oldfile=$(echo "${oldfile}" | sed -e "s/${MTCOPY_LONGPREFIX}//g");
fi

# Add args before
pathtest="app/design app/design/frontend app/design/frontend/base app/design/frontend/base/default app/design/frontend/base/default/template";
if [ ! -f "${oldfile}" ]; then
for f in ${pathtest}; do
    if [ ! -f "${oldfile}" ]; then
        echo -e "${CLR_YELLOW}- Trying with ${f} before file path.${CLR_DEF}";
        oldfile="${f}/${oldfileoriginal}";
    else
        break;
    fi;
done;
fi;

if [ ! -f "${oldfile}" ]; then
    echo -e "${CLR_RED}- The original file could not be found.${CLR_DEF}";
    return 0;
else
    echo -e "${CLR_GREEN}- File has been found : ${oldfile}.${CLR_DEF}";
fi;

###################################
## Get current theme
###################################

. "${SOURCEDIR}/inc/functions/extract-infos.sh";

themeid=$(echo "use ${mysql_base};SELECT value FROM core_config_data WHERE path='design/package/name'" | mysql --defaults-extra-file=my-magetools.cnf)
themeid=$(echo $themeid | cut -d " " -f 2);

# Using custom theme id if set
if [[ "${2}" != "" ]]; then
    echo -e "${CLR_YELLOW}- Using '${2}' as a theme id.${CLR_DEF}";
    themeid="${2}";
fi;

oldfileparts=($(echo "${oldfile/app\/design\/frontend\//}" | tr '/' '\n'));
originalpath="frontend/${oldfileparts[0]}/${oldfileparts[1]}";
newpath="frontend/${themeid}/default";

###################################
## Test theme
###################################

if [[ $themeid == '' ]]; then
    echo -e "${CLR_RED}- The theme could not be imported from config.${CLR_DEF}";
    return 0;
fi;

if [ ! -d "app/design/${newpath}" ]; then
    echo -e "${CLR_RED}- The theme 'app/design/${newpath}' could not be found.${CLR_DEF}";
    return 0;
fi;

###################################
## Create new file
###################################

newfile="${oldfile/$originalpath/$newpath}";
newfiledir=$(dirname "${newfile}");

if [ ! -f "${newfile}" ]; then
    # Ensure new dir exists
    mkdir -p "${newfiledir}";
    # Copy file
    cp "${oldfile}" "${newfile}";
    echo -e "${CLR_GREEN}- The file has been copied.${CLR_DEF}";
else
    echo -e "${CLR_YELLOW}- The file already exists.${CLR_DEF}";
fi;


if magetools_command_exists subl ; then
    # - Cache
    read -p "Open in Sublime Text [Y/n]: " open_in_sublime_text;
    if [[ "${open_in_sublime_text}" != 'n' ]]; then
        subl "${newfile}";
    fi;
fi;
