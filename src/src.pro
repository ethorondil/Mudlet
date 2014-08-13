QMAKE_CXXFLAGS_RELEASE += -O3 -Wno-deprecated-declarations -Wno-unused-local-typedefs -Wno-unused-parameter
QMAKE_CXXFLAGS_DEBUG += -O0 -Wno-deprecated-declarations -Wno-unused-local-typedefs -Wno-unused-parameter
#MOC_DIR = ./tmp
#OBJECTS_DIR = ./tmp

QT += network opengl

lessThan( QT_MAJOR_VERSION, 5 ) {
    CONFIG += qt resources app_bundle uitools
    QT += phonon
} else {
    QT += uitools multimedia
}

# Set the current Mudlet Version, unfortunately the Qt documentation suggests
# that only a #.#.# form without any other alphanumberic suffixes is required:
VERSION = 3.0.1

# Leave the value of the following empty, line should be "BUILD =" without quotes
# (it is NOT a Qt built-in variable) for a release build or, if you are
# distributing modified code, it would be useful if you could put something to
# distinguish the version:
BUILD = -rc2_chris7_mudletdev

# Changing the above pair of values affects: ctelnet.cpp, main.cpp, mudlet.cpp
# dlgAboutDialog.cpp and TLuaInterpreter.cpp.  It does NOT cause those files to
# be automatically rebuilt so you will need to 'touch' them...!
# Use APP_VERSION, APP_BUILD and APP_TARGET defines in the source code if needed.
DEFINES += APP_VERSION=\\\"$${VERSION}\\\"
DEFINES += APP_BUILD=\\\"$${BUILD}\\\"
win32{
    TARGET = mudlet
} else:macx{
    TARGET = Mudlet
} else{
    TARGET = mudlet
}

# Create a record of what the executable will be called by hand
# NB. "cygwin-g++" although a subset of "unix" NOT "win32" DOES create
# executables with an ".exe" extension!
DEFINES += APP_TARGET=\\\"$${TARGET}$${TARGET_EXT}\\\"

DEPENDPATH += .
INCLUDEPATH += .
LIBLUA = -llua5.1
#!exists(/usr/lib/x86_64-linux-gnu/liblua5.1.a):LIBLUA = -llua

# automatically link to LuaJIT if it exists
#exists(/usr/lib/x86_64-linux-gnu/libluajit-5.1.a):LIBLUA = -L/usr/lib/x86_64-linux-gnu/ -lluajit-5.1

TEMPLATE = app
RESOURCES = mudlet_alpha.qrc

# try -O1 —fsanitize=address for AddressSanitizer w/ clang
# use -DDEBUG_TELNET to show telnet commands

