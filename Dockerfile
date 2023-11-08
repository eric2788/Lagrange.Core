FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build-env
WORKDIR /App

ARG TARGETARCH
ARG TARGETOS

COPY . ./
RUN dotnet restore -a $TARGETARCH
RUN dotnet publish Lagrange.OneBot/Lagrange.OneBot.csproj \
        -a $TARGETARCH \
        -c Release \
        -o out \
		--no-restore \
        --no-self-contained \
        -p:PublishSingleFile=true \
        -p:IncludeContentInSingleFile=true

		
FROM mcr.microsoft.com/dotnet/core/runtime-deps:7.0-alpine

WORKDIR /app
COPY --from=build-env /App/out .
COPY appsettings.onebot.json ./appsettings.json
ENTRYPOINT ["./Lagrange.OneBot"]
