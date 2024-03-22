# liquibase-blueprint

**This is the blueprint project for Liquibase to run a project from scratch or implement Liquibase in existing project. Important notes can be found here, like commands, general principles and good practices.**

# Assumptions
>- Following notes have been initiated on March 2024 based on Liquibase **4.26.0**
>- Liquibase works the best with Java 11. Also, it provides H2 database out of the box.

# Useful Links
>- [Documentation](https://docs.liquibase.com/home.html?__hstc=164782368.20d0072ff77e78011a42ae0d101d92f6.1657542707344.1659556811327.1659619244479.80&__hssc=164782368.32.1659619244479&__hsfp=2378282809)
>- [Forum](https://forum.liquibase.org/?__hstc=164782368.20d0072ff77e78011a42ae0d101d92f6.1657542707344.1659556811327.1659619244479.80&__hssc=164782368.32.1659619244479&__hsfp=2378282809)
>- [YouTube Channel](https://www.youtube.com/channel/UC5qMsRjObu685rTBq0PJX8w)

# About Liquibase
>Liquibase is an open-source tool written in Java. 

> Liquibase is built on top of standard JDBC to connect to the database. JDBC drivers must be stored as a .jar file in the liquibase/lib folder. [Download Oracle driver](https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)

>It allows to track, version and deploy changes in the database.

>Liquibase utilizes **Commands** and **Change Types** to run any changes in the database.

>Liquibase **Changelogs, Changesets and Change Type Objects** can be written in **SQL, XML, SQL and JSON**. In XML, YAML or JSON, the same schema changes are modeled as Liquibase Change Types. SQL and non-SQL formats can be mixed inside one project.

>Change Types describe a type of change, or action, to be executed against a database. They are easily identifiable since the Change Type description typically begins with the category of action.

>Liquibase also includes features like **rollback functionality** and **database drift detection**.

# Fundamentals of Liquibase
>You write any schema changes in your changelog (just a text file). **Changelog can also include other changelogs, which improves the every day team work**.

> Changelog has three components: **changelog header, changesets and changeset attributes.**

>Changelog contains changesets, which are a units of change executed on the database schema, such as create table, add index, drop column, etc. It keeps the list of schema changes (called changesets) to be deployed to a database. 

>Generally, there should be only one change per changeset to avoid failed auto-commit statements that can leave the database in an unexpected state.

>Changesets are executed in the same order they appear in the changelog file. Also, it's a good practice to write one database change per changeset. If not possible, test your multiple changes carefully. 

>Liquibase attempts to execute each changeset in a transaction, committing the transaction if it is successful, or rolling back if there is an error. 

>Change Types describe the type of change or action to be executed against the database. They are database independent and can execute the same changelog for different database vendors. Also, certain Change Types provide automatic rollback of changes.

>Liquibase uses tracking tables to track, version and deploy the database changes: **DATABASECHANGELOG** and **DATABASECHANGELOGLOCK**. Changesets are tracked by ID, Author and the Location where the changeset resides. Both tables are created automatically when the first changelog is executed. **DATABASECHANGELOG** tracks each successfully deployed changeset as a single row. There is no primary key on this table. **DATABASECHANGELOGLOCK** prevents conflicts between concurrent updates. 

# Liquibase Properties File
Using the Liquibase properties file saves time and potential typing errors by removing the need to enter each property as a command-line argument. If you set the values in the Liquibase properties file, then the values do not need to be specified on the command line each time you run a command. 

If you manually create the Liquibase properties file, it is recommended to name the file *liquibase.properties* and locate it in the working Liquibase project directory.

The Liquibase properties file also contains the information that Liquibase needs to connect to a particular database. 

Values specified on the command line will always override the values in the Liquibase properties file.

>Format of the JDBC URL: --url=jdbc:\<database>://\<host>:\<port>/<database_name>;\<URL_attributes>

>For Oracle Database on-premise database it can be like this ([read the documentation for more information](https://docs.liquibase.com/start/tutorials/oracle.html#Oracle)) `jdbc:oracle:thin:@localhost:1522/XEPDB1`

# Liquibase CLI
Liquibase commands provides an on-demand way to manage database changes. Liquibase command parameters include:
- command values
- global attributes
- command-line attributes

>`liquibase [global argument] [command] [command attribute]`

>Command-line arguments entered using the CLI will always override the properties stored in the Liquibase properties file.

## Command values
There are two ways a command value can be assigned:
- an equal sign (=) between attribute and value
- a space between the attribute and value

>Log level is `--log-level`

>The output file is `--output-file`

## Global Arguments
Liquibase starts with `liquibase` followed by one or more global arguments. They are specified before the command.

>`liquibase --changelog-file=dbchangelog.xml [command] [command attribute]`

## Command Arguments
Command arguments specify command-specific values and are typically listed after the command in the command line syntax.

>See the argument for `snapshot` command `liquibase --output-file=mySnapshot.json snapshot --snapshotFormat=json`

Liquibase will validate if the specified arguments are allowed for the command being executed.

# SQL Changelogs
The following line exists only once per file

    --liquibase formatted sql

Each changeset has dedicated information together with some optional attributes

    --changeset author:id
    --changeset author:id attribute1:value1 attribute2:value2 [...]

For example:

    --liquibase formatted sql

    --changeset bob:1
    create table test1(
        id   number primary key,
        name varchar2(255)
    );

    --changeset sarah:2
    create table mytable1(
        id   number primary key,
        name varchar2(255)
    );

# Platform Agnostic Changelogs - XML/YAML/JSON
There is the XML parser information at the top and the Changesets underneath.

XML parser details [link to Docs](https://docs.liquibase.com/faq.html?__hstc=164782368.20d0072ff77e78011a42ae0d101d92f6.1657542707344.1659619244479.1659626815449.81&__hssc=164782368.148.1659626815449&__hsfp=2378282809):

    <?xml version="1.0" encoding="UTF-8"?> 
    <databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:ext="http://www.liquibase.org/xml/ns/dbchangelog-ext"
        xmlns:pro="http://www.liquibase.org/xml/ns/pro"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
            http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-latest.xsd
            http://www.liquibase.org/xml/ns/dbchangelog-ext http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd
            http://www.liquibase.org/xml/ns/pro http://www.liquibase.org/xml/ns/pro/liquibase-pro-latest.xsd">
    </databaseChangeLog>

And Change Type changeset:

    <changeSet id="1" author="bob">
        <createTable tableName="department">
            <column name="id" type="number">
                <constraints primaryKey="true" nullable="false"/>
            </column>
            <column name="active" type="boolean" defaultValueBoolean="true"/>
        </createTable>
    </changeSet>

Or for other example:

    <changeSet id="1" author="nvoxland">  
        <addColumn tableName="person">  
            <column name="username" type="varchar(8)"/>  
        </addColumn>  
    </changeSet>  

# The **include** and **includeAll** tags

>The **include** tag references a single changelog file. All changesets in the referenced nested changelog will be executed in the order they appead in the file.

`<include file="com/example/db/changelog/releases/db.changelog-01.00.sql"/>`

>The **includeAll** tag references a directory where one or more changelog files can be found. Changelogs are processed in **alphabetical** order according to the filename.

`<includeAll file="com/example/db/changelog/releases"/>`

# Changeset Attributes
>The author and id are required since more than one person could use the same id value.

>The author's name or another unique value for the author can be used.

>The id tag does not control the order in which changes are run. It can be descriptive or a number that is unique within the changelog.

>The file name is also part of the identifier so the user does not have to remember the id's used in other files. The id and author combinations only need to be unique in the current file.

>It is important to avoid duplicating author and id combinations in the same file.

>It is recommended to define a changeset id system that is meaningful for your Liquibase projects.

>For comments we can use `--comment: Jira-1234` when working with SQL changelogs. Comments can be viewed by running `db-doc` command, which will generate a database documentation in a Javadoc format. Before running this command, it is recommended to specify a new empty file directory since the db-doc command creates its own directories, CSS files and HTML files.

`liquibase --changelog-file=dbchangelog.xml db-doc mychangelogDocs`

# Commands
## Required parameters are:
- changelog-file: This includes the path and filename of the changelog used. 
- username*: This is the database username value. 
- password*: The password for the database. 
- url: This is the database JDBC URL value. 

## Log Level Parameter --log-level
It can be set in the properties file or specified in the command line.
- SEVERE (highest level) – serious failures that may prevent program execution. 
- WARNING – potential problems for program execution. 
- INFO – informational messages. Complete list of the command operation.
- FINE (lowest level) – tracing information on the program execution and minor failures. Helpful in resolving errors.
- OFF (default) – hides all log messages.

## Help --help
    liquibase --help
    liquibase <command name> --help

## Update / Update-sql / update-to-tag
The Liquibase update command executes undeployed changes to a target database specified in the changelog.  When database changes are deployed for the first time in a new Liquibase project, the two Liquibase tracking tables are created in the database.

Since the update command directly changes the database schema, Liquibase provides a corresponding update-sql command. The **update-sql** command is considered a helper command that provides users the ability to inspect the SQL Liquibase that will run prior to using the update command. The **update-sql** command output is used to inspect the raw SQL to check for problem areas so users can correct identified issues before running the update command. Teams also use the command to track what Liquibase will run on the database.

`liquibase --changelog-file=yourchangelog.xml update-sql`

`liquibase --changelog-file=yourchangelog.xml update`

The `update-to-tag` command will deploy changes starting with the first changeset at the top of the changelog file until the specified tag is reached.

> The update-to-tag command will deploy changes only when you have the tagDatabase Change Type in your changelog file. The tagDatabase Change Type is not supported for formatted SQL changelogs. 

> You cannot use the update-to-tag command with a reference to a tag created in the DATABASECHANGELOG table using the tag command.

`liquibase --changelog-file=dbchangelog.xml update-to-tag version1`

## Database Status Commands - Status / History
>**history** will list deployed changesets.This is useful to inspect a group of changes to makre sure they have been applied to the database. It just requires the database URL, username and password.

>**status** will list *undeployed* changesets. This would be useful when changesets were added through source control by another developer. Except database URL, username and password, it requires also a path to the changelog file.

Options:

- `--verbose` - lists undeployed changesets along with the path to the changeset, author, and ID.

---

>Run Liquibase to execute a given changelog in the database
`liquibase --changelog-file=mychangelog.sql update`

>Clear the locks when Liquibase did not exit cleanly
`liquibase releaseLocks`, which runs `UPDATE DATABASECHANGELOGLOCK SET LOCKED=0`

## Rollback
Rollback commands **sequentially undo** changes that have been deployed to a specified point such as a date, number of changes or by tag name.

- `rollback-to-date` - used to revert changes made to the database to a previous state based on a specified date and/or time.

There are two formats that can be used to specify a date and time:

- `YYYY-MM-DD HH:MM:SS`
- `YYYY-MM-DD'T'HH:MM:SS `

Both date and time are not required. You can specify a date of time. 

Examples:
- `liquibase --changelog-file=yourchangelog.xml rollback-to-date-sql 20YY-05-01` - to inspect the output to correct identified issues
- `liquibase --changelog-file=yourchangelog.xml rollback-to-date 20YY-05-01`

---

- `rollback <tag>` - used to revert changes made to the database based on a specified tag.

Liquibase will sequentially roll back all the deployed changes until it reaches the **tag row** in the DATABASECHANGELOG table. 

If the tag has not been set, the **tag** command can be run to mark the last row inserted in the DATABASECHANGELOG table. As an example, the tag command can be used to name the current database state, database version or a numbered release.

- `liquibase tag version1` - note the changelog file information is not required

Examples:
- `liquibase --changelog-file=yourchangelog.xml rollback-sql version1`

- `liquibase --changelog-file=yourchangelog.xml rollback  version1`

---

- `rollback-count` - used to revert a specified number of changesets.

This command is used to roll back changes sequentially starting with the most recent and working backward.

Running the rollback-count command, it may be useful to run the history command to see a list of previously executed changes. 

Examples:
> `liquibase --changelog-file=yourchangelog.xml rollback-count-sql 3`

> `liquibase --changelog-file=yourchangelog.xml rollback-count 3`

---

>When changes are rolled back, the row associated with that change is deleted from the DATABASECHANGELOG table.

>It is a best practice to run the corresponding SQL command before performing a rollback.

>The minimum required parameters to run the **rollback** and **rollback-sql** are the URL, username, password and the changelog file.

>The fix forward strategy is the best recommended practice, but there may be cases when rolling back a changes is the logical option. 

>Note that auto-generated rollback is not supported for formatted SQL changesets. In this case, custom rollback statements are added to the formatted SQL changeset:

    -- liquibase formatted sql
    -- changeset nvoxland:1
    create table example1 ( id int primary key, name varchar(255) );
    -- rollback drop table example1;
                            
    -- changeset nvoxland:2
    insert into example1 values ('1','The First', 'Country')
    insert into example1 values ('2','The Second', 'Country2')
    -- rollback delete from example1 where id='1'
    -- rollback delete from example1 where id='2'

Liquibase can automatically generate a rollback statement when it can determine how the rollback should be constructed.

For example, the rollback of a CREATE TABLE would be a DROP TABLE. If your changelog only contains statements that fit into this category, your rollback commands will be generated automatically. You do not need to add anything to your changelogs or Liquibase configuration to enable auto-generated rollbacks.

### Rolling Back of SQL Changelogs

    -- liquibase formatted sql

    -- changeset lbuser:20200908
    insert into CustomerDetails values ('A','Customer NumberOne', 'Austin')
    insert into CustomerDetails values ('A','Customer NumberTwo', 'Dallas')
    -- rollback delete from CustomerDetails where id='A'

## Diff Commands

Then can be used to:

- find missing objects
- see whether specific changes were made to the database
- identify any unexpected items in the database

>`diff` - used to compare two databases of the same, or different types to each other

>`diff-changelog` - used to create a changelog file to synchronize multiple databases

>**Diff commands are also useful to start using Liquibase with an existing project. The minimum required parameters to run these commands are the database URL, username, password and changelog file.**

In addition to the above minimum required parameters, both diff commands require the following command parameters. You can configure them in Liquibase properties file:

- `referenceUsername` - username for the reference database
- `referencePassword` - password for the reference database
- `referenceURL` - the source (reference) database of snapshot which is the starting point for the database you want to compare

Examples:
- `liquibase --outputFile=mydiff.txt --username=<USERNAME> --password=<PASSWORD> --referenceUsername=<USERNAME>
--referencePassword=<PASSWORD> diff`

- `liquibase  --changelog-file=file_name.sql  --username=<USERNAME> --password=<PASSWORD>
--referenceUsername=<USERNAME> --referencePassword=<PASSWORD> diff-changelog` - if you specify a file name that already exists, Liquibase will append your changes to the existing file. 

- `--diffTypes=<catalogs,tables,functions,views,columns,indexes,foreignkeys>` - you have the option to filter which objects the diff-changelog generates by using the diffTypes attribute.

## Database Snapshot Commands
The are two commands to provide a snapshot. These commands do not modify the database.

- `snapshot` - used to capture the current state of the database.
- `generate-changelog` - used to create a changelog file that describes how to re-create the current state of the database. This command also requires the path to the changelog file. The output of the snapshot command using the `--snapshotFormat=json` attribute can be compared to an existing database to see differences when using the diff and diff-changelog commands. **The generate-changelog command is typically used to capture the current state of a database and then apply those changes to another database.** This can be useful when a project has an existing database but Liquibase has not been used before.

>Snapshots are great for keeping a record of the current database state but snapshots cannot be used to repopulate a database.

>To record a database state in a format that will allow for re-creating that state, use the generate-changelog command.

Examples:
- `liquibase snapshot`
- `liquibase --output-file=yourSnapshot.json snapshot --snapshotFormat=json` - using the `--snapshotFormat=json` attribute will create a JSON file instead of a report to STDOUT.

- `liquibase --changelog-file=newgeneratedchangelog.xml generate-changelog`
- `liquibase --changelog-file=newgeneratedchangelog.yourdbtype.sql generate-changelog` - to create a SQL changelog file, add the database short name attribute when specifying the changelog file - `oracle, postgresql, db2, and H2`.

## tag for Setting Tags

A tag is like a bookmark. It designates a point in the changelog file or a row in the DATABASECHANGELOG table that indicates the database state, version, release, or other identifying information. 

It is a best practice to add tags to your changelogs before running Liquibase commands against your database.

Use cases:

- To mark the current state of your database, its version, or a numbered release with the tag command to roll back changes in the future. 
- To use the `rollback` command to sequentially undo all changes that were made to the database after the specified tag. 
- To use the `update-to-tag` command to sequentially apply all changesets from your changelog up to the point indicated by the tag. 
- To separate the flow of changes based on versions and releases for database migrations.
- Manage a series of deployments in multiple databases and track their history.

How to use it:

- Use the `tagDatabase` Change Type to tag your current database state, release, or version, and then deploy new changesets to that tag, or roll back changesets applied after that tag. The tagDatabase Change Type is useful to mark the beginning of a release. 

        <changeSet  author="liquibase"  id="1">  
            <tagDatabase  tag="version1"/>  
        </changeSet>

-  Use the tag command to mark the end of a release. The tag command will mark the current database state so you can roll back changes in the future. After setting the tag, use the `rollback<tag>` command to roll back all changes under the tag.

`liquibase tag version1`

# Troubleshooting

## Common mistakes
- incorrectly structured XML/YAML/JSON/formatted SQL
- references to missing files
- duplicated id/author/file combinations
- checksum errors
- missing or incorrect changeset attributes for your database platform
- failures in top-level preconditions

> If the Liquibase update command encounters an error in a changelog, it will **stop processing** which will leave you with a partial update. It is a best practice to verify that a changelog is valid before running an update. 

## Validate (command)

This command checks and identifies possible errors in a changelog that can cause the update command to fail. You can avoid a partial updates. If you use nestest changelogs, Liquibase will check all changelogs in the hierarchy for changesets to validate. But, it does not verify that the SQL syntax is correct. 

`liquibase --changelog-file=dbchangelog.xml validate`

## Rollback Test Cycle
1. Deploying all changes to the database and validating that they were deployed.
2. Rolling back all changes to the database, validating that all changes were undone, and the database was brought back to the previous state.
3. Redeploying all changes to the database. This step is required to verify that the rollback did not miss any changes that would impact a future development. 

## The **update-testing-rollback** Command
The **update-testing-rollback** is typically used to test rollback functionality when deploying changesets in your changelog sequentially. 

> The command tests your rollback by deploying all pending changesets to the database, executing a rollback sequentially in reverse order for the changesets that were deployed, and then running the update again to deploy all changesets to the database. 

> Run **update-testing-rollback** only when all pending changelogs are ready to be deployed as you cannot specify changests to exclude. 

`liquibase --changelog-file=dbchangelog.sql --log-level=info update-testing-rollback`

## The **future-rollback-sql** Command
It is a best practice to inspect the SQL Liquibase would run before doing a rollback so that you can review the changes that would be made to the database. 

The **future-rollback-sql** command produces the raw SQL Liquibase would use to revert changes associated with undeployed changesets. It does not deploy any changes to the database.

The future-rollback-sql command is also useful when auditors need to verify that all database changes have a rollback.

Notice that the rollback SQL removes the changesets from the DATABASECHANGELOG table along with undoing the database changes. This allows you to redeploy the changesets after executing a rollback.

`liquibase --changelog-file=dbchangelog.sql --output-file=futurerollback.sql future-rollback-sql`

## list-locks Command
The list-locks command reads the DATABASECHANGELOGLOCK table and returns the hostname, IP address, and the timestamp the Liquibase lock record was added. The command determines the connections to the DATABASECHANGELOGLOCK table based on the database URL.

When an error occurs during a database deployment, list-locks is a good command to start with when troubleshooting the situation. The error might indicate that there is a lock record in the DATABASECHANGELOGLOCK table that prevents Liquibase from applying changes to the specified database.

`liquibase --changelog-file=dbchangelog.xml list-locks`

## release-locks Command
The **release-locks** command removes the specific Liquibase lock record from the DATABASECHANGELOGLOCK table in the database. Manually updating the DATABASECHANGELOGLOCK table is not a recommended procedure. Using the release-locks command is the most appropriate solution.

`liquibase --changelog-file=dbchangelog.xml release-locks`

## clear-checksums Command

The Liquibase clear-checksums command clears all checksums and nullifies the MD5Sum column of the DATABASECHANGELOG table so the checksums will be re-computed the next time the Liquibase update command is run.

The checksum in the DATABASECHANGELOG table is a combination of the MD5Sum of the file, the author, and the id of a changeset. It is meant to make sure that the changesets in the log file are the same as what was applied to the database.

`liquibase  clear-checksums`

> There are a number of reasons for clearing the checksums on the DATABASECHANGELOG, but the command should be used as a last resort since it clears all checksums on every change that has been made to the database.

Alternatives:

- Adding a valid-checksum attribute to the changeset that is having problems deploying.
- Manually removing the entry or entries in the DATABASECHANGELOG table and cleaning up the database that those entries represent. This will remove the changeset with the checksum error to run on the next update.

## mark-next-changeset-ran Deploying Manual Changes

There are times when there is a small time window to fix a PROD database. In that case, you may test a fix in STAGE, and once validated, manually deploy to PROD with the same change applied to the DEV and TEST environments.

You can add the change to your changelog and update DEV and TEST without any problems. However, the update should not be applied to the STAGE and PROD environments. In fact, the update is likely to fail in STAGE and PROD because of an "object already exists" error.

In this situation, you need to update the DATABASECHANGELOG table so that Liquibase does not try to apply the changeset to the databases where the changeset was manually applied.

The mark-next-changeset-ran command marks the next changeset to be applied as executed by inserting a new row in the DATABASECHANGELOG table. You can think of it as a "fake deploy" operation.

The mark-next-changeset-ran-sql command is used to inspect the raw SQL before running the mark-next-changeset-ran command. It is a best practice to verify that the correct changeset will be marked as executed before running the mark-next-changeset-ran command.

`liquibase --changelog-file=dbchangelog.xml mark-next-changeset-ran-sql`

`liquibase --changelog-file=dbchangelog.xml mark-next-changeset-ran`

# Standard Developer Workflow

- Adding a changeset(s) to the changelog.
- Running the database update command.
- Veryfying the results of the database update.
- Saving the changelog to source control.

# Good Practice

## Root Changelog
The root changelog file operates as the primary changelog that reference other changelogs. Root changelog can be in an XML, JSON or YAML format. The nested changelogs can be a SQL, XML, JSON or YAML. 

## Manage Data with Liquibase
Data used as part of building and testing the application should be managed with Liquibase. Use cases include:

- Managing application configuration and lookup tables such as country tables and enumered lists.
- Deploying test data to QA environments.
- Deploying data fixes specific to pre-production and production environments.

# Project Setup
1. Pull the repository or download it as a ZIP.
2. Adopt the properties file.
3. Download JDBC libraries when necessary and place it into `liquibase/internal/lib` folder.
4. Prepare the master.xml file to make him including single changelogs and entire folders. 

# Useful Commands
[Liquibase Commands](https://docs.liquibase.com/parameters/home.html)

`liquibase --defaults-file=liquibase_config/dev.liquibase.properties status`

`liquibase --defaults-file=liquibase_config/dev.liquibase.properties --changelog-file=practice/dbchangelog.xml status --verbose`

# Other stuff
    set ddl storage off
    set ddl tablespace off
    set ddl segment_attributes off
    set ddl pretty on
    ddl hr.jobs

---

# Step by Step Guide - Installation from Zero

## When starting your project

1. Run `./db_setup/install/1_install_system.sql` from `SYS` user.
2. Run `./db_setup/install/2_install_logger.sql` from `LOGGER` user.
3. Run Liquibase command `TODO` to execute changests. 

## Adding another schema
1. Copy starter folder. Ensure all the schema name being added is correct everywhere. See the changeset headers also!
2. Add 2 changelogs to master.xml.
3. Add DROP statement to `/db_setup/admin/drop.sql`

# TODO
1. Explain how to introduce Liquibase in existing project.