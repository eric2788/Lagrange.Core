FROM mcr.microsoft.com/dotnet/sdk:7.0.403 AS build-env
WORKDIR /App

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish Lagrange.OneBot/Lagrange.OneBot.csproj \
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
