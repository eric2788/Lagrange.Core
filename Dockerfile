FROM mcr.microsoft.com/dotnet/sdk:7.0-bullseye-slim-amd64 AS build

ARG TARGETARCH
ARG TARGETOS

RUN arch=$TARGETARCH \
    && if [ "$arch" = "amd64" ]; then arch="x64"; fi \
    && echo $TARGETOS-$arch > /tmp/rid

WORKDIR /source

COPY *.csproj .
    
RUN dotnet restore -r $(cat /tmp/rid)

COPY . .
RUN dotnet publish -c Release -o /app -r $(cat /tmp/rid) --self-contained false --no-restore


FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "Lagrange.OneBot.dll"]