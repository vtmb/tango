# Tango

I wanted to test the Kitura-Webframework and the Vapor MySQL Driver and the StencilTemplateEngine.
This is my very first Web Project, i think even SQL-Injections would work and I lost interest in this project after a while. I just uploaded it for historical reasons.

In case you want to try this project you will need a MySQL Database.

```bash
CREATE TABLE milongas (
    `list_weekday` VARCHAR(2) CHARACTER SET utf8,
    `list_roto` VARCHAR(57) CHARACTER SET utf8,
    `list_city` VARCHAR(15) CHARACTER SET utf8,
    `list_location` VARCHAR(20) CHARACTER SET utf8,
    `list_time` VARCHAR(13) CHARACTER SET utf8,
    `list_annotation` VARCHAR(81) CHARACTER SET utf8,
    `list_contact` VARCHAR(20) CHARACTER SET utf8,
    `list_cost` INT
);
```
```bash
INSERT INTO milongas VALUES ('Mo','Jeden Montag','Demo-Stadt','Demo-Location','20:00 - 24:00','Demo-Anmerkung','Demo-Kontakt-Angabe',5);
```

Xcode will not find the headers, if you don't tell it where to find the headers.
You will need to install mysql

```bash
brew install mysql
```

if you are on macos you can easily tell xcode where to look for the mysql headers.
```bash
swift package -Xlinker -L/usr/local/lib generate-xcodeproj
```

If you do not want to use xcode but want to build via command line try this
```bash
swift build -Xswiftc -I/usr/local/include/mysql -Xlinker -L/usr/local/lib
```
