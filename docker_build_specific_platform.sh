#!/bin/bash
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
if [ $# -ne 2 ]
then
      echo "Usage: $"me" os arch"
      echo "e.g.: $"me" linux amd64"
      echo "Cmd line received: $@"
else
	IMG=golang:1.24.5
	GOOS=$1
	GOARCH=$2

	# Fase 1: Aggiorna le dipendenze
	echo "📦 Aggiornamento dipendenze..."
	rm go.mod go.sum
	docker run --rm -v "$PWD":/app -w /app $IMG go mod init github.com/molpie/speedtest_exporter
	docker run --rm -v "$PWD":/app -w /app $IMG sh -c "go get -u /app/... && go mod tidy && go mod verify"

	# Fase 2: Compila il progetto
	echo "🔨 Compilazione per $GOOS/$GOARCH..."
	docker run --rm -v "$PWD":/app -w /app -e GOOS=$GOOS -e GOARCH=$GOARCH $IMG go build -v -o speedtest_exporter-$GOOS-$GOARCH 
	if [ "$GOARCH" == "arm" ]; then
		GOARM=6
		docker run --rm -v "$PWD":/app -w /app -e GOOS=$GOOS -e GOARCH=$GOARCH -e GOARM=$GOARM $IMG go build -v -o speedtest_exporter-"$GOOS"-"$GOARCH""$GOARM" 
		mv speedtest_exporter-$GOOS-$GOARCH speedtest_exporter-"$GOOS"-"$GOARCH"7
	fi
	if [ "$GOOS" == "windows" ]; then
		mv speedtest_exporter-$GOOS-$GOARCH speedtest_exporter-$GOOS-$GOARCH.exe
	fi
fi
