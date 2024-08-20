Purpose: to handle automatic migration when project is deployed.

Commands:
create migration file: 
    base command: npm run db:create --
    to create sql file: npm run db:create -- --sql-file
    to create js file: npm run db:create -- --js-file
    to create both js and sql file: npm run db:create -- --js-file --sql-file
Execute migration: npm run db:migrate

Flow:
    when db:migrate command executed migration file will be generated into migration_files folder (this will be created on fly)
    when db:migrate command executed then js file or sql file will be executed and migration table is updated with respect to that migration file. 
    