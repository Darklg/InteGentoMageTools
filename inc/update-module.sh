#!/bin/bash

type_update_available="config block page agreement";

function magetools_load_update_template {
    rm "${update_file}";
    cp "${SOURCEDIR}/files/tpl/update-${1}.php" "${update_file}";
    echo "- Template file for '${1}' update loaded";
    return;
}

###################################
## Get module
###################################

# Test file
module_path="$( pwd )/app/code/local/${1}";
conf_file="${module_path}/etc/config.xml";
if [ ! -f "${conf_file}" ]; then
    echo "The module does not exists";
    return;
fi;

# Get version
module_conf_content=`cat ${conf_file}`;
module_version=$(sed -ne '/\<version/{s/.*<version>\(.*\)<\/version>.*/\1/p;q;}' <<< "${module_conf_content}");
echo "- Module in version ${module_version}";

if [ ! -d "${module_path}/data" ];then
    echo "The module do not have a data directory";
    return;
fi;

# Increment version - thx http://stackoverflow.com/a/6245983
module_version2=`echo $module_version | ( IFS=".$IFS" ; read a b c && echo $a.$b.$((c + 1)) )`

# File name
update_file_name="data-upgrade-${module_version}-${module_version2}.php";

# Create update file in the data folder
for dir in `find "${module_path}/data" -type d` # Find directories recursively
do
    # Take the last folder in data/ (@TODO :)
    update_file="${dir}/${update_file_name}";
done;

# Check file
if [ -f "${update_file}" ];then
    echo "- The update file for v ${module_version2} already exists";
    return;
fi;

# Confirm creation !
touch "${update_file}";
echo "- ${update_file_name} has been created";

# If argument with type
if [[ ! -z "$2" && ${type_update_available} == *"$2"* ]];then
    magetools_load_update_template "${2}";
else
    # Check all
    for type_update in ${type_update_available}; do
        is_update='n';
        read -p "Is it a '${type_update}' update ? [Y/n]: " is_update;
        if [[ $is_update != 'n' ]]; then
            magetools_load_update_template ${type_update};
            break;
        fi;
    done;
fi

read -p "Open template file ? [Y/n]: " open_template;
if [[ $open_template != 'n' ]]; then
    open "${update_file}";
fi;
