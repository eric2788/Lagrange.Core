FROM mcr.microsoft.com/dotnet/sdk:7.0-bullseye-slim-amd64 AS build

ARG TARGETARCH
ARG TARGETOS

RUN arch=$TARGETARCH \
    && if [ "$arch" = "amd64" ]; then arch="x64"; fi \
    && echo $TARGETOS-$arch > /tmp/rid

WORKDIR /source

COPY . .
    
RUN dotnet restore -r $(cat /tmp/rid)
RUN dotnet publish Lagrange.OneBot/Lagrange.OneBot.csproj \
        -c Release \
        -o /app \
        -r $(cat /tmp/rid) \
        --no-restore \
        --no-self-contained \
        -p:PublishSingleFile=true \
        -p:IncludeContentInSingleFile=true \
		/p:PublishTrimmed=true


FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app
COPY --from=build /app .
COPY appsettings.onebot.json ./appsettings.json
ENTRYPOINT ["./Lagrange.OneBot"]