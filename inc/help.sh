#!/bin/bash

echo "
COMMANDS

install :
- Import a sql file.
- Add default settings.
- Add default files ( local.xml / index.php / .htaccess )
- Set file permissions

import :
- Import a sql file.
- Add default settings.

update :
- update a module : (magetools update Myproject/Cms [config/block/page])
- create the correct file for version update.
- Load a template (config/block/page).

permissions :
- Set file permissions

debug :
- Enable template hints for 15 seconds

cache : (Default)
- Empty cache";
