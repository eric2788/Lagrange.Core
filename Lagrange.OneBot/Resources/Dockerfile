FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.18 AS build-env

WORKDIR /root/build
ARG TARGETARCH

COPY . /root/build

RUN dotnet publish -p:DebugType="none" -a $TARGETARCH -f "net8.0" -o "/root/out" "Lagrange.OneBot"

WORKDIR /root/build
RUN dotnet publish Lagrange.OneBot \
        -c Release \
        -a $TARGETARCH \
        -o out \
        -p:PublishSingleFile=true \
        --framework net8.0 \
        -o /root/out

FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine3.18
WORKDIR /app
COPY --from=build-env /App/out .
COPY Lagrange.OneBot/Resources/appsettings.docker.json ./appsettings.json
ENTRYPOINT ["./Lagrange.OneBot"]