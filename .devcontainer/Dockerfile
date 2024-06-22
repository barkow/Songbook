#FROM axelbarkow/songbook:1.0
FROM ubuntu:18.04

RUN apt-get update
#Das nachfolgende Kommando macht ggf. Probleme beim Ausführen durch docker. ggf. auskommentieren und händisch installieren
RUN DEBIAN_FRONTEND='noninteractive' TZ=Etc/UTC apt-get install -y texlive texlive-music texlive-latex-extra lilypond texlive-font-utils make git
