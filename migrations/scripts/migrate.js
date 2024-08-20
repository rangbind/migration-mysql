import path from 'path';
import { promises as fs } from 'fs';
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config();

async function executeJSFile(fileDetails){
    try{
        console.log(`Executing js file : ${fileDetails.fileName}.${fileDetails.type}`);
        import(`../migration_files/${fileDetails.fileName}.${fileDetails.type}`).then( loadedModule => loadedModule.up() );
        console.log(`Executing js file success: ', ${fileDetails.fileName}.${fileDetails.type}`);
        return true;
    }catch(e){
        console.log(e);
        throw(e);
    }
}

async function createMigrationTable(connection) {
    try {
        const script = 'CREATE TABLE IF NOT EXISTS `migration` ( `migrationId` INT NOT NULL AUTO_INCREMENT, `fileName` VARCHAR(200) NOT NULL,`createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`migrationId`))'
        await connection.execute(script);
        return true;
    } catch (error) {
        throw(error)
    }
}

async function executeMigrationFiles(connection, fileDetails) {
    try {
        if (fileDetails.type === 'js') {
            await executeJSFile(fileDetails);
        } else if (fileDetails.type === 'sql') {
            const folder = `${path.resolve()}/migrations/migration_files`;
            let fileContent = await fs.readFile(`${folder}/${fileDetails.fileName}.${fileDetails.type}`);
            fileContent = fileContent.toString();
            fileContent = fileContent.split(";");
            for (let query of fileContent) {
                if (query !== '' && query.length > 5) {
                    await connection.execute(query);
                }
            }
        }
        await connection.execute(`INSERT INTO migration(fileName) VALUES('${fileDetails.fileName}')`);
        console.log(`${fileDetails.fileName} is executed successfully`);
        return true;
    } catch (error) {
        throw(error);
    }
}

async function processMigration(files) {
    console.log('executing processMigration');
    try {
        const connection = await mysql.createConnection({
            user: process.env.DB_USERNAME,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_DATABASE,
            host: process.env.DB_HOST,
        });

        await createMigrationTable(connection);
        let [rows, fields] = await connection.execute('SELECT fileName FROM migration');

        rows = rows.map((data)=>data.fileName);
        for(let file of files){
            if (rows.indexOf(file.fileName) === -1) {
                await executeMigrationFiles(connection, file);                
            }
        }
        connection.close();
        return true;
    } catch (error) {
        throw(error);
    }
}

(async function(){
    try {

        const folder = `${path.resolve()}/migrations/migration_files`;
        const files = await fs.readdir(folder);
        const filesArray = []
        for(let file of files) {
            if (file.split('.')[1] !== undefined && (file.split('.')[1] === 'sql' || file.split('.')[1] === 'js')) {
                let content = await fs.readFile(folder+'/'+file, 'utf-8');
                filesArray.push({
                    fileName: file.split('.')[0],
                    content,
                    type: file.split('.')[1]
                });
            }            
        }

        if (filesArray.length > 0) {
            await processMigration(filesArray);
        }

        console.log('db:migration successful');
        return true;        
    } catch (error) {
        throw(error);
    }
})();