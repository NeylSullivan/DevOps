# DevOps
Batch scripts to automate some Unreal Engine 5 project development operations: cleaning, building, packaging, backing up etc.

## Instalation
Place `DevOps` directory under the root project directory.

<!-- AUTO_GENERATED_CONTENT_START -->
## Table of Contents
- Core
  - [config.bat](#coreconfigbat)
  - [config_archiver.bat](#coreconfig_archiverbat)
  - [generate_readme.bat](#coregenerate_readmebat)
  - [generate_readme.py](#coregenerate_readmepy)
  - [utils.bat](#coreutilsbat)
- Standalone
  - [simple_backup.bat](#standalonesimple_backupbat)
  - [standalone_resave_and_generate_DDC.bat](#standalonestandalone_resave_and_generate_ddcbat)
- [backup_code.bat](#backup_codebat)
- [backup_from_gitignore.bat](#backup_from_gitignorebat)
- [build_cook_archive.bat](#build_cook_archivebat)
- [build_solution_development_editor.bat](#build_solution_development_editorbat)
- [clean_intermediate_files.bat](#clean_intermediate_filesbat)
- [generate_vs_project_files.bat](#generate_vs_project_filesbat)
- [rebuild_python_stub.bat](#rebuild_python_stubbat)
- [rebuild_solution_development_editor.bat](#rebuild_solution_development_editorbat)
- [rebuild_solution_game_shipping.bat](#rebuild_solution_game_shippingbat)
- [resave.bat](#resavebat)
- [resave_and_generate_DDC.bat](#resave_and_generate_ddcbat)
- [validate_assets.bat](#validate_assetsbat)
---
### Core\config.bat
Core file executed by every script.
- Will find *.uproject file and set project name from it.
- Read Unreal Engine version from *.uproject.
- Find path in registry for this engine version.
- Set additional config vars.

***TODO - should be rewritten with python.***

---
### Core\config_archiver.bat
Core file executed by backup scripts only.
- Call `config.bat` first
- Set archive file suffix based on current date and time
- Set `7z.exe` path
- Set backup dir path

***TODO - read `%BACKUP_ROOT_DIR%` from config file. Current value is `e:\DATA\Backups`***

---
### Core\generate_readme.bat
Launch script for `generate_readme.py`
If launched with argument (should be directory path), pass it as script `--dir` argument (override root scan dir),
otherwise launch `generate_readme.py` without any arguments (in default mode will scan directory one level up)

---
### Core\generate_readme.py
Simple `README.md` generator. Scan and parse `*.bat` and `*.py` files, get first comment in file and generate Markdown text.
Text will be inserted between

`<!-- AUTO_GENERATED_CONTENT_START -->`

and

`<!-- AUTO_GENERATED_CONTENT_END -->`

comments or will be appended to the end of existing (or new) `README.md` file.

For `*.bat` get header comment block (started with `::`)

For `*.py` get module docstring value.

CLI options:
-  `--dir DIRECTORY`  Override root scan dir (type: str, default: directory one level up)
-  `--toc ENABLED`    Generate table of contents (type: int, default: 1)
---
### Core\utils.bat
Collection of utility functions to display messages to terminal

---
### Standalone\simple_backup.bat
Simple standalone backup script. Archive file or folder provided as argument to 'BACKUPS' subdir.
Based on https://gist.github.com/adamcaudill/2322221

Installation:

- Windows+R
- `shell:sendto` to open `SendTo` directory
- Create shortcut to `simple_backup.bat` in `SendTo` directory

Using:
- Right click on file or folder and select `Send to - Simple Backup`


---
### Standalone\standalone_resave_and_generate_DDC.bat
Place in project root dir and run to resave packages and generate DerivedDataCache for project.
Help to speed up first (or after engine version update) launch  of large project (City Sample, Lyra etc.)

- ***Note: unrealcmdpath is hardcoded, don't forget update it with correct engine path/version***

---
### backup_code.bat
Simple and fast backup for c++ code. Save to 7z archive Source and Config folders from Project and Project Plugins.
Archive placed to `%BACKUP_ROOT_DIR%` defined in `DevOps\Core\config_archiver.bat` file (default - `e:\DATA\Backups`).

---
### backup_from_gitignore.bat
Perform (almost) full backup of project.
- Stage 1. Create archive based on .gitignore in root project folder.
- Stage 2. Add extra files to archive (probably ignored by version control)
  - Content dir
  - *.DotSettings.user (Rider settings)
  - .idea\ (Rider settings)
  - Plugins Content, Config and Source dirs
  - Saved\Config\WindowsEditor\ (local configs)

Archive placed to `%BACKUP_ROOT_DIR%` defined in `DevOps\Core\config_archiver.bat` file (default - `e:\DATA\Backups`)

---
### build_cook_archive.bat
Build game with cooked content

---
### build_solution_development_editor.bat
Build solution for editor

---
### clean_intermediate_files.bat
Clean project and project plugins Binaries Intermediate Saved dirs.

**WARNING!**

This script will permanently delete folders and files from project.
Should be used with caution!

Dirs deleted from project:
- .vs
- Binaries
- Build
- DerivedDataCache
- Intermediate
- Saved\\Automation
- Saved\\Autosaves
- Saved\\Cooked
- Saved\\Crashes
- Saved\\Logs
- Saved\\MaterialStats
- Saved\\MaterialStatsDebug
- Saved\\Shaders
- Saved\\SourceControl
- Saved\\StagedBuilds
- Saved\\Temp
- Saved\\Config\\CrashReportClient

Files deleted from project:
- *.sln

Dirs deleted from project plugins:
- Plugins\\*\\Binaries
- Plugins\\*\\Intermediate
- Plugins\\*\\Saved

***NOTE - currently ignoring project plugins in sub dirs (like `Plugins\GameFeatures`)***

***TODO - this list should be autogenerated***

---
### generate_vs_project_files.bat
Generate Visual Studio solution

---
### rebuild_python_stub.bat
Manually generate python stub file for current project.
Generated file placed to
`%RootProjectDir%/Intermediate/PythonStub/unreal.py`

---
### rebuild_solution_development_editor.bat
Rebuild solution for editor

---
### rebuild_solution_game_shipping.bat
Rebuild solution for shipping

---
### resave.bat
Resave current project packages, fix redirectors

---
### resave_and_generate_DDC.bat
Resave current project packages, fix redirectors, generate DerivedDataCache

---
### validate_assets.bat
Perform command line assets validation

---
<!-- AUTO_GENERATED_CONTENT_END -->