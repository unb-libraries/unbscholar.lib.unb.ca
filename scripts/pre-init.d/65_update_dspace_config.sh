#!/usr/bin/env bash

# add the property=value assignment in a java properties file or override it if already exists
# @param 1 (required) property name
# @param 2 (required) property value
# @param 3 (required) java properties  file name
set_dspace_property (){
	local propval="${1} = ${2}"
	local cfg_file=${DSPACE_INSTALL}/config/local.cfg
	if [ ! -f "$cfg_file" ]; then
		print_warn "El archivo ${cfg_file} no existe, no se puede continuar"
		touch $cfg_file

	fi
	local oldval=$(get_dspace_property $1 $cfg_file)
	if [[ -z "${oldval}" ]]; then
        echo $propval >> ${cfg_file}
	else
        sed -i "s#^${1}.\?=.*#${propval}#" $cfg_file
    fi
}

# @param 1 (required) property name to look for
# @param 2 (required) java properties file name
# @returns property value if found, null otherwise
get_dspace_property () {
	local cfg_file=${2}
    grep "^${1}\s*\=" ${cfg_file} |cut -d'=' -f2
}

print_warn(){
	printf "[WARN] %s\n" "$*";
}

set_dspace_property "db.url" "jdbc:postgresql://${POSTGRES_DB_HOST}:${POSTGRES_DB_PORT}/${POSTGRES_DB_NAME}"
set_dspace_property "db.username" "${POSTGRES_DB_USER}"
set_dspace_property "db.password" "${POSTGRES_DB_PASS}"
set_dspace_property "dspace.dir" "${DSPACE_INSTALL}"
set_dspace_property "db.cleanDisabled" "false"
