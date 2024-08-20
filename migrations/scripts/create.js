// Author: Rangbhadur Bind
// Use: to create migration file this command will generate one empty migration/.sql file in sqls folder

import fs from 'fs';
import path from 'path';

(function(){
    console.log(process.argv);
    if (process.argv.length > 5) {
       throw("Invalid arguments are passed please execute below command to create migration file \n npm run db:create -- file-name --sql-file --js-file")
    }

    if (process.argv[2] !== undefined) {
        try {            
            const folder = `${path.resolve()}/migrations/migration_files`;

            if (!fs.existsSync(folder)){
                console.log("folder not available \n Creating sqls folder in mogration folder");
                fs.mkdirSync(folder);
                console.log("Folder created successfully");
            }

            const date = new Date();
            const timestamp = date.getFullYear() 
            + ("0" + (date.getMonth() + 1)).slice(-2) 
            + ("0" + date.getDate()).slice(-2) 
            + ("0" + date.getHours() ).slice(-2) 
            + ("0" + date.getMinutes()).slice(-2) 
            + ("0" + date.getSeconds()).slice(-2);
           
            if (process.argv.includes('--sql-file')) {
                const fileNameSQL = `${folder}/${timestamp}-${process.argv[2]}-sql.sql`; // -sql to identify in the migration table
                console.log('create command executed', fileNameSQL);

                fs.appendFile(fileNameSQL, "/* Replace with your SQL commands */", (error)=> {
                    if (error)
                        throw(error)
                });
            }

            if (process.argv.includes('--js-file')) {
                const fileNameJS = `${folder}/${timestamp}-${process.argv[2]}-js.js`; // -js to identify in the migration table
                console.log('create command executed', fileNameJS);
                
                const jsFileData = `export const up = async function() {
    // call your function here
};`;
                fs.appendFile(fileNameJS, jsFileData, (error)=> {
                    if (error)
                        throw(error)
                });
            }

            return true;
        } catch (error) {
            throw(error);
        }

    } else {
        throw("Filename is required please pass the file name in command like this below\n npm run db:create -- file-name --sql-file --js-file");
    }
})();