#!/bin/bash

type_update_available="config block page email attributecat agreement image";

###################################
## Get module
###################################

# Module ID
module_id=$(echo $1 | sed 's/\//_/');
module_id_min="$(tr [A-Z] [a-z] <<< "$module_id")";
module_id_setup="${module_id_min}_setup";

module_base_path="$( pwd )/app/code/";

# Finding
module_path="${module_base_path}local/${1}";
conf_file="${module_path}/etc/config.xml";
if [ ! -f "${conf_file}" ]; then
    echo "The module is not in local, trying community.";
    module_path="${module_base_path}community/${1}";
    conf_file="${module_path}/etc/config.xml";
    if [ ! -f "${conf_file}" ]; then
        echo "The module does not exists";
        return;
    fi;
fi;

# Get version
module_conf_content=`cat ${conf_file}`;
module_version=$(sed -ne '/\<version/{s/.*<version>\(.*\)<\/version>.*/\1/p;q;}' <<< "${module_conf_content}");
echo "- Module in version ${module_version}";

if [ ! -d "${module_path}/data" ];then
    mkdir "${module_path}/data";
    mkdir "${module_path}/data/${module_id_setup}";
fi;

# Increment version - thx http://stackoverflow.com/a/6245983
module_version2=`echo $module_version | ( IFS=".$IFS" ; read a b c && echo $a.$b.$((c + 1)) )`

###################################
## Generate update file
###################################

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

###################################
## Allow updates in config
###################################

# Check global
magetools_config_check_xml 'config' 'global';

# Check resources
magetools_config_check_xml 'global' 'resources';

# Check setup
module_setup_content="<${module_id_setup}>\
    <setup>\
        <module>${module_id}<\/module>\
        <class>Mage_Core_Model_Resource_Setup<\/class>\
    <\/setup>\
    <connection>\
        <use>core_setup<\/use>\
    <\/connection>\
<\/${module_id_setup}>";

if grep -q "<${module_id_setup}>" "$conf_file";
then
    echo "<${module_id_setup}> is defined.";
else
    sed -i '' "s/\<\/resources\>/${module_setup_content}<\/resources\>/" $conf_file;
fi

if magetools_command_exists tidy ; then

    # find indentation level
    magetools_indent_level=2;
    magetools_config_file_content=`cat ${conf_file}`;
    case "${magetools_config_file_content}" in
      *\ \ \ \ \<modules\>*)
        magetools_indent_level=4;
        ;;
    esac

    # Tidy
    tidy -m -xml -indent --indent-spaces $magetools_indent_level -w 0 -q $conf_file;
fi

###################################
## Generate content
###################################

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

read -p "Update Config version ? [Y/n]: " update_config_version;
if [[ $update_config_version != 'n' ]]; then
    open "${update_file}";
    sed -i '' "s/<version>${module_version}<\/version>/<version>${module_version2}<\/version>/" ${conf_file};
fi;

read -p "Open template file ? [Y/n]: " open_template;
if [[ $open_template != 'n' ]]; then
    open "${update_file}";
fi;
