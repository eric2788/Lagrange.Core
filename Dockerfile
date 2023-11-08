FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build-env
WORKDIR /App

ARG TARGETARCH
ARG TARGETOS

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore -a $TARGETARCH
# Build and publish a release
RUN dotnet publish Lagrange.OneBot/Lagrange.OneBot.csproj \
        -a $TARGETARCH \
        -c Release \
        -o out \
		--no-restore \
        --no-self-contained \
        -p:PublishSingleFile=true \
        -p:IncludeContentInSingleFile=true

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app
COPY --from=build-env /App/out .
COPY appsettings.onebot.json ./appsettings.json
ENTRYPOINT ["./Lagrange.OneBot"]
