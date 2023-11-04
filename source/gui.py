import os
import platform

IS_WIN = platform.system() == 'Windows'

from PyQt5.QtCore import pyqtSlot, pyqtProperty, pyqtSignal, QObject, QUrl
from PyQt5.QtGui import QDesktopServices
from PyQt5.QtWidgets import QApplication

import sql
import thumbnails
import misc
import git

SOURCE_REPO = "https://github.com/arenasys/PyQt5-QML-Template"

class GUI(QObject):
    updated = pyqtSignal()
    aboutToQuit = pyqtSignal()

    def __init__(self, parent):
        super().__init__(parent)
        self._db = sql.Database(self)
        self._thumbnails = thumbnails.ThumbnailStorage((256, 256), (640, 640), 75, self)
        parent.aboutToQuit.connect(self.stop)

        self._needRestart = False
        self._gitInfo = None
        self._currentGitCommit = None
        self._triedGitInit = False
        self._updating = False
        self.getGitInfo()

    @pyqtProperty('QString', notify=updated)
    def title(self):
        return "Template"

    @pyqtSlot()
    def stop(self):
        self.aboutToQuit.emit()

    @pyqtSlot()
    def quit(self):
        QApplication.quit()

    @pyqtSlot(str, result=bool)
    def isCached(self, file):
        return self._thumbnails.has(QUrl.fromLocalFile(file).toLocalFile(), (256,256))

    @pyqtSlot(str)
    def openPath(self, path):
        QDesktopServices.openUrl(QUrl.fromLocalFile(path))

    @pyqtSlot(str)
    def openLink(self, link):
        try:
            QDesktopServices.openUrl(QUrl.fromUserInput(link))
        except Exception:
            pass
    
    @pyqtSlot(list)
    def visitFiles(self, files):
        folder = os.path.dirname(files[0])
        if IS_WIN:
            try:
                misc.showFilesInExplorer(folder, files)
            except:
                pass
        else:
            self.openPath(folder)

    @pyqtProperty(str, notify=updated)
    def gitInfo(self):
        return self._gitInfo

    @pyqtProperty(bool, notify=updated)
    def needRestart(self):
        return self._needRestart
    
    @pyqtProperty(bool, notify=updated)
    def updating(self):
        return self._updating

    @pyqtSlot()
    def getGitInfo(self):
        self._gitInfo = "Unknown"
        commit, label = git.git_last(".")
        if commit:
            if self._currentGitCommit == None:
                self._currentGitCommit = commit
            self._gitInfo = label
            self._needRestart = self._currentGitCommit != commit
        elif not self._triedGitInit:
            self._triedGitInit = True
            git.gitInit(".", SOURCE_REPO)
        self.updated.emit()