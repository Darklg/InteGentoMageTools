#!/bin/bash

echo "
COMMANDS

magetools install :
- Import a sql file.
- Set default settings.
- Add default files ( local.xml / index.php / .htaccess )
- Set file permissions.
- Empty cache.

magetools import :
- Import a sql file.
- Set default settings.
- Set file permissions.
- Empty cache.

magetools update ( Myproject/Cms [config/block/page/agreement] ):
- Update a module : (magetools update )
- Create the correct file for version update.
- Load a template (config/block/page/agreement).

magetools cache : (Default)
- Empty cache.

magetools settings :
- Set default settings.

magetools permissions :
- Set file permissions.

magetools debug :
- Enable template hints for 15 seconds.

magetools help :
- Display the help.";