# Specify default location for Lua files, in OS specific LUA_DEFAULT_DIR value
# below, if this is not done then a hardcoded default of a ./mudlet-lua/lua
# from the executable's location will be used.  Mudlet will now moan and ask
# the user to find them if the files (and specifically the <10KByte
# "LuaGlobal.lua" one) is not accessable (read access only required) during
# startup.  The precise directory is remembered once found (and stored in the
# Mudlet configuration file as "systemLuaFilePath") but if the installer places
# the files in the place documented here the user will not be bothered by this.
#
# (Geyser files should be in a "geyser" subdirectory of this)
unix: {
# Distribution packagers would be using PREFIX = /usr but this is accepted
# destination place for local builds for software for all users:
    isEmpty( PREFIX ) PREFIX = /usr/local
    isEmpty( DATAROOTDIR ) DATAROOTDIR = $${PREFIX}/share
    isEmpty( DATADIR ) DATADIR = $${DATAROOTDIR}/mudlet
# According to Linux FHS /usr/local/games is an alternative location for leasure time BINARIES 8-):
    isEmpty( BINDIR ) BINDIR = $${PREFIX}/bin
# Again according to FHS /usr/local/share/games is the corresponding place for locally built games documentation:
    isEmpty( DOCDIR ) DOCDIR = $${DATAROOTDIR}/doc/mudlet
    LIBS += -lpcre \
        $$LIBLUA \
        -lhunspell \
        -L/usr/local/lib/ \
        -lyajl \
        -lGLU \
        -lzip \
        -lz
    INCLUDEPATH += /usr/include/lua5.1
    LUA_DEFAULT_DIR = $${DATADIR}/lua
} else:win32: {
    LIBS += -L"C:\\mudlet5_package" \
        -L"C:\\mingw32\\lib" \
        -llua51 \
        -lpcre \
        -lhunspell \
        -llibzip \
        -lzlib \
        -llibzip \
        -L"C:\\mudlet5_package\\yajl-master\\yajl-2.0.5\\lib" \
        -lyajl
    INCLUDEPATH += "c:\\mudlet_package_MINGW\\Lua_src\\include" \
        "C:\\mingw32\\include" \
        "c:\\mudlet_package_MINGW\\zlib-1.2.5" \
        "C:\\mudlet5_package\\boost_1_54_0" \
        "c:\\mudlet_package_MINGW\\pcre-8.0-lib\\include" \
        "C:\\mudlet5_package\\yajl-master\\yajl-2.0.5\\include" \
        "C:\\mudlet5_package\\libzip-0.11.1\\lib" \
        "C:\\mudlet_package_MINGW\\hunspell-1.3.1\\src"
# Leave this undefined so mudlet::readSettings() preprocessing will fall back to
# hard-coded executable's /mudlet-lua/lua/ subdirectory
#    LUA_DEFAULT_DIR = $$clean_path($$system(echo %ProgramFiles%)/lua)
}
unix {
#   the "target" install set is handled automagically, just not very well...
    target.path = $${BINDIR}
    message("$${TARGET} will be installed to "$${target.path}"...")
#     DOCS.path = $${DOCS_DIR}
#     message("Documentation will be installed to "$${DOCS.path}"...")
    !isEmpty( LUA_DEFAULT_DIR ) {
# if a directory has been set for the lua files move the detail into the
# installation details for the unix case:
        LUA.path = $${LUA_DEFAULT_DIR}
        LUA_GEYSER.path = $${LUA.path}/geyser
# and define a preprocessor symbol LUA_DEFAULT_PATH with the value:
        DEFINES += LUA_DEFAULT_PATH=\\\"$${LUA_DEFAULT_DIR}\\\"
# and say what will happen:
        message("Lua files will be installed to "$${LUA.path}"...")
        message("Geyser lua files will be installed to "$${LUA_GEYSER.path}"...")
    }
}
INCLUDEPATH += irc/include
SOURCES += \
    ActionUnit.cpp \
    AliasUnit.cpp \
    ctelnet.cpp \
    dlgAboutDialog.cpp \
    dlgActionMainArea.cpp \
    dlgAliasMainArea.cpp \
    dlgColorTrigger.cpp \
    dlgComposer.cpp \
    dlgConnectionProfiles.cpp \
    dlgIRC.cpp \
    dlgKeysMainArea.cpp \
    dlgMapper.cpp \
    dlgNotepad.cpp \
    dlgOptionsAreaAction.cpp \
    dlgOptionsAreaAlias.cpp \
    dlgOptionsAreaScripts.cpp \
    dlgOptionsAreaTimers.cpp \
    dlgOptionsAreaTriggers.cpp \
    dlgPackageExporter.cpp \
    dlgProfilePreferences.cpp \
    dlgRoomExits.cpp \
    dlgScriptsMainArea.cpp \
    dlgSearchArea.cpp \
    dlgSourceEditorArea.cpp \
    dlgSystemMessageArea.cpp \
    dlgTimersMainArea.cpp \
    dlgTriggerEditor.cpp \
    dlgTriggerPatternEdit.cpp \
    dlgTriggersMainArea.cpp \
    dlgVarsMainArea.cpp \
    EAction.cpp \
    exitstreewidget.cpp \
    FontManager.cpp \
    glwidget.cpp \
    Host.cpp \
    HostManager.cpp \
    HostPool.cpp \
    irc/src/ircbuffer.cpp \
    irc/src/irc.cpp \
    irc/src/ircsession.cpp \
    irc/src/ircutil.cpp \
    KeyUnit.cpp \
    LuaInterface.cpp \
    lua_yajl.c \
    main.cpp \
    mudlet.cpp \
    ScriptUnit.cpp \
    T2DMap.cpp \
    TAction.cpp \
    TAlias.cpp \
    TArea.cpp \
    TBuffer.cpp \
    TCommandLine.cpp \
    TConsole.cpp \
    TDebug.cpp \
    TEasyButtonBar.cpp \
    TFlipButton.cpp \
    TForkedProcess.cpp \
    THighlighter.cpp \
    TimerUnit.cpp \
    TKey.cpp \
    TLabel.cpp \
    TLuaInterpreter.cpp \
    TMap.cpp \
    TriggerUnit.cpp \
    TRoom.cpp \
    TRoomDB.cpp \
    TScript.cpp \
    TSplitter.cpp \
    TSplitterHandle.cpp \
    TTextEdit.cpp \
    TTimer.cpp \
    TToolBar.cpp \
    TTreeWidget.cpp \
    TTreeWidgetItem.cpp \
    TTrigger.cpp \
    TVar.cpp \
    XMLexport.cpp \
    XMLimport.cpp \
    VarUnit.cpp


