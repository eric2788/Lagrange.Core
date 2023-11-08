FROM mcr.microsoft.com/dotnet/sdk:7.0.403-alpine3.18 AS build-env
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

		
FROM mcr.microsoft.com/dotnet/runtime:7.0.13-alpine3.18

WORKDIR /app
COPY --from=build-env /App/out .
COPY appsettings.onebot.json ./appsettings.json
ENTRYPOINT ["./Lagrange.OneBot"]
