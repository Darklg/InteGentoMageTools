#!/bin/bash

echo -e "
MAGETOOLS COMMANDS

${CLR_GREEN}magetools install :${CLR_DEF}
- Import a sql file.
- Set default settings.
- Add default files ( local.xml / index.php / .htaccess )
- Set file permissions.
- Empty cache.

${CLR_GREEN}magetools import :${CLR_DEF}
- Import a sql file.
- Set default settings.
- Set file permissions.
- Empty cache.

${CLR_GREEN}magetools update [Myproject/Cms] [config/block/page/agreement/email/attributecat/image] :${CLR_DEF}
- Update a module : (magetools update)
- Create the correct file for version update.
- Load a template (config/block/page/agreement/email/attributecat/image).

${CLR_GREEN}magetools cache : (Default)${CLR_DEF}
- Empty cache.

${CLR_GREEN}magetools settings :${CLR_DEF}
- Set default settings.

${CLR_GREEN}magetools permissions :${CLR_DEF}
- Set file permissions.

${CLR_GREEN}magetools debug : (15)${CLR_DEF}
- Enable template hints for (15) seconds.

${CLR_GREEN}magetools help :${CLR_DEF}
- Display the help.";