HEADERS += \
    ActionUnit.h \
    AliasUnit.h \
    ctelnet.h \
    dlgAboutDialog.h \
    dlgActionMainArea.h \
    dlgAliasMainArea.h \
    dlgColorTrigger.h \
    dlgComposer.h \
    dlgConnectionProfiles.h \
    dlgIRC.h \
    dlgKeysMainArea.h \
    dlgMapper.h \
    dlgNotepad.h \
    dlgOptionsAreaAction.h \
    dlgOptionsAreaAlias.h \
    dlgOptionsAreaScripts.h \
    dlgOptionsAreaTimers.h \
    dlgOptionsAreaTriggers.h \
    dlgPackageExporter.h \
    dlgProfilePreferences.h \
    dlgRoomExits.h \
    dlgScriptsMainArea.h \
    dlgSearchArea.h \
    dlgSourceEditorArea.h \
    dlgSystemMessageArea.h \
    dlgTriggerEditor.h \
    dlgTriggersMainArea.h \
    dlgTriggerPatternEdit.h \
    dlgTimersMainArea.h \
    dlgVarsMainArea.h \
    EAction.h \
    exitstreewidget.h \
    glwidget.h \
    Host.h \
    HostManager.h \
    HostPool.h \
    irc/include/irc.h \
    irc/include/ircbuffer.h \
    irc/include/ircsession.h \
    irc/include/ircutil.h \
    KeyUnit.h \
    LuaInterface.h \
    mudlet.h \
    ScriptUnit.h \
    T2DMap.h \
    TAction.h \
    TAlias.h \
    TArea.h \
    TAStar.h \
    TBuffer.h \
    TCommandLine.h \
    TConsole.h \
    TDebug.h \
    TEasyButtonBar.h \
    TEvent.h \
    TFlipButton.h \
    TForkedProcess.h \
    THighlighter.h \
    TLabel.h \
    TLuaInterpreter.h \
    TimerUnit.h \
    TKey.h \
    TMap.h \
    TMatchState.h \
    Tree.h \
    TriggerUnit.h \
    TRoom.h \
    TRoomDB.h \
    TScript.h \
    TSplitter.h \
    TSplitterHandle.h \
    TTextEdit.h \
    TTimer.h \
    TToolBar.h \
    TTreeWidget.h \
    TTreeWidgetItem.h \
    TTrigger.h \
    TVar.h \
    VarUnit.h


FORMS += \
    ui/about_dialog.ui \
    ui/actions_main_area.ui \
    ui/aliases_main_area.ui \
    ui/color_trigger.ui \
    ui/composer.ui \
    ui/connection_profiles.ui \
    ui/custom_lines.ui \
    ui/dlgPackageExporter.ui \
    ui/extended_search_area.ui \
    ui/irc.ui \
    ui/lacking_mapper_script.ui \
    ui/keybindings_main_area.ui \
    ui/main_window.ui \
    ui/mapper.ui \
    ui/module_manager.ui \
    ui/notes_editor.ui \
    ui/options_area_actions.ui \
    ui/options_area_aliases.ui \
    ui/options_area_scripts.ui \
    ui/options_area_timers.ui \
    ui/options_area_triggers.ui \
    ui/package_manager.ui \
    ui/package_manager_unpack.ui \
    ui/profile_preferences.ui \
    ui/room_exits.ui \
    ui/scripts_main_area.ui \
    ui/source_editor_area.ui \
    ui/system_message_area.ui \
    ui/timers_main_area.ui \
    ui/trigger_editor.ui \
    ui/trigger_pattern_edit.ui \
    ui/triggers_main_area.ui \
    ui/vars_main_area.ui

# To use QtCreator as a Unix installer the generated Makefile must have the
# following lists of files EXPLICITLY stated - IT IS NOT WORKABLE IF ONLY
# A PATH IS GIVEN AS AN ENTRY TO THE .files LIST - as was the case for a
# previous incarnation for macs.
#
# Select Qt Creator's "Project" Side tab and under the "Build and Run" top tab
# choose your Build Kit's "Run"->"Run Settings" ensure you have a "Make" step
# that - if you are NOT runnning QT Creator as root, which is the safest way
# (i.e safe = NOT root) - against:
# "Override <path to?>/make" has the entry: "/usr/bin/sudo"
# without the quotes, assuming /usr/bin is the location of "sudo"
# and against:
# "Make arguments" has the entry: "-A sh -c '/usr/bin/make install'"
# without the DOUBLE quotes but with the SINGLE quotes, assuming /usr/bin is the
# location of "make"
#
# This then will run "make install" via sudo with root privileges when you use
# the relevant "Deploy" option on the "Build" menu - and will ask you for YOUR
# password via a GUI dialog if needed - so that the files can be placed in the
# specified system directories to which a normal user (you?) does not have write
# access normally.

# Main lua files:
LUA.files = \
    $${PWD}/mudlet-lua/lua/LuaGlobal.lua \
    $${PWD}/mudlet-lua/lua/StringUtils.lua \
    $${PWD}/mudlet-lua/lua/TableUtils.lua \
    $${PWD}/mudlet-lua/lua/DebugTools.lua \
    $${PWD}/mudlet-lua/lua/DB.lua \
    $${PWD}/mudlet-lua/lua/GUIUtils.lua \
    $${PWD}/mudlet-lua/lua/Other.lua \
    $${PWD}/mudlet-lua/lua/GMCP.lua
LUA.depends = mudlet

# Geyser lua files:
LUA_GEYSER.files = \
    $${PWD}/mudlet-lua/lua/geyser/Geyser.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserGeyser.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserUtil.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserColor.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserSetConstraints.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserContainer.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserWindow.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserLabel.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserGauge.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserMiniConsole.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserMapper.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserReposition.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserHBox.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserVBox.lua \
    $${PWD}/mudlet-lua/lua/geyser/GeyserTests.lua
LUA_GEYSER.depends = mudlet

# Documentation files:
# DOCS.files =


# Pull the docs and lua files into the project so they show up in the Qt Creator project files list
OTHER_FILES += \
#     ${DOCS.files} \
    ${LUA.files} \
    ${LUA_GEYSER.files} \
    ../README \
    ../COMPILE \
    ../COPYING \
    ../Doxyfile \
    ../INSTALL

# Unix Makefile installer:
# lua file installation, needs install, sudo, and a setting in /etc/sudo.conf
# or via enviromental variable SUDO_ASKPASS to something like ssh-askpass
# to provide a graphic password requestor needed to install software
unix {
# say what we want to get installed by "make install" (executed by 'deployment' step):
    INSTALLS += \
        target \
        LUA \
        LUA_GEYSER
}
# Other OS's have other installation routines - perhap they could be duplicated here?
